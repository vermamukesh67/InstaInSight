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
#import "IamnotfollBack.h"
#import "NotFollowBack.h"
#import "LikeGraph.h"
#import "ProfileViewer.h"
#import "TopLikers.h"
#import "WhoIlikedMost.h"
#import "GhostFollowers.h"
#import "PopularFollower.h"
#import "InAppPurchaseVC.h"

@interface FreeUserVC ()

@end

@implementation FreeUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     isFreeSelected=YES;
    [btnBuy setHidden:isFreeSelected];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"redBG"] forBarMetrics:UIBarMetricsDefault];
    
//    notfollowingBack=[[NSUserDefaults standardUserDefaults] integerForKey:koldCountIMFollowing];
//    iamnotfollowingBack=[[NSUserDefaults standardUserDefaults] integerForKey:koldCountIMNOTFollowing];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    UIBarButtonItem *navBarButtonAppearance = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:[UINavigationBar class]]];
    [navBarButtonAppearance setTitleTextAttributes:@{
                                                     NSFontAttributeName:            [UIFont systemFontOfSize:0.1],
                                                     NSForegroundColorAttributeName: [UIColor clearColor] }
                                          forState:UIControlStateNormal];
    
    [lblName setText:[[[InstaUser sharedUserInstance] objInstaUser] fullName]];
    [lblFollowerCount setText:[NSString stringWithFormat:@"%li Followers",[[[InstaUser sharedUserInstance] objInstaUser] followsCount]]];
    [lblFollowingCount setText:[NSString stringWithFormat:@"%li Followings",[[[InstaUser sharedUserInstance] objInstaUser] followedByCount]]];
    
    [imgProfileView sd_setImageWithURL:[[[InstaUser sharedUserInstance] objInstaUser] profilePictureURL] placeholderImage:[UIImage imageNamed:@"default"]];
    
    arrFollowers=[[NSMutableArray alloc] init];
    arrFollowing=[[NSMutableArray alloc] init];
    arrIMNotFollowingBack=[[NSMutableArray alloc] init];
    arrNotFollowingBack=[[NSMutableArray alloc] init];
    arrNewIMNotF=[[NSMutableArray alloc] init];
    arrNewF=[[NSMutableArray alloc] init];
    
    arrFollowing=[[NSMutableArray alloc] initWithArray:[Following fetchFollowingsByType:@"1"]];
    
    // Total I am not following back
    
    NSArray *arrNewFollowers=[Followers fetchFollowersDetails];
    
    [arrNewFollowers enumerateObjectsUsingBlock:^(Followers  *_Nonnull objF, NSUInteger idx, BOOL * _Nonnull stop) {
        
         if ([Following fetchFollowingsById:objF.followerId]==nil && (![objF.followerId isEqualToString:[InstaUser sharedUserInstance].objInstaUser.userId])) {
            [arrIMNotFollowingBack addObject:objF];
        }
    }];
    
    // Total not following back
    
    NSArray *arrNewFollowings=[Following fetchFollowingsDetails];
    
    [arrNewFollowings enumerateObjectsUsingBlock:^(Following  *_Nonnull objF, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([Followers fetchFollowersById:objF.followingId]==nil && (![objF.followingId isEqualToString:[InstaUser sharedUserInstance].objInstaUser.userId])) {
            [arrNotFollowingBack addObject:objF];
        }
    }];

    
    arrRowData=[[NSMutableArray alloc] initWithObjects:
        [NSDictionary dictionaryWithObjectsAndKeys:@"New Followers",@"title",@"newfollowers",@"imgName", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"New Following",@"title",@"newfollowing",@"imgName", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Not Following Back",@"title",@"notfollowingback",@"imgName", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:(IS_IPHONE_5)?@"I am not Following\nBack":@"I am not Following Back",@"title",@"iamnotfollowingback",@"imgName", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Like Trend",@"title",@"likegraphs",@"imgName", nil],
                
                nil];
    
    arrPaidData=[[NSMutableArray alloc] initWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:@"Profile Stalkers",@"title",@"profileviewer",@"imgName", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"My Top Likers",@"title",@"mytoplikes",@"imgName", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"Who I Like Most",@"title",@"whoilikemost",@"imgName", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"Most Popular Followers",@"title",@"popularfollowers",@"imgName", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"Ghost Followers",@"title",@"ghostfollowers",@"imgName", nil],
                
                nil];
    
    [FIRAnalytics setScreenName:@"FreeUser" screenClass:@"FreeUserVC"];
    [self setScreenName:@"FreeUser"];
    
   
  
    tblPaid=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, scrContainer.frame.size.width-40, scrContainer.frame.size.height) style:UITableViewStylePlain];
    tblPaid.delegate=self;
    tblPaid.dataSource=self;
    tblPaid.tableFooterView = [UIView new];
    [scrContainer addSubview:tblPaid];
    
    tblFreeUser=[[UITableView alloc] initWithFrame:CGRectMake(tblPaid.frame.size.width, 0, scrContainer.frame.size.width-40, scrContainer.frame.size.height) style:UITableViewStylePlain];
    tblFreeUser.delegate=self;
    tblFreeUser.dataSource=self;
    tblFreeUser.tableFooterView = [UIView new];
    [scrContainer addSubview:tblFreeUser];
    
    [scrContainer setShowsVerticalScrollIndicator:NO];
    [scrContainer setShowsHorizontalScrollIndicator:NO];
    
    
