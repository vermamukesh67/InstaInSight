//
//  NewFollowingVC.m
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "NewFollowingVC.h"
#import "UserCell.h"

@interface NewFollowingVC ()

@end

@implementation NewFollowingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrFollowing=[[NSMutableArray alloc] init];
    [tblFollowing setHidden:YES];
    [self GetFollowings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)GetFollowings
{
    [actView startAnimating];
    
    [[InstagramEngine sharedEngine] getUsersFollowedByUser:[[InstaUser sharedUserInstance] instaUserId] withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        NSLog(@"users = %@",users);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            arrFollowing=[[NSMutableArray alloc] initWithArray:users];
            [tblFollowing setHidden:NO];
            [tblFollowing reloadData];
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
    return arrFollowing.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    InstagramUser *objUser=[arrFollowing objectAtIndex:indexPath.row];
    [cell.imgProfile sd_setImageWithURL:[objUser profilePictureURL] placeholderImage:[UIImage imageNamed:@"profilePlaceHolder"]];
    [cell.lblName setText:[objUser fullName]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
