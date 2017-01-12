//
//  NewFollowerVC.h
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewFollowerVC : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *tblFollowers;
    __weak IBOutlet UIActivityIndicatorView *actView;
    NSMutableArray *arrFollowers;
}
@end
