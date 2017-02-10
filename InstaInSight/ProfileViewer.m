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
    [self setTitle:@"Friends who viewed my profile"];
    arrProfileViewer=[[NSMutableArray alloc] init];
    arrRandomUsers=[[NSMutableArray alloc] init];
    arrTopMedia=[[NSMutableArray alloc] init];
    arrTotalLikers=[[NSMutableArray alloc] init];
    
    [tblProfile setHidden:YES];
    tblProfile.tableFooterView = [UIView new];
    
    [FIRAnalytics setScreenName:@"ProfileViewer" screenClass:@"ProfileViewer"];
    [self setScreenName:@"ProfileViewer"];
    
    [self FetchRecentFeeds];
}

-(void)FetchRecentFeeds
{
    [actView startAnimating];
    
    [[InstagramEngine sharedEngine] getSelfRecentMediaWithCount:20 maxId:nil success:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        NSLog(@"media = %@",media);
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [media enumerateObjectsUsingBlock:^(InstagramMedia * _Nonnull objphotoMedia, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if (objphotoMedia.usersInPhoto.count>0) {
                
                [objphotoMedia.usersInPhoto enumerateObjectsUsingBlock:^(UserInPhoto * _Nonnull objUserInPhoto, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    InstagramModel *model=(InstagramModel *)objUserInPhoto;
                    
                    InstagramUser *taggedUser=[model valueForKey:@"_user"];
                    
                    NSLog(@"%@",taggedUser.userId);
                    
                    if (arrRandomUsers.count>0) {
                        
                        NSArray *arrDatas=[arrRandomUsers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userId = %@",taggedUser.userId]];
                        if (arrDatas.count>0) {
                            NSMutableDictionary *diccUser=[arrDatas firstObject];
                            NSInteger index=[arrRandomUsers indexOfObject:diccUser];
                            NSInteger point=[[diccUser objectForKey:@"point"] integerValue];
                            [diccUser setObject:@(point+5) forKey:@"point"];
                            
                            [arrRandomUsers replaceObjectAtIndex:index withObject:diccUser];
                        }
                        else
                        {
                            [arrRandomUsers addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:taggedUser,@"user",@(5),@"point",taggedUser.userId,@"userId", nil]];
                        }
                    }
                    else
                    {
                        [arrRandomUsers addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:taggedUser,@"user",@(5),@"point",taggedUser.userId,@"userId", nil]];
                    }
                    
                }];
            }
            /*
            if (objphotoMedia.likes.count>0) {
                
                [objphotoMedia.likes enumerateObjectsUsingBlock:^(InstagramUser * _Nonnull objWhoLike, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    
                    NSLog(@"%@",objWhoLike.userId);
                    
                    if (arrRandomUsers.count>0) {
                        
                        NSArray *arrDatas=[arrRandomUsers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userId = %@",objWhoLike.userId]];
                        if (arrDatas.count>0) {
                            NSMutableDictionary *diccUser=[arrDatas firstObject];
                            NSInteger index=[arrRandomUsers indexOfObject:diccUser];
                            NSInteger point=[[diccUser objectForKey:@"point"] integerValue];
                            [diccUser setObject:@(point+3) forKey:@"point"];
                            
                            [arrRandomUsers replaceObjectAtIndex:index withObject:diccUser];
                        }
                        else
                        {
                            [arrRandomUsers addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:objWhoLike,@"user",@(3),@"point",objWhoLike.userId,@"userId", nil]];
                        }
                        
                    }
                    else
                    {
                        [arrRandomUsers addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:objWhoLike,@"user",@(3),@"point",objWhoLike.userId,@"userId", nil]];
                    }
                    
                }];
            }
            
            if (objphotoMedia.comments.count>0) {
                
                [objphotoMedia.comments enumerateObjectsUsingBlock:^(InstagramComment * _Nonnull objComments, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSLog(@"%@",objComments.user.userId);
                    
                    if (arrRandomUsers.count>0) {
                        
                        NSArray *arrDatas=[arrRandomUsers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userId = %@",objComments.user.userId]];
                        if (arrDatas.count>0) {
                            NSMutableDictionary *diccUser=[arrDatas firstObject];
                            NSInteger index=[arrRandomUsers indexOfObject:diccUser];
                            NSInteger point=[[diccUser objectForKey:@"point"] integerValue];
                            [diccUser setObject:@(point+2) forKey:@"point"];
                            
                            [arrRandomUsers replaceObjectAtIndex:index withObject:diccUser];
                        }
                        else
                        {
                            [arrRandomUsers addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:objComments.user,@"user",@(2),@"point",objComments.user.userId,@"userId", nil]];
                        }
                        
                    }
                    else
                    {
                        [arrRandomUsers addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:objComments.user,@"user",@(2),@"point",objComments.user.userId,@"userId", nil]];
                    }
                    
                }];
            }*/
            
            arrTopMedia=[[NSMutableArray alloc] initWithArray:media];
            [self GetLikesForMedia];
            
        }];
            
            arrProfileViewer = [[arrRandomUsers sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO]]] mutableCopy];
            
            [actView stopAnimating];
            [tblProfile reloadData];
            [tblProfile setHidden:NO];
            
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
            
        });
        
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
            
            NSLog(@"arrTopLikers= %@",arrTopLikers);
            
        }
        
    }
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
    NSMutableDictionary *diccUser=[arrProfileViewer objectAtIndex:indexPath.row];
    InstagramUser *objUser=[diccUser objectForKey:@"user"];
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
