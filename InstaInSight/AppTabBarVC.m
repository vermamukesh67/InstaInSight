//
//  AppTabBarVC.m
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "AppTabBarVC.h"

@interface AppTabBarVC ()

@end

@implementation AppTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITabBarController *tabBarController = self;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    
    
    [tabBarItem2 setImage: [[UIImage imageNamed:@"paid"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
   // [tabBarItem2 setSelectedImage: [[UIImage imageNamed:@"paid"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    [tabBarItem1 setImage: [[UIImage imageNamed:@"free"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
   // [tabBarItem1 setSelectedImage: [[UIImage imageNamed:@"free"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    [tabBarItem1 setImageInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
    [tabBarItem2 setImageInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
    
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    // Change the tab bar background
    [[UITabBar appearance] setBackgroundImage:[self ResizeImage:@"grayBg" WithSize:CGSizeMake(SCREENWIDTH, 50)]];
    [[UITabBar appearance] setSelectionIndicatorImage:[self ResizeImage:@"tabBg" WithSize:CGSizeMake(SCREENWIDTH/2, 50)]];
    
}

-(UIImage *)ResizeImage:(NSString *)strImgName WithSize:(CGSize)destinationSize
{
    UIImage *originalImage = [UIImage imageNamed:strImgName];
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
