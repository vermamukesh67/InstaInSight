//
//  NewFollowerVC.m
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "NewFollowerVC.h"
#import "UserCell.h"
//#import "Followers+CoreDataProperties.h"

@interface NewFollowerVC ()

@end

@implementation NewFollowerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self setTitle:@"New Followers"];
    arrFollowers=[[NSMutableArray alloc] init];
    [tblFollowers setHidden:YES];
    tblFollowers.tableFooterView = [UIView new];
    [self GetFollowers];
    
    [FIRAnalytics setScreenName:@"NewFollower" screenClass:@"NewFollowerVC"];
    [self setScreenName:@"NewFollower"];
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
                [Followers saveFollowersList:obj];
            }];
            arrFollowers=[[NSMutableArray alloc] initWithArray:[Followers fetchFollowersByType:@"1"]];
            [tblFollowers setHidden:NO];
            [tblFollowers reloadData];
            [actView stopAnimating];
            if (arrFollowers.count==0) {
                UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:@"You have not new followers" preferredStyle:UIAlertControllerStyleAlert];
                
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
    return arrFollowers.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    Followers *objUser=[arrFollowers objectAtIndex:indexPath.row];
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
