//
//  ProfileViewer.h
//  InstaInSight
//
//  Created by Mukesh Verma on 16/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewer : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *tblProfile;
    __weak IBOutlet UIActivityIndicatorView *actView;
    NSMutableArray *arrProfileViewer,*arrRandomFollower,*arrAllFollowers;
    NSMutableDictionary *diccRandomFollowers;
}


@end
