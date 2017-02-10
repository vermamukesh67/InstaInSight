//
//  UserCell.h
//  InstaInSight
//
//  Created by Verma Mukesh on 19/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowUnfollowButton.h"

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet FollowUnfollowButton *btnFollowUnfollow;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actView;
@property(nonatomic,strong) NSString *strUserId;
@property(nonatomic,assign) BOOL followStatus;
-(void)CheckForFollowUnFollow:(NSString *)strUserId;
@end
