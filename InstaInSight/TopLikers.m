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
                    NSCountedSet *countedSet = [[NSCountedSet alloc] initWithArray:arrTotalLikers];
                                                
                    
                    // Array with distinct elements only, sorted by their repeat count
                    NSArray *distinctArray = [[countedSet allObjects]
                                              sortedArrayUsingFunction:countedSort context:(__bridge void * _Nullable)(countedSet)];
                    
                    // Array with all the elements, where elements representing the same
                    // object are contiguous
                    arrTopLikers = [NSMutableArray arrayWithCapacity:[arrTotalLikers count]];
                    for (id object in distinctArray) {
                        for (NSUInteger i = 0; i < [countedSet countForObject:object]; i++) {
                            [arrTopLikers addObject:object];
                        }
                    }
                }
                
                [tblLikers reloadData];
                [tblLikers setHidden:NO];
                [actView stopAnimating];
               
            }
            
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            
        }];
    }
}

NSInteger countedSort(id obj1, id obj2, void *context) {
    NSCountedSet *countedSet = (__bridge NSCountedSet *)(context);
    NSUInteger obj1Count = [countedSet countForObject:obj1];
    NSUInteger obj2Count = [countedSet countForObject:obj2];
    
    if (obj1Count > obj2Count) return NSOrderedDescending ;
    else if (obj1Count < obj2Count) return NSOrderedAscending;
    return NSOrderedSame;
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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
