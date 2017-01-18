//
//  WhoIlikedMost.h
//  InstaInSight
//
//  Created by Mukesh Verma on 18/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhoIlikedMost : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *tblWhoIlikedMost;
    __weak IBOutlet UIActivityIndicatorView *actView;
    NSMutableArray *arrMediaLikedByMe;
}


@end
