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
    [self setTitle:@"Popular Followers"];
    arrPopularFollowers=[[NSMutableArray alloc] init];
    [tblPopularsFollowers setHidden:YES];
    tblPopularsFollowers.tableFooterView = [UIView new];
    [self GetFollowers];
    [FIRAnalytics setScreenName:@"PopularFollowers" screenClass:@"PopularFollowers"];
    [self setScreenName:@"PopularFollowers"];
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
                [arrPopularFollowers addObject:[Followers saveFollowersList:obj]];
            }];
            
            [arrPopularFollowers sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"hisFollowerCount" ascending:NO]]];
            
            [tblPopularsFollowers reloadData];
            [tblPopularsFollowers setHidden:NO];
            [actView stopAnimating];
        });
        
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
