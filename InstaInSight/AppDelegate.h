//
//  AppDelegate.h
//  InstaInSight
//
//  Created by Mukesh Verma on 16/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HungamaMisicInApp.h"
@import GoogleMobileAds;
@import Firebase;

#import "GAI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GADInterstitialDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic) BOOL isProductISBeingPurchased;

- (void)createAndLoadInterstitial;

@end

