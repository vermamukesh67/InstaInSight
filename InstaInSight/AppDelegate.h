//
//  AppDelegate.h
//  InstaInSight
//
//  Created by Mukesh Verma on 16/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HungamaMisicInApp.h"
#import <AFNetworking/AFNetworking.h>
@import GoogleMobileAds;
@import Firebase;

#import "GAI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GADInterstitialDelegate>
{
    NSMutableArray *arrAdIds;
}
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic) BOOL isProductISBeingPurchased,isNewFollowingBackSaw,isNewIMNOTFollowingBackSaw;

@property(nonatomic,assign) NSInteger followunfollowCount;

- (void)createAndLoadInterstitial;
-(void)GetAdMobIds;
-(void)PrepareAdv;
@end

