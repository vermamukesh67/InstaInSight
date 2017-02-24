//
//  PaidUserVC.m
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "PaidUserVC.h"
#import "ProfileViewer.h"
#import "TopLikers.h"
#import "WhoIlikedMost.h"
#import "GhostFollowers.h"
#import "PopularFollower.h"
#import "InAppPurchaseVC.h"

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
                [NSDictionary dictionaryWithObjectsAndKeys:@"Friends who viewed my profile",@"title",@"profileviewer",@"imgName", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"My Top Likers",@"title",@"mytoplikes",@"imgName", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"Who i Like Most",@"title",@"whoilikemost",@"imgName", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"Popular Followers",@"title",@"popularfollowers",@"imgName", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"Ghost Followers",@"title",@"ghostfollowers",@"imgName", nil],
                
                nil];
    
    [FIRAnalytics setScreenName:@"paiduser" screenClass:@"PaidUserVC"];
    [self setScreenName:@"PaidUser"];
    
    tblPaidUser.tableFooterView = [UIView new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ProductPurchasedSusceeeFully:) name:HungamaMusicProductPurchasedNotification object:nil];
    
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

-(void)ProductPurchasedSusceeeFully:(NSNotification *)object
{
    
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
            //[self CheckConditionForProfileViewer];
        }
            break;
        case 1:
        {
            TopLikers *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"TopLikers"];
            [objScr setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:objScr animated:YES];
           // [self CheckConditionForMyTopLikers];
        }
            break;
        case 2:
        {
            WhoIlikedMost *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"WhoIlikedMost"];
            [objScr setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:objScr animated:YES];
            //[self CheckConditionForWhoIlikedMost];
        }
            break;
        case 3:
        {
            PopularFollower *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"PopularFollower"];
            [objScr setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:objScr animated:YES];
            //[self CheckConditionForPopularFollowers];
        }
            break;
        case 4:
        {
            GhostFollowers *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"GhostFollowers"];
            [objScr setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:objScr animated:YES];
            //[self CheckConditionForGhostFollowers];
        }
            break;
            
        default:
            break;
    }
    
    
}


-(void)CheckConditionForProfileViewer
{
    NSString *strProId=[HelperMethod CheckForProfileViewerPurchase];
    
    if (strProId!=nil) {
        
        SKPaymentTransaction *transaction=[[NSUserDefaults standardUserDefaults] objectForKey:strProId];
        
        if (transaction) {
            
            NSDate *transactionDate=transaction.transactionDate;
            if ([strProId isEqualToString:kInstaInsightProfileViewer_Year] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                [self GoToProfileViewer];
            }
            else  if ([strProId isEqualToString:kInstaInsightProfileViewer_SixMonth] && [[transactionDate dateByAddingDays:365/2] isEarlierThanOrEqualTo:[NSDate date]]) {
                [self GoToProfileViewer];
            }
            else  if ([strProId isEqualToString:kInstaInsightProfileViewer_OneMonth] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                [self GoToProfileViewer];
            }
            else
            {
                [self PurchaseProfileViewerProduct];
            }
        }
        else
        {
            [self PurchaseProfileViewerProduct];
        }
        
    }
    else
    {
        [self PurchaseProfileViewerProduct];
    }
}

-(void)CheckConditionForGhostFollowers
{
    NSString *strProId=[HelperMethod CheckForGhostFollowerPurchase];
    
    if (strProId!=nil) {
        
        SKPaymentTransaction *transaction=[[NSUserDefaults standardUserDefaults] objectForKey:strProId];
        
        if (transaction) {
            
            NSDate *transactionDate=transaction.transactionDate;
            if ([strProId isEqualToString:kInstaInsightGhostFollowers_Year] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                [self GoToGhostFollowers];
            }
            else  if ([strProId isEqualToString:kInstaInsightGhostFollowers_SixMonth] && [[transactionDate dateByAddingDays:365/2] isEarlierThanOrEqualTo:[NSDate date]]) {
                [self GoToGhostFollowers];
            }
            else  if ([strProId isEqualToString:kInstaInsightGhostFollowers_OneMonth] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                [self GoToGhostFollowers];
            }
            else
            {
                [self PurchaseGhostFollowersProduct];
            }
        }
        else
        {
            [self PurchaseGhostFollowersProduct];
        }
        
    }
    else
    {
        [self PurchaseGhostFollowersProduct];
    }
}
-(void)CheckConditionForPopularFollowers
{
    NSString *strProId=[HelperMethod CheckForMostPopularFollowerPurchase];
    
    if (strProId!=nil) {
        
        SKPaymentTransaction *transaction=[[NSUserDefaults standardUserDefaults] objectForKey:strProId];
        
        if (transaction) {
            
            NSDate *transactionDate=transaction.transactionDate;
            if ([strProId isEqualToString:kInstaInsightMostPopularFollowers_Year] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                [self GoToPopularFollower];
            }
            else  if ([strProId isEqualToString:kInstaInsightMostPopularFollowers_SixMonth] && [[transactionDate dateByAddingDays:365/2] isEarlierThanOrEqualTo:[NSDate date]]) {
                [self GoToPopularFollower];
            }
            else  if ([strProId isEqualToString:kInstaInsightMostPopularFollowers_OneMonth] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                [self GoToPopularFollower];
            }
            else
            {
                [self PurchaseMostPopularProduct];
            }
        }
        else
        {
            [self PurchaseMostPopularProduct];
        }
        
    }
    else
    {
        [self PurchaseMostPopularProduct];
    }
}

