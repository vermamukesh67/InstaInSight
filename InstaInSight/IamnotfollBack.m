//
//  IamnotfollBack.m
//  InstaInSight
//
//  Created by Mukesh Verma on 13/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import "IamnotfollBack.h"
#import "UserCell.h"

@interface IamnotfollBack ()

@end

@implementation IamnotfollBack

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Not Following Back"];
    arrIMNotFollowingBack=[[NSMutableArray alloc] init];
    [tblFollowing setHidden:YES];
    tblFollowing.tableFooterView = [UIView new];
    [self CheckIamNotFollowingBack];
    
    [FIRAnalytics setScreenName:@"IamNotFollowingBack" screenClass:@"NewFollowingVC"];
    [self setScreenName:@"IamNotFollowingBack"];
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

-(void)CheckIamNotFollowingBack
{
    [actView startAnimating];
    
    
    [[InstagramEngine sharedEngine] getFollowersOfUser:[[InstaUser sharedUserInstance] instaUserId] withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [users enumerateObjectsUsingBlock:^(InstagramUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [Followers saveFollowersList:obj];
            }];
        });
        
        [[InstagramEngine sharedEngine] getUsersFollowedByUser:[[InstaUser sharedUserInstance] instaUserId] withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
            
            NSLog(@"users = %@",users);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [users enumerateObjectsUsingBlock:^(InstagramUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [Following saveFollowingsList:obj];
                }];
                
                NSArray *arrNewFollowers=[Followers fetchFollowersDetails];
                
                [arrNewFollowers enumerateObjectsUsingBlock:^(Followers  *_Nonnull objF, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([Following fetchFollowingsById:objF.followerId]==nil) {
                        [arrIMNotFollowingBack addObject:objF];
                    }
                }];
                
                [tblFollowing setHidden:NO];
                [tblFollowing reloadData];
                [actView stopAnimating];
                if (arrIMNotFollowingBack.count==0) {
                    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:@"You have not recently unfollowed any users" preferredStyle:UIAlertControllerStyleAlert];
                    
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
    return arrIMNotFollowingBack.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    Followers *objUser=[arrIMNotFollowingBack objectAtIndex:indexPath.row];
    [cell.imgProfile sd_setImageWithURL:[NSURL URLWithString:[objUser profilePictureURL]] placeholderImage:[UIImage imageNamed:@"defaultlist"]];
    [cell.lblName setText:[objUser fullName]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
