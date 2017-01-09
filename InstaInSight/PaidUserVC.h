//
//  PaidUserVC.h
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaidUserVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UIView *headerView;
    __weak IBOutlet UIView *whiteBox;
    __weak IBOutlet UIImageView *imgProfileView;
    __weak IBOutlet UILabel *lblName;
    __weak IBOutlet UILabel *lblFollowerCount;
    __weak IBOutlet UILabel *lblFollowingCount;
    __weak IBOutlet UITableView *tblPaidUser;
    __weak IBOutlet UIActivityIndicatorView *actView;
    
    NSMutableArray *arrRowData;
}

@end
