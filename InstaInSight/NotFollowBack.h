//
//  NotFollowBack.h
//  InstaInSight
//
//  Created by Mukesh Verma on 16/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotFollowBack : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *tblFollowing;
    __weak IBOutlet UIActivityIndicatorView *actView;
    NSMutableArray *arrNotFollowingBack;
}


@end
