//
//  PaidUserVC.m
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "PaidUserVC.h"
#import "ProfileViewer.h"

@interface PaidUserVC ()

@end

@implementation PaidUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"base"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *navBarButtonAppearance = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:[UINavigationBar class]]];
    [navBarButtonAppearance setTitleTextAttributes:@{
                                                     NSFontAttributeName:            [UIFont systemFontOfSize:0.1],
                                                     NSForegroundColorAttributeName: [UIColor clearColor] }
                                          forState:UIControlStateNormal];
    
    [lblName setText:[[[InstaUser sharedUserInstance] objInstaUser] fullName]];
    [lblFollowerCount setText:[NSString stringWithFormat:@"%li Followers",[[[InstaUser sharedUserInstance] objInstaUser] followsCount]]];
    [lblFollowingCount setText:[NSString stringWithFormat:@"%li Followings",[[[InstaUser sharedUserInstance] objInstaUser] followedByCount]]];
    
    [imgProfileView sd_setImageWithURL:[[[InstaUser sharedUserInstance] objInstaUser] profilePictureURL] placeholderImage:[UIImage imageNamed:@"default"]];
    
    arrRowData=[[NSMutableArray alloc] initWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:@"Profile Viewer",@"title",@"profileviewer",@"imgName", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"My Top Likes",@"title",@"mytoplikes",@"imgName", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"Who i Like Most",@"title",@"whoilikemost",@"imgName", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"Popular Followers",@"title",@"popularfollowers",@"imgName", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"Ghost Followers",@"title",@"ghostfollowers",@"imgName", nil],
                
                nil];
    
    [FIRAnalytics setScreenName:@"paiduser" screenClass:@"PaidUserVC"];
    [self setScreenName:@"PaidUser"];
    
    tblPaidUser.tableFooterView = [UIView new];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [[imgProfileView layer] setCornerRadius:60];
    [imgProfileView setClipsToBounds:YES];
    [[imgProfileView layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[imgProfileView layer] setBorderWidth:2.0];
    
    [[tblPaidUser layer] setCornerRadius:2.0];
    [tblPaidUser setClipsToBounds:YES];
    
    [[whiteBox layer] setCornerRadius:2.0];
    [whiteBox setClipsToBounds:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrRowData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"featureCell"];
    NSDictionary *diccData=[arrRowData objectAtIndex:indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:[diccData objectForKey:@"imgName"]]];
    [cell.textLabel setText:[diccData objectForKey:@"title"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            ProfileViewer *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewer"];
            [objScr setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:objScr animated:YES];
        }
            
            break;
        case 1:
        {
//            NewFollowerVC *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"NewFollowingVC"];
//            [objScr setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:objScr animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
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
