//
//  AppDelegate.m
//  InstaInSight
//
//  Created by Mukesh Verma on 16/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "AppDelegate.h"
#define AdInterval 10.0f


@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize followunfollowCount;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Use Firebase library to configure APIs
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    [FIRApp configure];
    
    followunfollowCount=0;
    [Followers fetchAndUpdateIsNewFlagFollowersDetails];
    [Following fetchAndUpdateIsNewFlagFollowingsDetails];
    /*
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     kFIRParameterItemID:[NSString stringWithFormat:@"id-%@", self.title],
                                     kFIRParameterItemName:self.title,
                                     kFIRParameterContentType:@"image"
                                     }]; */
    
    [[HungamaMisicInApp sharedHungamaMisicInAppInstance] setIsTransactionFailureHandling:YES];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[HungamaMisicInApp sharedHungamaMisicInAppInstance]];
    
   
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)GetAdMobIds
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"Https://www.getirali.com/InstaInsight.asmx/GetIOSAdmobIds?Token=cxmuR5UDZNHjIsvr32mIeJW8yk5hQr9r9sdel5ODEsD9ms6HZAaAvCFgdQ7c9Kc6"]];
    
    NSData *data=[NSData dataWithContentsOfURL:URL];
    
    NSString *strText=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSLog(@"%@",[strText componentsSeparatedByString:@","]);
    
    NSMutableArray *array=[[strText componentsSeparatedByString:@","] mutableCopy];
    
    arrAdIds=array;
    
    NSLog(@"arrAdIds=%@",arrAdIds);
    
     [self performSelector:@selector(PrepareAdv) withObject:nil afterDelay:AdInterval];
}

-(void)PrepareAdv
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"instaDate"]) {
        
        NSString *strDate=[[NSUserDefaults standardUserDefaults] objectForKey:@"instaDate"];
        NSDate *instaDate=[HelperMethod ConvertDateTosystemTimeZone:strDate];
        NSDate *todayDate=[NSDate date];
        if ([todayDate isLaterThan:instaDate] && arrAdIds.count>0 ) {
            
            self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:[arrAdIds firstObject]];//@"ca-app-pub-3923375576341160/1197539334"
            self.interstitial.delegate=self;
            GADRequest *request = [GADRequest request];
            // Request test ads on devices you specify. Your test device ID is printed to the console when
            // an ad request is made.   if ([todayDate isLaterThan:instaDate] && arrAdIds.count>0 ) {
            request.testDevices = @[ kGADSimulatorID, @"2077ef9a63d2b398840261c8221a0c9a" ];
            [self.interstitial loadRequest:request];
        }
    }
    else
    {
        NSLog(@"date = %@",[HelperMethod getStringFromDate:[[NSDate date] dateByAddingDays:2]]);
        [[NSUserDefaults standardUserDefaults] setObject:[HelperMethod getStringFromDate:[[NSDate date] dateByAddingDays:2]] forKey:@"instaDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
}


- (void)createAndLoadInterstitial {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"instaDate"]) {
        
        NSString *strDate=[[NSUserDefaults standardUserDefaults] objectForKey:@"instaDate"];
        NSDate *instaDate=[HelperMethod ConvertDateTosystemTimeZone:strDate];
        NSDate *todayDate=[NSDate date];
        if ([todayDate isLaterThan:instaDate] && arrAdIds.count>0 ) {
            
            NSLog(@"root view controller = %@",[self.window rootViewController]);
            if (self.interstitial.isReady) {
                NSLog(@"root view controller = %@",[self.window rootViewController]);
                [self.interstitial presentFromRootViewController:[self.window rootViewController]];
                
                
                
            } else {
                NSLog(@"Ad wasn't ready");
                [self performSelector:@selector(createAndLoadInterstitial) withObject:nil afterDelay:AdInterval];
            }
        }
    }
}
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSLog(@"%s %d %s %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
    
    [self createAndLoadInterstitial];
}

/// Called before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad
{
    NSLog(@"%s %d %s %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
}

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    NSLog(@"%s %d %s %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    NSLog(@"%s %d %s %s", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
}


@end
