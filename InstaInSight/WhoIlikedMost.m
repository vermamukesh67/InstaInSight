//
//  WhoIlikedMost.m
//  InstaInSight
//
//  Created by Mukesh Verma on 18/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import "WhoIlikedMost.h"

@interface WhoIlikedMost ()

@end

@implementation WhoIlikedMost

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Who I Liked Most"];
    arrMediaLikedByMe=[[NSMutableArray alloc] init];
    [tblWhoIlikedMost setHidden:YES];
    tblWhoIlikedMost.tableFooterView = [UIView new];
    [self FetchMediaLikedByMe];
    
    [FIRAnalytics setScreenName:@"WhoILikedMost" screenClass:@"WhoILikedMost"];
    [self setScreenName:@"WhoILikedMost"];
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

-(void)FetchMediaLikedByMe
{
    [actView startAnimating];
    
    [[InstagramEngine sharedEngine] getMediaLikedBySelfWithCount:50 maxId:0 success:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        NSMutableArray *arrAllUsers=[[NSMutableArray alloc] init];
        NSLog(@"media = %@",media);
        [media enumerateObjectsUsingBlock:^(InstagramMedia * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if (obj.user) {
                [arrAllUsers addObject:obj.user];
            }
        }];
        
        NSMutableArray *arrUsersId=[[NSMutableArray alloc] init];
        [arrAllUsers enumerateObjectsUsingBlock:^(InstagramUser  *_Nonnull objuser, NSUInteger idx, BOOL * _Nonnull stop) {
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
            
            NSArray *arrDatas=[arrAllUsers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userId = %@",[objDicc valueForKey:@"userId"]]];
            if (arrDatas.count>0) {
                [arrMediaLikedByMe addObject:[arrDatas firstObject]];
            }
        }];
        
        NSLog(@"arrTopLikers= %@",arrMediaLikedByMe);
        
        [tblWhoIlikedMost reloadData];
        [tblWhoIlikedMost setHidden:NO];
        [actView stopAnimating];
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        [tblWhoIlikedMost reloadData];
        [tblWhoIlikedMost setHidden:NO];
        [actView stopAnimating];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMediaLikedByMe.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    InstagramUser *objUser=[arrMediaLikedByMe objectAtIndex:indexPath.row];
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