//    UISwipeGestureRecognizer *leftToRight=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLefttToRight:)];
//    [leftToRight setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self.view addGestureRecognizer:leftToRight];
    
//    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"Free"];
//    
//    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
//    
//    [btnFree setAttributedTitle:commentString forState:UIControlStateNormal];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self GetFollowers];
}

-(void)swipeLefttToRight:(id)sender
{
    [self.tabBarController.tabBar setSelectedItem:[self.tabBarController.tabBar.items objectAtIndex:1]];
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
    
    
    [tblFreeUser setFrame:CGRectMake(0, 0, scrContainer.frame.size.width, scrContainer.frame.size.height)];
    [tblPaid setFrame:CGRectMake(scrContainer.frame.size.width, 0, scrContainer.frame.size.width, scrContainer.frame.size.height)];
    
    [scrContainer setContentSize:CGSizeMake(2*scrContainer.frame.size.width, scrContainer.frame.size.height)];
    [scrContainer setPagingEnabled:YES];
    
    [tblPaid reloadData];
    [tblFreeUser reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView==tblFreeUser)?arrRowData.count:arrPaidData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:(tblFreeUser==tableView)?@"featureCell":@"paidCell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:(tableView==tblFreeUser)?UITableViewCellStyleSubtitle:UITableViewCellStyleDefault reuseIdentifier:@"featureCell"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        if (tblFreeUser==tableView) {
        UILabel *lblCount=[[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width-98, 14,70, 20)];
        [lblCount setFont:[UIFont systemFontOfSize:10.0f]];
        [lblCount setTag:10];
        [[lblCount layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        [[lblCount layer] setBorderWidth:1.0f];
        [lblCount setTextColor:[UIColor blackColor]];
        [[lblCount layer] setCornerRadius:10.0f];
        [lblCount setClipsToBounds:YES];
        [lblCount setTextAlignment:NSTextAlignmentCenter];
        [lblCount setAdjustsFontSizeToFitWidth:YES];
        [lblCount setMinimumScaleFactor:0.25];
        [cell addSubview:lblCount];
      }
    }
    NSDictionary *diccData=(tableView==tblFreeUser)?[arrRowData objectAtIndex:indexPath.row]:[arrPaidData objectAtIndex:indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:[diccData objectForKey:@"imgName"]]];
    
    if (tblFreeUser==tableView) {
        
        [cell.textLabel setText:[diccData objectForKey:@"title"]];
        
        UILabel *lblCount=(UILabel *)[cell viewWithTag:10];
        [lblCount setHidden:NO];
        switch (indexPath.row) {
            case 0:
                [lblCount setText:[NSString stringWithFormat:@" %li New ",arrFollowers.count]];
                break;
            case 1:
                [lblCount setText:[NSString stringWithFormat:@" %li New ",arrFollowing.count]];
                break;
            case 2:
            {
                NSString *text=[NSString stringWithFormat:@" %li (%li New) ",arrNotFollowingBack.count,arrNewF.count];
                
                NSString *text1=[NSString stringWithFormat:@" %li",arrNotFollowingBack.count];
                NSString *text2=[NSString stringWithFormat:@"(%li New) ",arrNewF.count];
                
                
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName: lblCount.textColor,
                                          NSFontAttributeName: lblCount.font
                                          };
                NSMutableAttributedString *attributedText =
                [[NSMutableAttributedString alloc] initWithString:text
                                                       attributes:attribs];
                
                NSRange redTextRange = [text rangeOfString:text1];
                
                [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                NSFontAttributeName:[UIFont boldSystemFontOfSize:10]}
                                        range:redTextRange];
                
                redTextRange = [text rangeOfString:text2];
                
                [attributedText setAttributes:@{NSForegroundColorAttributeName:kAppRedColor,
                                                NSFontAttributeName:[UIFont systemFontOfSize:9]}
                                        range:redTextRange];
                
                [lblCount setAttributedText:attributedText];
            }
                
                break;
            case 3:
            {
                NSString *text=[NSString stringWithFormat:@" %li (%li New) ",arrIMNotFollowingBack.count,arrNewIMNotF.count];
                
                
                NSString *text1=[NSString stringWithFormat:@" %li",arrIMNotFollowingBack.count];
                NSString *text2=[NSString stringWithFormat:@"(%li New) ",arrNewIMNotF.count];
                
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName: lblCount.textColor,
                                          NSFontAttributeName: lblCount.font
                                          };
                NSMutableAttributedString *attributedText =
                [[NSMutableAttributedString alloc] initWithString:text
                                                       attributes:attribs];
                
                NSRange redTextRange = [text rangeOfString:text1];
                
                [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                NSFontAttributeName:[UIFont boldSystemFontOfSize:10]}
                                        range:redTextRange];
                
                redTextRange = [text rangeOfString:text2];
                
                [attributedText setAttributes:@{NSForegroundColorAttributeName:COLOR_WITH_RGBA(73.0f, 153.0f, 254.0f, 1.0f),NSFontAttributeName:[UIFont systemFontOfSize:9]}
                                        range:redTextRange];
                
                [lblCount setAttributedText:attributedText];
            }
                
                break;
                
            default:
                [lblCount setHidden:YES];
                break;
        }
        
    }
    else
    {
        [cell.textLabel setText:[diccData objectForKey:@"title"]];
    }
    
    if (IS_IPHONE_5) {
    
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.5f]];
        [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [cell.textLabel setNumberOfLines:2];
        [cell.textLabel setFrame:CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, cell.textLabel.frame.size.width-100, 30)];
    }
    else
    {
        [cell.textLabel setFont:[UIFont systemFontOfSize:16.0f]];
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==tblFreeUser) {
        
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
            case 2:
            {
                NotFollowBack *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"NotFollowBack"];
                [objScr setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:objScr animated:YES];
            }
                break;
            case 3:
            {
                IamnotfollBack *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"IamnotfollBack"];
                [objScr setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:objScr animated:YES];
            }
                break;
            case 4:
            {
                LikeGraph *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"LikeGraph"];
                [objScr setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:objScr animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
            {
                
                if ([HelperMethod CheckUserIsProUserAndSubscriptionIsNotExpired]) {
                    
                    [self GoToProfileViewer];
                }
                else
                {
                    if ([HelperMethod CheckProfileViewerAndSubscriptionIsNotExpired]) {
                      [self GoToProfileViewer];
                    }
                    else
                    {
                        [self PurchaseProfileViewerProduct];
                    }
                }
                
                
            }
                break;
            case 1:
            {
                if ([HelperMethod CheckUserIsProUserAndSubscriptionIsNotExpired]) {
                    
                    [self GoToTopLikers];
                   
                }
                else
                {
                    if ([HelperMethod CheckMyTopLikersAndSubscriptionIsNotExpired]) {
                       [self GoToTopLikers];
                    }
                    else
                    {
                        [self PurchaseMyTopLikersProduct];
                    }
                }
                
            }
                break;
            case 2:
            {
                if ([HelperMethod CheckUserIsProUserAndSubscriptionIsNotExpired]) {
                   
                    [self GoToWhoIlikedMost];
                   
                }
                else
                {
                    if ([HelperMethod CheckWhoILikedMostAndSubscriptionIsNotExpired]) {
                       [self GoToWhoIlikedMost];
                    }
                    else
                    {
                        [self PurchaseWhoILikedMostProduct];
                    }
                }
                
            }
                break;
            case 3:
            {
                if ([HelperMethod CheckUserIsProUserAndSubscriptionIsNotExpired]) {
                    
                    [self GoToPopularFollower];
                   
                }
                else
                {
                    if ([HelperMethod CheckMostPopularFollowerAndSubscriptionIsNotExpired]) {
                        [self GoToPopularFollower];
                    }
                    else
                    {
                        [self PurchaseMostPopularProduct];
                    }
                }
                
            }
                break;
            case 4:
            {
                if ([HelperMethod CheckUserIsProUserAndSubscriptionIsNotExpired]) {
                    
                    [self GoToGhostFollowers];
                   
                }
                else
                {
                    if ([HelperMethod CheckGhostFollowerAndSubscriptionIsNotExpired]) {
                        [self GoToGhostFollowers];
                    }
                    else
                    {
                        [self PurchaseGhostFollowersProduct];
                    }
                }
                
            }
                break;
                
            default:
                break;
        }
    }
    
}

