//
//  UserCell.m
//  InstaInSight
//
//  Created by Verma Mukesh on 19/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.imgProfile setClipsToBounds:YES];
    [[self.imgProfile layer] setCornerRadius:20];
    [self.btnFollowUnfollow setUserInteractionEnabled:NO];
    [self.btnFollowUnfollow setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)CheckForFollowUnFollow:(NSString *)strUserId
{
    if ([strUserId isEqualToString:[[[InstaUser sharedUserInstance] objInstaUser] userId]]) {
        [_actView stopAnimating];
        return;
    }
    if (self.strUserId) {
        self.strUserId=strUserId;
        return;
    }
    self.strUserId=strUserId;
    [_actView startAnimating];
    [[InstagramEngine sharedEngine] getRelationshipStatusOfUser:strUserId withSuccess:^(NSDictionary * _Nonnull serverResponse) {
        if (serverResponse && [serverResponse objectForKey:@"outgoing_status"]) {
            [_actView stopAnimating];
            [self.btnFollowUnfollow setHidden:NO];
            [_btnFollowUnfollow setImage:[UIImage imageNamed:([[serverResponse objectForKey:@"outgoing_status"] isEqualToString:@"follows"]) ?@"unfollow":@"follow"] forState:UIControlStateNormal];
            
        }
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
    }];
}

@end
