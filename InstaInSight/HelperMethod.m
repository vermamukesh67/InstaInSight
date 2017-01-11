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

+(NSString *)getStringFromDate:(NSDate *)date
{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [df setDateFormat:kDefaultDateFormat];
    NSString *strDate = [df stringFromDate:date];
    return strDate;
}
+(NSDate *)ConvertDateTosystemTimeZone:(NSString *)strDate
{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [df setDateFormat:kDefaultDateFormat];
    NSDate *date=[df dateFromString:strDate];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter1 setDateFormat:kDefaultDateFormat];
    NSString *sysTemDate=[formatter1 stringFromDate:date];
    return [formatter1 dateFromString:sysTemDate];
}

@end
