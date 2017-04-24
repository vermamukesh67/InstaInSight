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
    __weak IBOutlet UIButton *btnLogout;
    
    NSMutableArray *arrRowData,*arrPaidData;
    BOOL isFreeSelected;
    __weak IBOutlet UIButton *btnBuy;
    NSMutableArray *arrFollowers,*arrFollowing,*arrIMNotFollowingBack,*arrNotFollowingBack;
}
- (IBAction)btnFreeTapped:(id)sender;
- (IBAction)btnProTapped:(id)sender;
- (IBAction)btnBuyTapped:(id)sender;
- (IBAction)btnLogoutTapped:(id)sender;
@end
