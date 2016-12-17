//
//  ViewController.m
//  InstaInSight
//
//  Created by Mukesh Verma on 16/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "ViewController.h"
#import "LoginWebViewVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
