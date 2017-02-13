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

+(NSString *)CheckForMyTopLikersPurchase
{
    NSString *productIdentifier=nil;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kInstaInsightMyTopLikers_OneMonth]) {
        
        return kInstaInsightMyTopLikers_OneMonth;
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

@end
