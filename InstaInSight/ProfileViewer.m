//
//  ProfileViewer.m
//  InstaInSight
//
//  Created by Mukesh Verma on 16/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import "ProfileViewer.h"

@interface ProfileViewer ()

@end

@implementation ProfileViewer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Profile Viewer"];
    arrProfileViewer=[[NSMutableArray alloc] init];
    arrRandomFollower=[[NSMutableArray alloc] init];
    diccRandomFollowers=[[NSMutableDictionary alloc] init];
    [tblProfile setHidden:YES];
    tblProfile.tableFooterView = [UIView new];
    [self CheckIamNotFollowingBack];
    
    [FIRAnalytics setScreenName:@"ProfileViewer" screenClass:@"ProfileViewer"];
    [self setScreenName:@"ProfileViewer"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)CheckIamNotFollowingBack
{
    [actView startAnimating];
    
    
    [[InstagramEngine sharedEngine] getFollowersOfUser:[[InstaUser sharedUserInstance] instaUserId] withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [users enumerateObjectsUsingBlock:^(InstagramUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [Followers saveFollowersList:obj];
            }];
            
            arrRandomFollower=[[NSMutableArray alloc] initWithArray:[[Followers fetchFollowersDetails] randomSelectionWithCount:20]];
            
            if (arrRandomFollower.count>0) {
                
                [self DownloadAllFollowers];
            }
            else
            {
                [tblProfile setHidden:NO];
                [tblProfile reloadData];
                [actView stopAnimating];
                if (arrProfileViewer.count==0) {
                    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:@"No Record found" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [alertVC dismissViewControllerAnimated:YES completion:nil];
                                             [self.navigationController popViewControllerAnimated:YES];
                                             
                                         }];
                    
                    [alertVC addAction:ok];
                    [self presentViewController:alertVC animated:YES completion:^{
                        
                    }];
                }
            }
            
        });
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
        NSLog(@"error = %@",error);
        [actView stopAnimating];
        if (error!=nil && ![error isKindOfClass:[NSNull class]] && [error isKindOfClass:[NSError class]]) {
            [HelperMethod ShowAlertWithMessage:[error localizedDescription] InViewController:self];
        }
    }];
}

-(void)DownloadAllFollowers
{
    if (arrRandomFollower.count>0) {
        Followers *objFollow=[arrRandomFollower firstObject];
        [[InstagramEngine sharedEngine] getFollowersOfUser:objFollow.followerId withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
            
           __block NSInteger mutualCount=0;
            [users enumerateObjectsUsingBlock:^(InstagramUser  *_Nonnull objMutualFollow, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([Followers fetchFollowersById:objMutualFollow.userId]) {
                    
                    mutualCount++;
                }
            }];
            
            [Followers fetchAndUpdateHasFollowFlagForId:objFollow.followerId AndCount:[NSString stringWithFormat:@"%li",mutualCount]];
            
            [arrRandomFollower removeObject:objFollow];
            
            if (arrRandomFollower.count>0) {
               [self DownloadAllFollowers];
            }
            else
            {
                arrProfileViewer=[[NSMutableArray alloc] initWithArray:[Followers fetchFollowersByHasMutualFollow]];
                
            }
            
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            
            NSLog(@"error = %@",error);
            [actView stopAnimating];
            if (error!=nil && ![error isKindOfClass:[NSNull class]] && [error isKindOfClass:[NSError class]]) {
                [HelperMethod ShowAlertWithMessage:[error localizedDescription] InViewController:self];
            }
        }];
    }
    
    
}

/*
-(void)DownloadAllFollowers
{
    if (arrRandomFollower.count>0) {
        Followers *objFollow=[arrRandomFollower firstObject];
        [[InstagramEngine sharedEngine] getFollowersOfUser:objFollow.followerId withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
            
            [diccRandomFollowers setObject:users forKey:objFollow.followerId];
            if (arrRandomFollower.count>0) {
                [self DownloadAllFollowers];
            }
            else
            {
                NSLog(@"diccRandomFollowers = %@",diccRandomFollowers);
                NSArray *allKeys=[diccRandomFollowers allKeys];
                if (allKeys.count>0) {
                    
                    [allKeys enumerateObjectsUsingBlock:^(NSString  *_Nonnull strKey, NSUInteger idx, BOOL * _Nonnull stop) {
                       
                      __block  NSInteger mutualCount=0;
                        NSArray *arrMutualFollowers=[diccRandomFollowers objectForKey:strKey];
                        
                        [arrMutualFollowers enumerateObjectsUsingBlock:^(Followers  *_Nonnull objMutualFollow, NSUInteger idx, BOOL * _Nonnull stop) {
                           
                            if ([Followers fetchFollowersById:objMutualFollow.followerId]) {
                                
                                mutualCount++;
                            }
                            
                        }];
                        
                        [Followers fetchAndUpdateHasFollowFlagForId:strKey AndCount:[NSString stringWithFormat:@"%li",mutualCount]];
                    }];
                    
                }
                
            }
            
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            
            NSLog(@"error = %@",error);
            [actView stopAnimating];
            if (error!=nil && ![error isKindOfClass:[NSNull class]] && [error isKindOfClass:[NSError class]]) {
                [HelperMethod ShowAlertWithMessage:[error localizedDescription] InViewController:self];
            }
        }];
    }
    
   
}
 */

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrProfileViewer.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    Followers *objUser=[arrProfileViewer objectAtIndex:indexPath.row];
    [cell.imgProfile sd_setImageWithURL:[NSURL URLWithString:[objUser profilePictureURL]] placeholderImage:[UIImage imageNamed:@"defaultlist"]];
    [cell.lblName setText:[objUser fullName]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