-(void)CheckConditionForMyTopLikers
{
    NSString *strProId=[HelperMethod CheckForMyTopLikersPurchase];
    
    if (strProId!=nil) {
        
        SKPaymentTransaction *transaction=[[NSUserDefaults standardUserDefaults] objectForKey:strProId];
        
        if (transaction) {
            
            NSDate *transactionDate=transaction.transactionDate;
            if ([strProId isEqualToString:kInstaInsightMyTopLikers_Year] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                [self GoToTopLikers];
            }
            else  if ([strProId isEqualToString:kInstaInsightMyTopLikers_SixMonth] && [[transactionDate dateByAddingDays:365/2] isEarlierThanOrEqualTo:[NSDate date]]) {
                [self GoToTopLikers];
            }
            else  if ([strProId isEqualToString:kInstaInsightMyTopLikers_OneMonth] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                [self GoToTopLikers];
            }
            else
            {
                [self PurchaseMyTopLikersProduct];
            }
        }
        else
        {
            [self PurchaseMyTopLikersProduct];
        }
        
    }
    else
    {
        [self PurchaseMyTopLikersProduct];
    }
}

-(void)CheckConditionForWhoIlikedMost
{
    NSString *strProId=[HelperMethod CheckForWhoILikedMostPurchase];
    
    if (strProId!=nil) {
        
        SKPaymentTransaction *transaction=[[NSUserDefaults standardUserDefaults] objectForKey:strProId];
        
        if (transaction) {
            
            NSDate *transactionDate=transaction.transactionDate;
            if ([strProId isEqualToString:kInstaInsightWhoILikedMost_Year] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                [self GoToWhoIlikedMost];
            }
            else  if ([strProId isEqualToString:kInstaInsightWhoILikedMost_SixMonth] && [[transactionDate dateByAddingDays:365/2] isEarlierThanOrEqualTo:[NSDate date]]) {
                [self GoToProfileViewer];
            }
            else  if ([strProId isEqualToString:kInstaInsightWhoILikedMost_OneMonth] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                [self GoToWhoIlikedMost];
            }
            else
            {
                [self PurchaseWhoILikedMostProduct];
            }
        }
        else
        {
            [self PurchaseWhoILikedMostProduct];
        }
        
    }
    else
    {
        [self PurchaseWhoILikedMostProduct];
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


-(void)LoadProductsIds
{
    [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObjects:kInstaInsightRemoveAds_Year,kInstaInsightRemoveAds_SixMonth,kInstaInsightRemoveAds_OneMonth,kInstaInsightMyTopLikers_Year,kInstaInsightMyTopLikers_SixMonth,kInstaInsightMyTopLikers_OneMonth,
        kInstaInsightProfileViewer_Year,kInstaInsightProfileViewer_SixMonth,kInstaInsightProfileViewer_OneMonth,
        kInstaInsightMostPopularFollowers_Year,kInstaInsightMostPopularFollowers_SixMonth,kInstaInsightMostPopularFollowers_OneMonth,
        kInstaInsightUpgradeToPro_Year,kInstaInsightUpgradeToPro_SixMonth,kInstaInsightUpgradeToPro_OneMonth ,
        kInstaInsightWhoILikedMost_Year,kInstaInsightWhoILikedMost_SixMonth,kInstaInsightWhoILikedMost_OneMonth,
        kInstaInsightGhostFollowers_Year,kInstaInsightGhostFollowers_SixMonth,kInstaInsightGhostFollowers_OneMonth,nil]];
    
    [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        
        arrProductsIds=[NSArray arrayWithArray:products];
        NSLog(@"in app purchase products = %@",arrProductsIds);
        
    }];
    
}

#pragma mark - UIButton Tapped Method

- (IBAction)btnBuyTapped:(id)sender {
    
    InAppPurchaseVC *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"InAppPurchaseVC"];
    [objScr setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:objScr animated:YES];
    
}

-(void)PurchaseProfileViewerProduct
{
    
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:kAPPName message:@"Buy Profile Viewer" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For 1 Month In $0.99" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_OneMonth]];
        
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
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For 6 Month In $1.49" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_SixMonth]];
        
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
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For Year In $1.99" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_Year]];
        
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
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For 1 Month In $0.99" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_OneMonth]];
        
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
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For 6 Month In $1.49" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_SixMonth]];
        
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
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For Year In $1.99" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_Year]];
        
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
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For 1 Month In $0.99" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_OneMonth]];
        
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
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For 6 Month In $1.49" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_SixMonth]];
        
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
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For Year In $1.99" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_Year]];
        
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
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For 1 Month In $0.99" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_OneMonth]];
        
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
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For 6 Month In $1.49" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_SixMonth]];
        
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
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For Year In $1.99" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_Year]];
        
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
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For 1 Month In $0.99" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_OneMonth]];
        
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
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For 6 Month In $1.49" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_SixMonth]];
        
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
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For Year In $1.99" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_Year]];
        
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


@end
