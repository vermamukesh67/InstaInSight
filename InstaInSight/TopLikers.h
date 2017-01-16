//
//  TopLikers.h
//  InstaInSight
//
//  Created by Verma Mukesh on 16/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopLikers : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *tblLikers;
    __weak IBOutlet UIActivityIndicatorView *actView;
    NSMutableArray *arrTopLikers,*arrTopMedia,*arrTotalLikers;
}


@end
