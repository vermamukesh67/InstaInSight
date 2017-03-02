//
//  HelperMethod.m
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "HelperMethod.h"

@implementation HelperMethod

+(void)ShowAlertWithMessage:(NSString *)strMsg InViewController:(UIViewController *)objVC
{
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:strMsg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alertVC dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alertVC addAction:ok];
    [objVC presentViewController:alertVC animated:YES completion:^{
        
    }];
}

+(NSString *)getStringFromDate:(NSDate *)date
{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [df setDateFormat:kDefaultDateFormat];
    NSString *strDate = [df stringFromDate:date];
    return strDate;
}
+(NSDate *)ConvertDateTosystemTimeZone:(NSString *)strDate
{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [df setDateFormat:kDefaultDateFormat];
    NSDate *date=[df dateFromString:strDate];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter1 setDateFormat:kDefaultDateFormat];
    NSString *sysTemDate=[formatter1 stringFromDate:date];
    return [formatter1 dateFromString:sysTemDate];
}

+(NSString *)CheckForProfileViewerPurchase
{
    NSString *productIdentifier=nil;
 
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightProfileViewer_Year]) {
        
        return kInstaInsightProfileViewer_Year;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightProfileViewer_SixMonth])
    {
        return kInstaInsightProfileViewer_SixMonth;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightProfileViewer_OneMonth])
    {
        return kInstaInsightProfileViewer_OneMonth;
    }
    
    
    return productIdentifier;
}

