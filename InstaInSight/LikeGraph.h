//
//  LikeGraph.h
//  InstaInSight
//
//  Created by Mukesh Verma on 03/02/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"

@interface LikeGraph : GAITrackedViewController<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>
{
    __weak IBOutlet BEMSimpleLineGraphView *myGraph;
    NSMutableArray *arrayOfValues,*arrTopMedia,*arrTotalLikers;
    __weak IBOutlet UIActivityIndicatorView *actView;
}
@end
