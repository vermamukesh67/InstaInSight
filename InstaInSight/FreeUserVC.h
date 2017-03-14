//
//  FreeUserVC.h
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeUserVC : GAITrackedViewController<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UIView *headerView;
    __weak IBOutlet UIView *whiteBox;
    __weak IBOutlet UIImageView *imgProfileView;
    __weak IBOutlet UILabel *lblName;
    __weak IBOutlet UILabel *lblFollowerCount;
    __weak IBOutlet UILabel *lblFollowingCount;
     UITableView *tblFreeUser;
    __weak IBOutlet UIActivityIndicatorView *actView;
    __weak IBOutlet UIButton *btnFree;
    __weak IBOutlet UIButton *btnPro;
     UITableView *tblPaid;
    __weak IBOutlet UIScrollView *scrContainer;
    
    NSMutableArray *arrRowData,*arrPaidData;
    BOOL isFreeSelected;
    __weak IBOutlet UIButton *btnBuy;
}
- (IBAction)btnFreeTapped:(id)sender;
- (IBAction)btnProTapped:(id)sender;
- (IBAction)btnBuyTapped:(id)sender;
@end
