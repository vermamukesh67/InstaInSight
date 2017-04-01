//
//  GhostFollowers.m
//  InstaInSight
//
//  Created by Verma Mukesh on 18/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import "GhostFollowers.h"

@interface GhostFollowers ()

@end

@implementation GhostFollowers

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Ghost Followers"];
    arrTopLikers=[[NSMutableArray alloc] init];
    arrTotalLikers=[[NSMutableArray alloc] init];
    arrTopMedia=[[NSMutableArray alloc] init];
    arrFollowers=[[NSMutableArray alloc] init];
    [tblGhostFollowers setHidden:YES];
    tblGhostFollowers.tableFooterView = [UIView new];
    [self GetFollowers];
    [FIRAnalytics setScreenName:@"GhostFollowers" screenClass:@"GhostFollowers"];
    [self setScreenName:@"GhostFollowers"];
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

-(void)GetFollowers
{
    [actView startAnimating];
    
    [[InstagramEngine sharedEngine] getFollowersOfUser:[[InstaUser sharedUserInstance] instaUserId] withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        NSLog(@"users = %@",users);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [users enumerateObjectsUsingBlock:^(InstagramUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrFollowers addObject:[Followers saveFollowersList:obj]];
            }];
            
            [self FetchRecentFeeds];
        });
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
        NSLog(@"error = %@",error);
        [actView stopAnimating];
        if (error!=nil && ![error isKindOfClass:[NSNull class]] && [error isKindOfClass:[NSError class]]) {
            [HelperMethod ShowAlertWithMessage:[error localizedDescription] InViewController:self];
        }
    }];
    
}

-(void)FetchRecentFeeds
{
    [actView startAnimating];
    
    [[InstagramEngine sharedEngine] getSelfRecentMediaWithCount:50 maxId:nil success:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        NSLog(@"media = %@",media);
        arrTopMedia=[[NSMutableArray alloc] initWithArray:media];
        [self GetLikesForMedia];
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        NSLog(@"error = %@",error);
        [actView stopAnimating];
        if (error!=nil && ![error isKindOfClass:[NSNull class]] && [error isKindOfClass:[NSError class]]) {
            [HelperMethod ShowAlertWithMessage:[error localizedDescription] InViewController:self];
        }
    }];
}

-(void)GetLikesForMedia
{
    if (arrTopMedia.count >0) {
        
        InstagramMedia *instaMedia=[arrTopMedia firstObject];
        
        [[InstagramEngine sharedEngine] getLikesOnMedia:instaMedia.Id withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
            
            NSLog(@"%@",users);
            
            [arrTopMedia removeObject:instaMedia];
            
            [arrTotalLikers addObjectsFromArray:users];
            
            if (arrTopMedia.count>0) {
                
                [self GetLikesForMedia];
            }
            else
            {
                if (arrTotalLikers.count==0) {
                    
                }
                else
                {
                    [arrTotalLikers enumerateObjectsUsingBlock:^(InstagramUser  *_Nonnull objuser, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSArray *arrDatas=[arrFollowers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"followerId = %@",objuser.userId]];
                        if (arrDatas.count>0) {
                            [arrFollowers removeObjectsInArray:arrDatas];
                        }
                    }];
                    
                }
                
                if (arrFollowers.count==0) {
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
                
                [tblGhostFollowers reloadData];
                [tblGhostFollowers setHidden:NO];
                [actView stopAnimating];
                
            }
            
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            
             [arrTopMedia removeObject:instaMedia];
             [self CallAgainLikesForMedia];
        }];
    }
}

-(void)CallAgainLikesForMedia
{
    if (arrTopMedia.count>0) {
        
        [self GetLikesForMedia];
    }
    else
    {
        if (arrTotalLikers.count==0) {
            
        }
        else
        {
            [arrTotalLikers enumerateObjectsUsingBlock:^(InstagramUser  *_Nonnull objuser, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *arrDatas=[arrFollowers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"followerId = %@",objuser.userId]];
                if (arrDatas.count>0) {
                    [arrFollowers removeObjectsInArray:arrDatas];
                }
            }];
            
        }
        
        if (arrFollowers.count==0) {
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
        
        [tblGhostFollowers reloadData];
        [tblGhostFollowers setHidden:NO];
        [actView stopAnimating];
        
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrFollowers.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    Followers *objUser=[arrFollowers objectAtIndex:indexPath.row];
    [cell.imgProfile sd_setImageWithURL:[NSURL URLWithString:objUser.profilePictureURL] placeholderImage:[UIImage imageNamed:@"defaultlist"]];
    [cell.lblName setText:[objUser fullName]];
    [cell CheckForFollowUnFollow:objUser.followerId];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
