//
//  ViewController.h
//  InstaInSight
//
//  Created by Mukesh Verma on 16/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : GAITrackedViewController
{
    __weak IBOutlet UIActivityIndicatorView *actView;
    __weak IBOutlet UIButton *btnLogin;
    __weak IBOutlet UILabel *lblPlsWait;
    
}
- (IBAction)btnLoginTapped:(id)sender;

@end