-(void)GoToProfileViewer
{
    ProfileViewer *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewer"];
    [objScr setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:objScr animated:YES];
}
-(void)GoToGhostFollowers
{
    GhostFollowers *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"GhostFollowers"];
    [objScr setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:objScr animated:YES];
}
-(void)GoToPopularFollower
{
    PopularFollower *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"PopularFollower"];
    [objScr setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:objScr animated:YES];
}
-(void)GoToTopLikers
{
    TopLikers *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"TopLikers"];
    [objScr setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:objScr animated:YES];
}
-(void)GoToWhoIlikedMost
{
    WhoIlikedMost *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"WhoIlikedMost"];
    [objScr setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:objScr animated:YES];
}

- (IBAction)btnFreeTapped:(id)sender {
    
    if (!isFreeSelected) {
        isFreeSelected=YES;
        [btnFree setBackgroundColor:btnPro.backgroundColor];
        [btnPro setBackgroundColor:[UIColor lightGrayColor]];
         [scrContainer scrollRectToVisible:CGRectMake(0, 0, scrContainer.frame.size.width, scrContainer.frame.size.height) animated:YES];
    }
    [btnBuy setHidden:isFreeSelected];
}

- (IBAction)btnProTapped:(id)sender {
    
    if (isFreeSelected) {
        [btnPro setBackgroundColor:btnFree.backgroundColor];
        [btnFree setBackgroundColor:[UIColor lightGrayColor]];
        isFreeSelected=NO;
        
        [scrContainer scrollRectToVisible:CGRectMake(scrContainer.frame.size.width, 0, scrContainer.frame.size.width, scrContainer.frame.size.height) animated:YES];
    }
    
    [btnBuy setHidden:isFreeSelected];
    
}

