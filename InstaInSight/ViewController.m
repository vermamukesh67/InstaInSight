
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"appClientID=%@",[[InstagramEngine sharedEngine] appClientID]);
    NSLog(@"appRedirectURL=%@",[[InstagramEngine sharedEngine] appRedirectURL]);
    NSLog(@"accessToken=%@",[[InstagramEngine sharedEngine] accessToken]);
    
    if ([[[InstagramEngine sharedEngine] accessToken] length]>0) {
        
        [actView startAnimating];
        [btnLogin setTitle:@"Please Wait.." forState:UIControlStateNormal];
        
        [[InstagramEngine sharedEngine] getSelfUserDetailsWithSuccess:^(InstagramUser * _Nonnull user) {
            
            [actView stopAnimating];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[InstaUser sharedUserInstance] setObjInstaUser:user];
                NSArray *arrUsers=[[[InstagramEngine sharedEngine] accessToken] componentsSeparatedByString:@"."];
                if (arrUsers.count>0) {
                     [[InstaUser sharedUserInstance] setInstaUserId:[arrUsers firstObject]];
                }
               
                UINavigationController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AppTabBarVC"];
                [[APP_DELEGATE window] setRootViewController:viewController];
                [[APP_DELEGATE window] makeKeyAndVisible];
            });
            
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            
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
