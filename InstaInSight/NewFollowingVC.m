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
    [self setTitle:@"New Followings"];
    arrFollowing=[[NSMutableArray alloc] init];
    [tblFollowing setHidden:YES];
    tblFollowing.tableFooterView = [UIView new];
    [self GetFollowings];
    
    [FIRAnalytics setScreenName:@"NewFollowing" screenClass:@"NewFollowingVC"];
    [self setScreenName:@"NewFollowing"];
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

-(void)GetFollowings
{
    [actView startAnimating];
    
    [[InstagramEngine sharedEngine] getFollowersOfUser:[[InstaUser sharedUserInstance] instaUserId] withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        NSLog(@"users = %@",users);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [users enumerateObjectsUsingBlock:^(InstagramUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [Following saveFollowingsList:obj];
            }];
            arrFollowing=[[NSMutableArray alloc] initWithArray:[Following fetchFollowingsByType:@"1"]];
            [tblFollowing setHidden:NO];
            [tblFollowing reloadData];
            [actView stopAnimating];
            if (arrFollowing.count==0) {
                UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:@"You have not new followings" preferredStyle:UIAlertControllerStyleAlert];
                
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
    Following *objUser=[arrFollowing objectAtIndex:indexPath.row];
    [cell.imgProfile sd_setImageWithURL:[NSURL URLWithString:[objUser profilePictureURL]] placeholderImage:[UIImage imageNamed:@"defaultlist"]];
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
