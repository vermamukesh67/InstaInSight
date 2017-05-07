//
//  TopLikers.m
//  InstaInSight
//
//  Created by Verma Mukesh on 16/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import "TopLikers.h"

@interface TopLikers ()

@end

@implementation TopLikers

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Top Likers"];
    arrTopLikers=[[NSMutableArray alloc] init];
    arrTotalLikers=[[NSMutableArray alloc] init];
    arrTopMedia=[[NSMutableArray alloc] init];
    [tblLikers setHidden:YES];
    tblLikers.tableFooterView = [UIView new];
    [self FetchRecentFeeds];
    
    [FIRAnalytics setScreenName:@"TopLikers" screenClass:@"TopLikers"];
    [self setScreenName:@"TopLikers"];
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

-(void)FetchRecentFeeds
{
    [actView startAnimating];
       
    [[InstagramEngine sharedEngine] getSelfRecentMediaWithCount:50 maxId:nil success:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        NSLog(@"media = %@",media);
        /*
        [media enumerateObjectsUsingBlock:^(InstagramMedia * _Nonnull objMedia, NSUInteger idx, BOOL * _Nonnull stop) {
             [arrTotalLikers addObjectsFromArray:objMedia.likes];
        }];
        
        
        if (arrTotalLikers.count==0) {
            
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
        else
        {
            NSMutableArray *arrUsersId=[[NSMutableArray alloc] init];
            [arrTotalLikers enumerateObjectsUsingBlock:^(InstagramUser  *_Nonnull objuser, NSUInteger idx, BOOL * _Nonnull stop) {
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
                
                NSArray *arrDatas=[arrTotalLikers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userId = %@",[objDicc valueForKey:@"userId"]]];
                if (arrDatas.count>0) {
                    [arrTopLikers addObject:[arrDatas firstObject]];
                }
            }];
            
            NSLog(@"arrTopLikers= %@",arrTopLikers);
            
        }
        
        [tblLikers reloadData];
        [tblLikers setHidden:NO];
        [actView stopAnimating]; */
        
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
                else
                {
                    NSMutableArray *arrUsersId=[[NSMutableArray alloc] init];
                    [arrTotalLikers enumerateObjectsUsingBlock:^(InstagramUser  *_Nonnull objuser, NSUInteger idx, BOOL * _Nonnull stop) {
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
                       
                        NSArray *arrDatas=[arrTotalLikers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userId = %@",[objDicc valueForKey:@"userId"]]];
                        if (arrDatas.count>0) {
                            [arrTopLikers addObject:[arrDatas firstObject]];
                        }
                    }];
                    
                    NSLog(@"arrTopLikers= %@",arrTopLikers);
                    
                }
                
                [arrTopLikers enumerateObjectsUsingBlock:^(InstagramUser *objUser, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if (([objUser.userId isEqualToString:[InstaUser sharedUserInstance].objInstaUser.userId])) {
                        
                        [arrTopLikers removeObjectAtIndex:idx];
                        *stop = YES;
                    }
                    
                }];
                
                if (arrTopLikers.count==0) {
                    
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

                
                [tblLikers reloadData];
                [tblLikers setHidden:NO];
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
        else
        {
            NSMutableArray *arrUsersId=[[NSMutableArray alloc] init];
            [arrTotalLikers enumerateObjectsUsingBlock:^(InstagramUser  *_Nonnull objuser, NSUInteger idx, BOOL * _Nonnull stop) {
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
                
                NSArray *arrDatas=[arrTotalLikers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userId = %@",[objDicc valueForKey:@"userId"]]];
                if (arrDatas.count>0) {
                    [arrTopLikers addObject:[arrDatas firstObject]];
                }
            }];
            
            [arrTopLikers enumerateObjectsUsingBlock:^(InstagramUser *objUser, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (([objUser.userId isEqualToString:[InstaUser sharedUserInstance].objInstaUser.userId])) {
                    
                    [arrTopLikers removeObjectAtIndex:idx];
                    *stop = YES;
                }
                
            }];
            
            if (arrTopLikers.count==0) {
                
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
            
            NSLog(@"arrTopLikers= %@",arrTopLikers);
            
        }
        
        [tblLikers reloadData];
        [tblLikers setHidden:NO];
        [actView stopAnimating];
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrTopLikers.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    InstagramUser *objUser=[arrTopLikers objectAtIndex:indexPath.row];
    [cell.imgProfile sd_setImageWithURL:objUser.profilePictureURL placeholderImage:[UIImage imageNamed:@"defaultlist"]];
    [cell.lblName setText:[objUser fullName]];
    [cell CheckForFollowUnFollow:objUser.userId];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
