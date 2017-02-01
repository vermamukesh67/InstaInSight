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

#endif /* Constant_h */
