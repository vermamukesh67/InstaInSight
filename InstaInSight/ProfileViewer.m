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
    
    [FIRAnalytics setScreenName:@"ProfileViewer" screenClass:@"ProfileViewer"];
    [self setScreenName:@"ProfileViewer"];
    
    [self FetchRecentFeeds];
}

-(void)FetchRecentFeeds
{
    [actView startAnimating];
    
    [[InstagramEngine sharedEngine] getSelfRecentMediaWithCount:20 maxId:nil success:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        NSLog(@"media = %@",media);
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        NSLog(@"error = %@",error);
        [actView stopAnimating];
        if (error!=nil && ![error isKindOfClass:[NSNull class]] && [error isKindOfClass:[NSError class]]) {
            [HelperMethod ShowAlertWithMessage:[error localizedDescription] InViewController:self];
        }
    }];
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
