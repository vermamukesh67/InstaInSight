//
//  PopularFollower.m
//  InstaInSight
//
//  Created by Verma Mukesh on 01/02/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import "PopularFollower.h"

@interface PopularFollower ()

@end

@implementation PopularFollower

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Most Popular Followers"];
    arrPopularFollowers=[[NSMutableArray alloc] init];
    [tblPopularsFollowers setHidden:YES];
    tblPopularsFollowers.tableFooterView = [UIView new];
    [self GetFollowers];
    [FIRAnalytics setScreenName:@"MostPopularFollowers" screenClass:@"MostPopularFollowers"];
    [self setScreenName:@"MostPopularFollowers"];
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
        arrFollowers=[[NSMutableArray alloc] initWithArray:users];
        [self GetAllUserDetails];
       
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
        NSLog(@"error = %@",error);
        [actView stopAnimating];
        if (error!=nil && ![error isKindOfClass:[NSNull class]] && [error isKindOfClass:[NSError class]]) {
            [HelperMethod ShowAlertWithMessage:[error localizedDescription] InViewController:self];
        }
    }];
}

-(void)GetAllUserDetails
{
    if (arrFollowers.count>0) {
        
        InstagramUser *objInstaUser=[arrFollowers firstObject];
        
        [[InstagramEngine sharedEngine] getUserDetails:objInstaUser.userId withSuccess:^(InstagramUser * _Nonnull user) {
            
            [arrFollowers removeObject:objInstaUser];
            [arrPopularFollowers addObject:[Followers saveFollowersList:user]];
            
            if (arrFollowers.count>0 ) {
              
                [self GetAllUserDetails];
                
            }
            else
            {
                [arrPopularFollowers sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"hisFollowerCount" ascending:NO]]];
                
                [arrPopularFollowers enumerateObjectsUsingBlock:^(Followers *objUser, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if (([objUser.followerId isEqualToString:[InstaUser sharedUserInstance].objInstaUser.userId])) {
                        
                        [arrPopularFollowers removeObjectAtIndex:idx];
                        *stop = YES;
                    }
                    
                }];
                
                [tblPopularsFollowers reloadData];
                [tblPopularsFollowers setHidden:NO];
                [actView stopAnimating];
                
                if (arrPopularFollowers.count==0) {
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
            
            [arrFollowers removeObject:objInstaUser];
            
            if (arrFollowers.count>0 ) {
                
                [self GetAllUserDetails];
                
            }
            else
            {
                [arrPopularFollowers sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"hisFollowerCount" ascending:NO]]];
                
                [arrPopularFollowers enumerateObjectsUsingBlock:^(Followers *objUser, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if (([objUser.followerId isEqualToString:[InstaUser sharedUserInstance].objInstaUser.userId])) {
                        
                        [arrPopularFollowers removeObjectAtIndex:idx];
                        *stop = YES;
                    }
                    
                }];
                
                [tblPopularsFollowers reloadData];
                [tblPopularsFollowers setHidden:NO];
                [actView stopAnimating];
                
                if (arrPopularFollowers.count==0) {
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
            
        }];
        
    }
    else
    {
        [arrPopularFollowers sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"hisFollowerCount" ascending:NO]]];
        
        [arrPopularFollowers enumerateObjectsUsingBlock:^(Followers *objUser, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (([objUser.followerId isEqualToString:[InstaUser sharedUserInstance].objInstaUser.userId])) {
                
                [arrPopularFollowers removeObjectAtIndex:idx];
                *stop = YES;
            }
            
        }];
        
        [tblPopularsFollowers reloadData];
        [tblPopularsFollowers setHidden:NO];
        [actView stopAnimating];
        
        if (arrPopularFollowers.count==0) {
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
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrPopularFollowers.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    Followers *objUser=[arrPopularFollowers objectAtIndex:indexPath.row];
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
