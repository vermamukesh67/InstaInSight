//
//  HelperMethod.m
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "HelperMethod.h"

@implementation HelperMethod

+(void)ShowAlertWithMessage:(NSString *)strMsg InViewController:(UIViewController *)objVC
{
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:strMsg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alertVC dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alertVC addAction:ok];
    [objVC presentViewController:alertVC animated:YES completion:^{
        
    }];
}


@end
