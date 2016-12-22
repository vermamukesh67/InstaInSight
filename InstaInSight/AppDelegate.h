//
//  AppDelegate.h
//  InstaInSight
//
//  Created by Mukesh Verma on 16/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface AppDelegate : UIResponder <UIApplicationDelegate,GADInterstitialDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) GADInterstitial *interstitial;

- (void)createAndLoadInterstitial;

@end

