//
//  InAppPurchaseVC.h
//  InstaInSight
//
//  Created by Verma Mukesh on 12/02/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InAppPurchaseVC : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *tblPurchase;
    NSMutableArray *arrPurchased;
}
@end