- (IBAction)btnBuyTapped:(id)sender {
    
    InAppPurchaseVC *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"InAppPurchaseVC"];
    [objScr setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:objScr animated:YES];
    
}

- (IBAction)btnLogoutTapped:(id)sender {
    
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to logout ?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Logout"
                         style:UIAlertActionStyleDestructive
                         handler:^(UIAlertAction * action)
                         {
                             [alertVC dismissViewControllerAnimated:YES completion:nil];
                             [[InstagramEngine sharedEngine] logout];
                             
                             UINavigationController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavVC"];
                             [[APP_DELEGATE window] setRootViewController:viewController];
                             [[APP_DELEGATE window] makeKeyAndVisible];
                         }];
    
    UIAlertAction* No = [UIAlertAction
                         actionWithTitle:@"No"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alertVC dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alertVC addAction:No];
    [alertVC addAction:ok];
   
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
    
   
}

#pragma mark-
#pragma mark- UIScrollDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==scrContainer) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        
        NSLog(@"%li",(long)page);
        switch (page) {
            case 0:
                if (!isFreeSelected) {
                    isFreeSelected=YES;
                    [btnFree setBackgroundColor:btnPro.backgroundColor];
                    [btnPro setBackgroundColor:[UIColor lightGrayColor]];
                    [scrContainer scrollRectToVisible:CGRectMake(0, 0, scrContainer.frame.size.width, scrContainer.frame.size.height) animated:YES];
                }
                isFreeSelected=YES;
                [btnBuy setHidden:isFreeSelected];
                break;
            case 1:
                if (isFreeSelected) {
                    [btnPro setBackgroundColor:btnFree.backgroundColor];
                    [btnFree setBackgroundColor:[UIColor lightGrayColor]];
                    isFreeSelected=NO;
                    
                    [scrContainer scrollRectToVisible:CGRectMake(scrContainer.frame.size.width, 0, scrContainer.frame.size.width, scrContainer.frame.size.height) animated:YES];
                }
                isFreeSelected=NO;
                [btnBuy setHidden:isFreeSelected];
                break;
                
            default:
                break;
        }
    }
}


