
//
//  ViewController.m
//  InstaInSight
//
//  Created by Mukesh Verma on 16/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "ViewController.h"
#import "LoginWebViewVC.h"
#import "AppTabBarVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [FIRAnalytics setScreenName:@"Login Screen" screenClass:@"ViewController"];
    [self setScreenName:@"LoginScreen"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    NSLog(@"appClientID=%@",[[InstagramEngine sharedEngine] appClientID]);
    NSLog(@"appRedirectURL=%@",[[InstagramEngine sharedEngine] appRedirectURL]);
    NSLog(@"accessToken=%@",[[InstagramEngine sharedEngine] accessToken]);
    
    
    if ([[[InstagramEngine sharedEngine] accessToken] length]>0) {
        
        [actView startAnimating];
        [btnLogin setUserInteractionEnabled:NO];
        [btnLogin setTitle:@"Please wait...." forState:UIControlStateNormal];
        
        
        [[InstagramEngine sharedEngine] getSelfUserDetailsWithSuccess:^(InstagramUser * _Nonnull user) {
            
            [actView stopAnimating];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[InstaUser sharedUserInstance] setObjInstaUser:user];
                NSArray *arrUsers=[[[InstagramEngine sharedEngine] accessToken] componentsSeparatedByString:@"."];
                if (arrUsers.count>0) {
                     [[InstaUser sharedUserInstance] setInstaUserId:[arrUsers firstObject]];
                }
               //LoginNavVC
                UINavigationController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"freeNavVC"];
                [[APP_DELEGATE window] setRootViewController:viewController];
                [[APP_DELEGATE window] makeKeyAndVisible];
                
                [APP_DELEGATE GetAdMobIds];
            });
            
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            [actView stopAnimating];
            [btnLogin setUserInteractionEnabled:YES];
            [btnLogin setTitle:@"Log in with Instagram" forState:UIControlStateNormal];
        }];
       
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnLoginTapped:(id)sender {
    
    LoginWebViewVC *objScr=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginWebViewVC"];
    UINavigationController *objNav=[[UINavigationController alloc] initWithRootViewController:objScr];
    [self presentViewController:objNav animated:YES completion:^{
        
    }];
}
@end
