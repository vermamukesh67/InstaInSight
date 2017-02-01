//
//  PopularFollower.h
//  InstaInSight
//
//  Created by Verma Mukesh on 01/02/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopularFollower : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *tblPopularsFollowers;
    __weak IBOutlet UIActivityIndicatorView *actView;
    NSMutableArray *arrPopularFollowers;
}


@end
