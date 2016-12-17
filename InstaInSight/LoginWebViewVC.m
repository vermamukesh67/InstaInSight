//
//  LoginWebViewVC.m
//  InstaInSight
//
//  Created by Mukesh Verma on 16/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "LoginWebViewVC.h"

@interface LoginWebViewVC ()

@end

@implementation LoginWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
UIActivityIndicatorView *actbar=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
[actbar setHidesWhenStopped:YES];*/

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_actView]];
    InstagramKitLoginScope scope = InstagramKitLoginScopeBasic |InstagramKitLoginScopeRelationships | InstagramKitLoginScopeComments | InstagramKitLoginScopeLikes | InstagramKitLoginScopePublicContent | InstagramKitLoginScopeFollowerList;

    NSURL *authURL = [[InstagramEngine sharedEngine] authorizationURLForScope:scope];
    [self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:request.URL error:&error])
    {
        NSLog(@"shouldStartLoadWithRequest");
        [self.actView stopAnimating];
        if ([[[InstagramEngine sharedEngine] accessToken] length]>0) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
   [self.actView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.actView stopAnimating];
    NSLog(@"didFailLoadWithError");
    
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