#pragma mark-
#pragma mark- In App Purchase Method

-(void)PurchaseProfileViewerProduct
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:kAPPName message:@"Buy Profile Stalkers" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"1 Month for $1.99/MO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightProfileViewer_OneMonth]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
            else
            {
                //Failed to load list of products.
                [HelperMethod ShowAlertWithMessage:kProductNotLoaded InViewController:self];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"6 Month for $1.49/MO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightProfileViewer_SixMonth]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
            else
            {
                //Failed to load list of products.
                [HelperMethod ShowAlertWithMessage:kProductNotLoaded InViewController:self];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"12 Month for $0.99/MO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightProfileViewer_Year]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
            else
            {
                //Failed to load list of products.
                [HelperMethod ShowAlertWithMessage:kProductNotLoaded InViewController:self];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)PurchaseMyTopLikersProduct
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:kAPPName message:@"Buy My Top Likers" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"1 Month for $0.99/MO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightMyTopLikers_OneMonth]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
            else
            {
                //Failed to load list of products.
                [HelperMethod ShowAlertWithMessage:kProductNotLoaded InViewController:self];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"6 Month for $0.75/MO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightMyTopLikers_SixMonth]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
            else
            {
                //Failed to load list of products.
                [HelperMethod ShowAlertWithMessage:kProductNotLoaded InViewController:self];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"12 Month for $0.49/MO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightMyTopLikers_Year]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
            else
            {
                //Failed to load list of products.
                [HelperMethod ShowAlertWithMessage:kProductNotLoaded InViewController:self];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)PurchaseWhoILikedMostProduct
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:kAPPName message:@"Buy Who I Liked Most" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"1 Month for $0.99/MO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightWhoILikedMost_OneMonth]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
            else
            {
                //Failed to load list of products.
                [HelperMethod ShowAlertWithMessage:kProductNotLoaded InViewController:self];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"6 Month for $0.75/MO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightWhoILikedMost_SixMonth]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
            else
            {
                //Failed to load list of products.
                [HelperMethod ShowAlertWithMessage:kProductNotLoaded InViewController:self];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"12 Month for $0.49/MO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightWhoILikedMost_Year]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
            else
            {
                //Failed to load list of products.
                [HelperMethod ShowAlertWithMessage:kProductNotLoaded InViewController:self];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)PurchaseMostPopularProduct
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:kAPPName message:@"Buy Most Popular Followers" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"1 Month for $0.99/MO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightMostPopularFollowers_OneMonth]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
            else
            {
                //Failed to load list of products.
                [HelperMethod ShowAlertWithMessage:kProductNotLoaded InViewController:self];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"6 Month for $0.75/MO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightMostPopularFollowers_SixMonth]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
            else
            {
                //Failed to load list of products.
                [HelperMethod ShowAlertWithMessage:kProductNotLoaded InViewController:self];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"12 Month for $0.49/MO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightMostPopularFollowers_Year]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
            else
            {
                //Failed to load list of products.
                [HelperMethod ShowAlertWithMessage:kProductNotLoaded InViewController:self];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)PurchaseGhostFollowersProduct
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:kAPPName message:@"Buy Ghost Followers" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"1 Month for $0.99/MO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightGhostFollowers_OneMonth]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
            else
            {
                //Failed to load list of products.
                [HelperMethod ShowAlertWithMessage:kProductNotLoaded InViewController:self];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"6 Month for $0.75/MO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightGhostFollowers_SixMonth]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
            else
            {
                //Failed to load list of products.
                [HelperMethod ShowAlertWithMessage:kProductNotLoaded InViewController:self];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"12 Month for $0.49/MO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightGhostFollowers_Year]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
            else
            {
                //Failed to load list of products.
                [HelperMethod ShowAlertWithMessage:kProductNotLoaded InViewController:self];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}


#pragma mark-
#pragma mark- Web-Api Method

-(void)GetFollowers
{
    
    [[InstagramEngine sharedEngine] getFollowersOfUser:[[InstaUser sharedUserInstance] instaUserId] withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        NSLog(@"users = %@",users);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [users enumerateObjectsUsingBlock:^(InstagramUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [Followers saveFollowersList:obj];
            }];
            arrFollowers=[[NSMutableArray alloc] initWithArray:[Followers fetchFollowersByType:@"1"]];
            
            [self GetFollowings];
          
        });
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
       
    }];
    
}

-(void)GetFollowings
{
    
    [[InstagramEngine sharedEngine] getUsersFollowedByUser:[[InstaUser sharedUserInstance] instaUserId] withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        NSLog(@"users = %@",users);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [users enumerateObjectsUsingBlock:^(InstagramUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [Following saveFollowingsList:obj];
            }];
            arrFollowing=[[NSMutableArray alloc] initWithArray:[Following fetchFollowingsByType:@"1"]];
            [self CheckNotFollowingBack];
            [self CheckIamNotFollowingBack];
            
            [tblFreeUser reloadData];
           
        });
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
    }];
    
}

-(void)CheckIamNotFollowingBack
{
    AppDelegate *appDelegate=APP_DELEGATE;
    NSArray *arrNewFollowers=[Followers fetchFollowersDetails];
    
    NSMutableArray *arrTemp=[[NSMutableArray alloc] init];
    
    if (appDelegate.isNewIMNOTFollowingBackSaw) {
    
        arrNewIMNotF = [[NSMutableArray alloc] init];
    }
    
    [arrNewFollowers enumerateObjectsUsingBlock:^(Followers  *_Nonnull objF, NSUInteger idx, BOOL * _Nonnull stop) {
                
        if ([Following fetchFollowingsById:objF.followerId]==nil && (![objF.followerId isEqualToString:[InstaUser sharedUserInstance].objInstaUser.userId])) {
            
            if (![arrIMNotFollowingBack containsObject:objF]) {
                
                [arrNewIMNotF addObject:objF];
            }
            [arrTemp addObject:objF];
        }
    }];
    
    arrIMNotFollowingBack=arrTemp;
    
    appDelegate.isNewIMNOTFollowingBackSaw=FALSE;
    
}

-(void)CheckNotFollowingBack
{
    AppDelegate *appDelegate=APP_DELEGATE;
    NSArray *arrNewFollowers=[Following fetchFollowingsDetails];
    NSMutableArray *arrTemp=[[NSMutableArray alloc] init];
    
    if (appDelegate.isNewFollowingBackSaw) {
    
        arrNewF = [[NSMutableArray alloc] init];
    }
    
    [arrNewFollowers enumerateObjectsUsingBlock:^(Following  *_Nonnull objF, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([Followers fetchFollowersById:objF.followingId]==nil && (![objF.followingId isEqualToString:[InstaUser sharedUserInstance].objInstaUser.userId])) {
            
            if (![arrNotFollowingBack containsObject:objF]) {
            
                [arrNewF addObject:objF];
            }
            [arrTemp addObject:objF];
        }
    }];
    
    arrNotFollowingBack=arrTemp;
    appDelegate.isNewFollowingBackSaw=FALSE;
    
}

@end
