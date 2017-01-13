//
//  IamnotfollBack.h
//  InstaInSight
//
//  Created by Mukesh Verma on 13/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IamnotfollBack : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *tblFollowing;
    __weak IBOutlet UIActivityIndicatorView *actView;
    NSMutableArray *arrIMNotFollowingBack;
}


@end
