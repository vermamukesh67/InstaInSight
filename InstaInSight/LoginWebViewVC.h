//
//  LoginWebViewVC.h
//  InstaInSight
//
//  Created by Mukesh Verma on 16/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginWebViewVC : GAITrackedViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
