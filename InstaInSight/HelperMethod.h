//
//  HelperMethod.h
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelperMethod : NSObject
+(void)ShowAlertWithMessage:(NSString *)strMsg InViewController:(UIViewController *)objVC;
+(NSString *)getStringFromDate:(NSDate *)date;
+(NSDate *)ConvertDateTosystemTimeZone:(NSString *)strDate;

+(NSString *)CheckForProfileViewerPurchase;
+(NSString *)CheckForMyTopLikersPurchase;
+(NSString *)CheckForWhoILikedMostPurchase;
+(NSString *)CheckForMostPopularFollowerPurchase;
+(NSString *)CheckForGhostFollowerPurchase;
+(NSString *)CheckForRemoveAdsPurchase;
+(NSString *)CheckForUpgradeToProPurchase;
+(BOOL)CheckUserIsProUserAndSubscriptionIsNotExpired;
+(BOOL)CheckRemoveAdsAndSubscriptionIsNotExpired;
+(BOOL)CheckProfileViewerAndSubscriptionIsNotExpired;
+(BOOL)CheckMyTopLikersAndSubscriptionIsNotExpired;
+(BOOL)CheckWhoILikedMostAndSubscriptionIsNotExpired;
+(BOOL)CheckMostPopularFollowerAndSubscriptionIsNotExpired;
+(BOOL)CheckGhostFollowerAndSubscriptionIsNotExpired;
@end
