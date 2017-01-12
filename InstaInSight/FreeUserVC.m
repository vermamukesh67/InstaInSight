//
//  FreeUserVC.m
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "FreeUserVC.h"
#import "NewFollowerVC.h"
#import "NewFollowingVC.h"

@interface FreeUserVC ()

@end

@implementation FreeUserVC

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
        [NSDictionary dictionaryWithObjectsAndKeys:@"New Followers",@"title",@"newfollowers",@"imgName", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"New Following",@"title",@"newfollowing",@"imgName", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Not Following Back",@"title",@"notfollowingback",@"imgName", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"I am not Following Back",@"title",@"iamnotfollowingback",@"imgName", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Likes Graph",@"title",@"likegraphs",@"imgName", nil],
                
                nil];
    
    [FIRAnalytics setScreenName:@"FreeUser" screenClass:@"FreeUserVC"];
    [self setScreenName:@"FreeUser"];
    
    tblFreeUser.tableFooterView = [UIView new];
    
    [self performSelector:@selector(ShowAdv) withObject:nil afterDelay:1.0];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)ShowAdv
{
     [APP_DELEGATE createAndLoadInterstitial];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [[imgProfileView layer] setCornerRadius:60.0f];
    [imgProfileView setClipsToBounds:YES];
    [[imgProfileView layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[imgProfileView layer] setBorderWidth:2.0];
    
    [[tblFreeUser layer] setCornerRadius:2.0];
    [tblFreeUser setClipsToBounds:YES];
    
    [[whiteBox layer] setCornerRadius:2.0];
    [whiteBox setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            NewFollowerVC *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"NewFollowerVC"];
            [objScr setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:objScr animated:YES];
        }
           
            break;
        case 1:
        {
            NewFollowerVC *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"NewFollowingVC"];
            [objScr setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:objScr animated:YES];
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