+(BOOL)CheckProfileViewerAndSubscriptionIsNotExpired
{
    NSString *strProId=[HelperMethod CheckForProfileViewerPurchase];
    
    if (strProId!=nil) {
        
        SKPaymentTransaction *transaction=[[NSUserDefaults standardUserDefaults] objectForKey:strProId];
        
        if (transaction) {
            
            NSDate *transactionDate=transaction.transactionDate;
            if ([strProId isEqualToString:kInstaInsightProfileViewer_Year] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else  if ([strProId isEqualToString:kInstaInsightProfileViewer_SixMonth] && [[transactionDate dateByAddingDays:365/2] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else  if ([strProId isEqualToString:kInstaInsightProfileViewer_OneMonth] && [[transactionDate dateByAddingDays:30] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
        
    }
    else
    {
        return NO;
    }
}


+(NSString *)CheckForMyTopLikersPurchase
{
    NSString *productIdentifier=nil;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightMyTopLikers_Year]) {
        
        return kInstaInsightMyTopLikers_Year;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightMyTopLikers_SixMonth])
    {
        return kInstaInsightMyTopLikers_SixMonth;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightMyTopLikers_OneMonth])
    {
        return kInstaInsightMyTopLikers_OneMonth;
    }
    
    
    return productIdentifier;
}

+(BOOL)CheckMyTopLikersAndSubscriptionIsNotExpired
{
    NSString *strProId=[HelperMethod CheckForMyTopLikersPurchase];
    
    if (strProId!=nil) {
        
        SKPaymentTransaction *transaction=[[NSUserDefaults standardUserDefaults] objectForKey:strProId];
        
        if (transaction) {
            
            NSDate *transactionDate=transaction.transactionDate;
            if ([strProId isEqualToString:kInstaInsightMyTopLikers_Year] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else  if ([strProId isEqualToString:kInstaInsightMyTopLikers_SixMonth] && [[transactionDate dateByAddingDays:365/2] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else  if ([strProId isEqualToString:kInstaInsightMyTopLikers_OneMonth] && [[transactionDate dateByAddingDays:30] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
        
    }
    else
    {
        return NO;
    }
}


+(NSString *)CheckForWhoILikedMostPurchase
{
    NSString *productIdentifier=nil;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightWhoILikedMost_Year]) {
        
        return kInstaInsightWhoILikedMost_Year;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightWhoILikedMost_SixMonth])
    {
        return kInstaInsightWhoILikedMost_SixMonth;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightWhoILikedMost_OneMonth])
    {
        return kInstaInsightWhoILikedMost_OneMonth;
    }
    
    
    return productIdentifier;
}

+(BOOL)CheckWhoILikedMostAndSubscriptionIsNotExpired
{
    NSString *strProId=[HelperMethod CheckForWhoILikedMostPurchase];
    
    if (strProId!=nil) {
        
        SKPaymentTransaction *transaction=[[NSUserDefaults standardUserDefaults] objectForKey:strProId];
        
        if (transaction) {
            
            NSDate *transactionDate=transaction.transactionDate;
            if ([strProId isEqualToString:kInstaInsightWhoILikedMost_Year] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else  if ([strProId isEqualToString:kInstaInsightWhoILikedMost_SixMonth] && [[transactionDate dateByAddingDays:365/2] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else  if ([strProId isEqualToString:kInstaInsightWhoILikedMost_OneMonth] && [[transactionDate dateByAddingDays:30] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
        
    }
    else
    {
        return NO;
    }
}


+(NSString *)CheckForMostPopularFollowerPurchase
{
    NSString *productIdentifier=nil;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightMostPopularFollowers_Year]) {
        
        return kInstaInsightMostPopularFollowers_Year;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightMostPopularFollowers_SixMonth])
    {
        return kInstaInsightMostPopularFollowers_SixMonth;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightMostPopularFollowers_OneMonth])
    {
        return kInstaInsightMostPopularFollowers_OneMonth;
    }
    
    
    return productIdentifier;
}

+(BOOL)CheckMostPopularFollowerAndSubscriptionIsNotExpired
{
    NSString *strProId=[HelperMethod CheckForMostPopularFollowerPurchase];
    
    if (strProId!=nil) {
        
        SKPaymentTransaction *transaction=[[NSUserDefaults standardUserDefaults] objectForKey:strProId];
        
        if (transaction) {
            
            NSDate *transactionDate=transaction.transactionDate;
            if ([strProId isEqualToString:kInstaInsightMostPopularFollowers_Year] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else  if ([strProId isEqualToString:kInstaInsightMostPopularFollowers_SixMonth] && [[transactionDate dateByAddingDays:365/2] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else  if ([strProId isEqualToString:kInstaInsightMostPopularFollowers_OneMonth] && [[transactionDate dateByAddingDays:30] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
        
    }
    else
    {
        return NO;
    }
}



+(NSString *)CheckForGhostFollowerPurchase
{
    NSString *productIdentifier=nil;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightGhostFollowers_Year]) {
        
        return kInstaInsightGhostFollowers_Year;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightGhostFollowers_SixMonth])
    {
        return kInstaInsightGhostFollowers_SixMonth;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightGhostFollowers_OneMonth])
    {
        return kInstaInsightGhostFollowers_OneMonth;
    }
    
    
    return productIdentifier;
}

+(BOOL)CheckGhostFollowerAndSubscriptionIsNotExpired
{
    NSString *strProId=[HelperMethod CheckForGhostFollowerPurchase];
    
    if (strProId!=nil) {
        
        SKPaymentTransaction *transaction=[[NSUserDefaults standardUserDefaults] objectForKey:strProId];
        
        if (transaction) {
            
            NSDate *transactionDate=transaction.transactionDate;
            if ([strProId isEqualToString:kInstaInsightGhostFollowers_Year] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else  if ([strProId isEqualToString:kInstaInsightGhostFollowers_SixMonth] && [[transactionDate dateByAddingDays:365/2] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else  if ([strProId isEqualToString:kInstaInsightGhostFollowers_OneMonth] && [[transactionDate dateByAddingDays:30] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
        
    }
    else
    {
        return NO;
    }
}

+(NSString *)CheckForRemoveAdsPurchase
{
    NSString *productIdentifier=nil;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightRemoveAds_Year]) {
        
        return kInstaInsightRemoveAds_Year;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightRemoveAds_SixMonth])
    {
        return kInstaInsightRemoveAds_SixMonth;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightRemoveAds_OneMonth])
    {
        return kInstaInsightRemoveAds_OneMonth;
    }
    
    
    return productIdentifier;
}


+(BOOL)CheckRemoveAdsAndSubscriptionIsNotExpired
{
    NSString *strProId=[HelperMethod CheckForRemoveAdsPurchase];
    
    if (strProId!=nil) {
        
        SKPaymentTransaction *transaction=[[NSUserDefaults standardUserDefaults] objectForKey:strProId];
        
        if (transaction) {
            
            NSDate *transactionDate=transaction.transactionDate;
            if ([strProId isEqualToString:kInstaInsightRemoveAds_Year] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else  if ([strProId isEqualToString:kInstaInsightRemoveAds_SixMonth] && [[transactionDate dateByAddingDays:365/2] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else  if ([strProId isEqualToString:kInstaInsightRemoveAds_OneMonth] && [[transactionDate dateByAddingDays:30] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
        
    }
    else
    {
        return NO;
    }
}


+(NSString *)CheckForUpgradeToProPurchase
{
    NSString *productIdentifier=nil;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightUpgradeToPro_Year]) {
        
        return kInstaInsightUpgradeToPro_Year;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightUpgradeToPro_SixMonth])
    {
        return kInstaInsightUpgradeToPro_SixMonth;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightUpgradeToPro_OneMonth])
    {
        return kInstaInsightUpgradeToPro_OneMonth;
    }
    
    
    return productIdentifier;
}


+(BOOL)CheckUserIsProUserAndSubscriptionIsNotExpired
{
    NSString *strProId=[HelperMethod CheckForUpgradeToProPurchase];
    
    if (strProId!=nil) {
        
        SKPaymentTransaction *transaction=[[NSUserDefaults standardUserDefaults] objectForKey:strProId];
        
        if (transaction) {
            
            NSDate *transactionDate=transaction.transactionDate;
            if ([strProId isEqualToString:kInstaInsightUpgradeToPro_Year] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else  if ([strProId isEqualToString:kInstaInsightUpgradeToPro_SixMonth] && [[transactionDate dateByAddingDays:365/2] isEarlierThanOrEqualTo:[NSDate date]]) {
                return YES;
            }
            else  if ([strProId isEqualToString:kInstaInsightUpgradeToPro_OneMonth] && [[transactionDate dateByAddingDays:365] isEarlierThanOrEqualTo:[NSDate date]]) {
               return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
        
    }
    else
    {
        return NO;
    }
}

@end
