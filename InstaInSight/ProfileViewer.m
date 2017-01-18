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
    [self FetchFollowers];
    
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

-(void)FetchFollowers
{
    [actView startAnimating];
    
    
    [[InstagramEngine sharedEngine] getFollowersOfUser:[[InstaUser sharedUserInstance] instaUserId] withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
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
                UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:@"No record found" preferredStyle:UIAlertControllerStyleAlert];
                
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
    NSMutableArray *tempArray=[arrRandomFollower mutableCopy];
    
    if (tempArray.count>0) {
        arrAllFollowers=[[NSMutableArray alloc] init];
        Followers *objFollow=[tempArray firstObject];
        [[InstagramEngine sharedEngine] getFollowersOfUser:objFollow.followerId withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
            
            [arrAllFollowers addObjectsFromArray:users];
            [tempArray removeObject:objFollow];
            if (tempArray.count>0) {
                [self DownloadAllFollowers];
            }
            else
            {
                NSMutableArray *arrUsersId=[[NSMutableArray alloc] init];
                [arrAllFollowers enumerateObjectsUsingBlock:^(InstagramUser  *_Nonnull objuser, NSUInteger idx, BOOL * _Nonnull stop) {
                    [arrUsersId addObject:objuser.userId];
                }];
                
                NSCountedSet *totalSet = [NSCountedSet setWithArray:arrUsersId];
                NSMutableArray *dictArray = [NSMutableArray array];
                for (NSString *userId in totalSet) {
                    NSDictionary *dict = @{@"userId":userId, @"count":@([totalSet countForObject:userId])};
                    [dictArray addObject:dict];
                }
                NSArray *final = [dictArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO]]];
                NSLog(@"%@",final);
                
                [final enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull objDicc, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSArray *arrDatas=[arrRandomFollower filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"followerId = %@",[objDicc valueForKey:@"userId"]]];
                    if (arrDatas.count>0) {
                        
                        Followers *follower=[arrDatas firstObject];
                        [arrProfileViewer addObject:[Followers fetchAndUpdateHasFollowFlagForId:follower.followerId AndCount:[NSString stringWithFormat:@"%@",[objDicc valueForKey:@"count"]]]];
                    }
                }];
                
                NSLog(@"arrProfileViewer= %@",arrProfileViewer);
                
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
    [cell CheckForFollowUnFollow:objUser.followerId];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
