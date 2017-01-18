//
//  GhostFollowers.h
//  InstaInSight
//
//  Created by Verma Mukesh on 18/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GhostFollowers : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *tblGhostFollowers;
    __weak IBOutlet UIActivityIndicatorView *actView;
    NSMutableArray *arrTopLikers,*arrTopMedia,*arrTotalLikers,*arrFollowers;
}


@end
