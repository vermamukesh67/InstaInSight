//
//  Constant.h
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#import "AppDelegate.h"
#import "InstagramKit.h"
#import "InstaUser.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "HelperMethod.h"
#import "CoreDataManager.h"
#import "Following+CoreDataProperties.h"
#import "Followers+CoreDataProperties.h"
#import "NSDate+Extra.h"
#import "UserCell.h"
#import "NSArray+Extra.h"


#define UIViewParentController(__view) ({ \
UIResponder *__responder = __view; \
while ([__responder isKindOfClass:[UIView class]]) \
__responder = [__responder nextResponder]; \
(UIViewController *)__responder; \
})

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define APP_DELEGATE                (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define userIntrectionEnable(value)   [APP_DELEGATE window].userInteractionEnabled = value
#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height
#define NAVBARHEIGHT 64.0f
#define ZEROINSET UIEdgeInsetsMake(0, 0, 0, 0)
#define SCREENBOUNDS CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)
#define ShowNetworkIndicatorVisible(value)  [UIApplication sharedApplication].networkActivityIndicatorVisible=value
#define ShowHideStatusBarVisible(value) [[UIApplication sharedApplication] setStatusBarHidden:value]
#define COLOR_WITH_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define MANAGED_OBJECT_CONTEXT [[CoreDataManager sharedInstance] managedObjectContext]

#define kDefaultDateFormat @"yyyy-MM-dd HH:mm:ss"
#define kDefaultShortDateFormat @"yyyy-MM-dd"

#define kAPPName @"InstaInsight"
#define kIsProductPurchased @"IsProductPurchased"

#define kProductNotLoaded @"No such product found on itunes store"

// Upgrade to Pro Products Ids

#define kInstaInsightUpgradeToPro_OneMonth @"InstaInsightUpgradeToPro_OneMonth"
#define kInstaInsightUpgradeToPro_SixMonth @"InstaInsightUpgradeToPro_SixMonth"
#define kInstaInsightUpgradeToPro_Year     @"InstaInsightUpgradeToPro_Year"

// RemoveAds Products Ids

#define kInstaInsightRemoveAds_OneMonth @"InstaInsightRemoveAds_OneMonth"
#define kInstaInsightRemoveAds_SixMonth @"InstaInsightRemoveAds_SixMonth"
#define kInstaInsightRemoveAds_Year     @"InstaInsightRemoveAds_Year"

//ProfileViewer Products Ids

#define kInstaInsightProfileViewer_OneMonth @"InstaInsightProfileViewer_OneMonth"
#define kInstaInsightProfileViewer_SixMonth @"InstaInsightProfileViewer_SixMonth"
#define kInstaInsightProfileViewer_Year     @"InstaInsightProfileViewer_Year"

//My Top Likers Products Ids

#define kInstaInsightMyTopLikers_OneMonth @"InstaInsightMyTopLikers_OneMonth"
#define kInstaInsightMyTopLikers_SixMonth @"InstaInsightMyTopLikers_SixMonth"
#define kInstaInsightMyTopLikers_Year     @"InstaInsightMyTopLikers_Year"

//Who I Liked Most Products Ids

#define kInstaInsightWhoILikedMost_OneMonth @"InstaInsightWhoILikedMost_OneMonth"
#define kInstaInsightWhoILikedMost_SixMonth @"InstaInsightWhoILikedMost_SixMonth"
#define kInstaInsightWhoILikedMost_Year     @"InstaInsightWhoILikedMost_Year"

//Most Popular Followers Products Ids

#define kInstaInsightMostPopularFollowers_OneMonth @"InstaInsightMostPopularFollowers_OneMonth"
#define kInstaInsightMostPopularFollowers_SixMonth @"InstaInsightMostPopularFollowers_SixMonth"
#define kInstaInsightMostPopularFollowers_Year     @"InstaInsightMostPopularFollowers_Year"

//Ghost Followers Products Ids

#define kInstaInsightGhostFollowers_OneMonth @"InstaInsightGhostFollowers_OneMonth"
#define kInstaInsightGhostFollowers_SixMonth @"InstaInsightGhostFollowers_SixMonth"
#define kInstaInsightGhostFollowers_Year     @"InstaInsightGhostFollowers_Year"


#endif /* Constant_h */
