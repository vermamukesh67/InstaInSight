//
//  NotFollowBack.m
//  InstaInSight
//
//  Created by Mukesh Verma on 16/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import "NotFollowBack.h"

@interface NotFollowBack ()

@end

@implementation NotFollowBack

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Unfollowers"];
    arrNotFollowingBack=[[NSMutableArray alloc] init];
    [tblFollowing setHidden:YES];
    tblFollowing.tableFooterView = [UIView new];
    [self CheckIamNotFollowingBack];
    
    [FIRAnalytics setScreenName:@"Unfollowers" screenClass:@"Unfollowers"];
    [self setScreenName:@"Unfollowers"];
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
        });
        
        [[InstagramEngine sharedEngine] getUsersFollowedByUser:[[InstaUser sharedUserInstance] instaUserId] withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
            
            NSLog(@"users = %@",users);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [users enumerateObjectsUsingBlock:^(InstagramUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [Following saveFollowingsList:obj];
                }];
                
                NSArray *arrNewFollowers=[Following fetchFollowingsDetails];
                
                [arrNewFollowers enumerateObjectsUsingBlock:^(Following  *_Nonnull objF, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([Followers fetchFollowersById:objF.followingId]==nil) {
                        [arrNotFollowingBack addObject:objF];
                    }
                }];
                
                [tblFollowing setHidden:NO];
                [tblFollowing reloadData];
                [actView stopAnimating];
                if (arrNotFollowingBack.count==0) {
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
            });
            
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            
            NSLog(@"error = %@",error);
            [actView stopAnimating];
            if (error!=nil && ![error isKindOfClass:[NSNull class]] && [error isKindOfClass:[NSError class]]) {
                [HelperMethod ShowAlertWithMessage:[error localizedDescription] InViewController:self];
            }
        }];
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
        NSLog(@"error = %@",error);
        [actView stopAnimating];
        if (error!=nil && ![error isKindOfClass:[NSNull class]] && [error isKindOfClass:[NSError class]]) {
            [HelperMethod ShowAlertWithMessage:[error localizedDescription] InViewController:self];
        }
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrNotFollowingBack.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    Following *objUser=[arrNotFollowingBack objectAtIndex:indexPath.row];
    [cell.imgProfile sd_setImageWithURL:[NSURL URLWithString:[objUser profilePictureURL]] placeholderImage:[UIImage imageNamed:@"defaultlist"]];
    [cell.lblName setText:[objUser fullName]];
    [cell CheckForFollowUnFollow:objUser.followingId];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
