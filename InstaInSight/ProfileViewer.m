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
    arrTopMediaForComments=[[NSMutableArray alloc] init];
    arrTotalCommenters=[[NSMutableArray alloc] init];
    
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
        
        arrTopMedia=[[NSMutableArray alloc] initWithArray:media];
        arrTopMediaForComments=[[NSMutableArray alloc] initWithArray:media];
        
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
            
            
        }];
            
       [self GetLikesForMedia];
            
        });
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        NSLog(@"error = %@",error);
        [actView stopAnimating];
        if (error!=nil && ![error isKindOfClass:[NSNull class]] && [error isKindOfClass:[NSError class]]) {
            [HelperMethod ShowAlertWithMessage:[error localizedDescription] InViewController:self];
        }
    }];
}

-(void)LoadTable
{
    
    arrRandomUsers = [[arrRandomUsers sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"point" ascending:NO]]] mutableCopy];
    
    NSMutableArray *arrFinalArray=[[NSMutableArray alloc] init];
    
    if (arrRandomUsers.count>=20) {
        
        NSArray *arrTop10=[arrRandomUsers subarrayWithRange:NSMakeRange(0, 9)];
        
        [arrFinalArray addObjectsFromArray:[arrTop10 randomSelectionWithCount:5]];
        
        NSArray *arrSecondTop10=[arrRandomUsers subarrayWithRange:NSMakeRange(10, 9)];
        
        [arrFinalArray addObjectsFromArray:[arrSecondTop10 randomSelectionWithCount:4]];
        
        if (arrRandomUsers.count==20) {
           
            [arrFinalArray addObject:[arrRandomUsers lastObject]];
        }
        else
        {
            NSArray *arrLast=[arrRandomUsers subarrayWithRange:NSMakeRange(21, [arrRandomUsers count]-1)];
            [arrFinalArray addObjectsFromArray:[arrLast randomSelectionWithCount:1]];
        }
        
    }
    else if (arrRandomUsers.count>=10)
    {
        NSArray *arrTop10=[arrRandomUsers subarrayWithRange:NSMakeRange(0, 9)];
        [arrFinalArray addObjectsFromArray:[arrTop10 randomSelectionWithCount:5]];
        
        if (arrRandomUsers.count>=14) {
            
            NSArray *arrSecondTop10=[arrRandomUsers subarrayWithRange:NSMakeRange(10, [arrRandomUsers count]-1)];
            
            [arrFinalArray addObjectsFromArray:[arrSecondTop10 randomSelectionWithCount:4]];
        }
        else
        {
           [arrFinalArray addObjectsFromArray:[arrRandomUsers subarrayWithRange:NSMakeRange(10, [arrRandomUsers count]-1)]];
            
        }
       
    }
    else
    {
        [arrFinalArray addObjectsFromArray:arrRandomUsers];
    }
    
    
    if (arrFinalArray.count>0) {
        
        NSInteger numberOfPeopleToShow=([[[InstaUser sharedUserInstance] objInstaUser] followsCount]*0.1);
        
        if (numberOfPeopleToShow>=10) {
            arrProfileViewer = [[arrFinalArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"point" ascending:NO]]] mutableCopy];
        }
        else
        {
            arrFinalArray = [[arrFinalArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"point" ascending:NO]]] mutableCopy];
            
            arrProfileViewer=[[arrFinalArray subarrayWithRange:NSMakeRange(0, numberOfPeopleToShow)] mutableCopy];
        }
        
    }
    
    
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
}

-(void)GetCommentsForMedia
{
    if (arrTopMediaForComments.count >0) {
        
        InstagramMedia *instaMedia=[arrTopMediaForComments firstObject];
        
        [[InstagramEngine sharedEngine] getCommentsOnMedia:instaMedia.Id withSuccess:^(NSArray<InstagramComment *> * _Nonnull comments, InstagramPaginationInfo * _Nonnull paginationInfo) {
            
            NSMutableArray *users=[[NSMutableArray alloc] init];
            
            if (comments.count>0) {
                
                [comments enumerateObjectsUsingBlock:^(InstagramComment * _Nonnull objComment, NSUInteger idx, BOOL * _Nonnull stop) {
                    [users addObject:objComment.user];
                }];
            }
            
            NSLog(@"%@",users);
            
            [arrTopMediaForComments removeObject:instaMedia];
            
            [arrTotalCommenters addObjectsFromArray:users];
            
            if (arrTopMediaForComments.count>0) {
                
                [self GetCommentsForMedia];
            }
            else
            {
                if (arrTotalCommenters.count==0) {
                    
                    [self LoadTable];
                }
                else
                {
                    [arrTotalCommenters enumerateObjectsUsingBlock:^(InstagramUser  *_Nonnull objWhoLike, NSUInteger idx, BOOL * _Nonnull stop) {
                        
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
                    
                    [self LoadTable];
                    
                }
                
            }
            
            
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            
            [arrTopMediaForComments removeObject:instaMedia];
            [self CallAgainCommentsForMedia];
        }];
        
    }
}

-(void)CallAgainCommentsForMedia
{
    if (arrTopMediaForComments.count>0) {
        
        [self GetLikesForMedia];
    }
    else
    {
        if (arrTotalCommenters.count==0) {
            
           // Do prepare data
             [self LoadTable];
        }
        else
        {
            [arrTotalCommenters enumerateObjectsUsingBlock:^(InstagramUser  *_Nonnull objWhoLike, NSUInteger idx, BOOL * _Nonnull stop) {
                
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
           
             [self LoadTable];
        }
        
    }
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
                    
                    [self GetCommentsForMedia];
                }
                else
                {
                    [arrTotalLikers enumerateObjectsUsingBlock:^(InstagramUser  *_Nonnull objWhoLike, NSUInteger idx, BOOL * _Nonnull stop) {
                        
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
                    
                    [self GetCommentsForMedia];
                    
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
            
            // call for comment data
            
            [self GetCommentsForMedia];
        }
        else
        {
            [arrTotalLikers enumerateObjectsUsingBlock:^(InstagramUser  *_Nonnull objWhoLike, NSUInteger idx, BOOL * _Nonnull stop) {
                
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
            
            [self GetCommentsForMedia];
            
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


@end
