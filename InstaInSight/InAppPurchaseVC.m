//
//  InAppPurchaseVC.m
//  InstaInSight
//
//  Created by Verma Mukesh on 12/02/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import "InAppPurchaseVC.h"

@interface InAppPurchaseVC ()

@end

@implementation InAppPurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"In App Purchase"];
    
    tblPurchase.tableFooterView = [UIView new];
    
    tblPurchase.estimatedRowHeight=100;
    tblPurchase.rowHeight = UITableViewAutomaticDimension;
    
    arrPurchased=[[NSMutableArray alloc] initWithObjects:
                  
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Upgrade to PRO   (all features)",@"title",@"4,99 dollars (  for one month) 3,99 dollars (  for 6 months/monthly) 2,99 dollars (  for one year/monthly)",@"desc", nil],
                  
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Remove Ads",@"title",@"1,99 dollars  (for one month) 1,49 dollars (  for 6 months/monthly) 0,99 dollars (for one year/monthly)",@"desc", nil],
                  
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Restore All",@"title",@"Restore in case you already purchased before",@"desc", nil], nil];
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
    return arrPurchased.count;
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return arrPurchased.count;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

//-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    NSDictionary *diccPurchase=[arrPurchased objectAtIndex:section];
//    return [diccPurchase objectForKey:@"desc"];
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"purchaseCell"];
    NSDictionary *diccPurchase=[arrPurchased objectAtIndex:indexPath.row];
    [cell.textLabel setText:[diccPurchase objectForKey:@"title"]];
    [cell.detailTextLabel setText:[diccPurchase objectForKey:@"desc"]];
    [cell.detailTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.detailTextLabel setNumberOfLines:6];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            [self PurchaseUpgradeToProProduct];
            
        }
            break;
        case 1:
        {
            [self PurchaseRemoveAdsProduct];
        }
            break;
        case 2:
        {
            [[HungamaMisicInApp sharedHungamaMisicInAppInstance] restoreCompletedTransactions];
        }
            break;
            
        default:
            break;
    }
}

-(void)PurchaseUpgradeToProProduct
{
 
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:kAPPName message:@"Buy Upgrade To Pro" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For 1 Month In $2.99" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightUpgradeToPro_OneMonth]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For 6 Month In $3.99" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightUpgradeToPro_SixMonth]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For Year In $4.99" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightUpgradeToPro_Year]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)PurchaseRemoveAdsProduct
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:kAPPName message:@"Buy Remove Ads" preferredStyle:UIAlertControllerStyleActionSheet];
    
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
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"For Year In $1.99" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] SetProductIdentifiers:[NSSet setWithObject:kInstaInsightRemoveAds_Year]];
        
        [[HungamaMisicInApp sharedHungamaMisicInAppInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (products.count>0) {
                
                [[HungamaMisicInApp sharedHungamaMisicInAppInstance] buyProduct:[products firstObject]];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

@end
