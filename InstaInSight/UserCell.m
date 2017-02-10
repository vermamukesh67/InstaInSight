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
    
    [self.btnFollowUnfollow addTarget:self action:@selector(btnFollowUnfollowTapped:) forControlEvents:UIControlEventTouchUpInside];
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
    [self CheckStatus];
}

-(void)CheckStatus
{
    [[InstagramEngine sharedEngine] getRelationshipStatusOfUser:self.strUserId withSuccess:^(NSDictionary * _Nonnull serverResponse) {
        
        if (serverResponse && [serverResponse objectForKey:@"outgoing_status"]) {
            [_actView stopAnimating];
            [self.btnFollowUnfollow setHidden:NO];
            [self.btnFollowUnfollow setUserInteractionEnabled:YES];
            self.followStatus=([[serverResponse objectForKey:@"outgoing_status"] isEqualToString:@"follows"]?YES:NO);
            [_btnFollowUnfollow setImage:[UIImage imageNamed:([[serverResponse objectForKey:@"outgoing_status"] isEqualToString:@"follows"]) ?@"unfollow":@"follow"] forState:UIControlStateNormal];
        }
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        [_actView stopAnimating];
    }];
}

-(void)btnFollowUnfollowTapped:(FollowUnfollowButton *)FollowUnfollowButton
{
    [_actView startAnimating];
     [self.btnFollowUnfollow setHidden:YES];
    if (self.followStatus) {
        
        [[InstagramEngine sharedEngine] unfollowUser:self.strUserId withSuccess:^(NSDictionary * _Nonnull serverResponse) {
            
            NSLog(@"count = %li",[APP_DELEGATE followunfollowCount]);
            NSInteger count=[APP_DELEGATE followunfollowCount]+1;
            [APP_DELEGATE setFollowunfollowCount:count];
            [self CheckStatus];
            
            if (count!=0 && count%2==0) {
                [APP_DELEGATE PrepareAdv];
            }
            
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            [self CheckStatus];
        }];
    }
    else
    {
        [[InstagramEngine sharedEngine] followUser:self.strUserId withSuccess:^(NSDictionary * _Nonnull serverResponse) {
           
            NSLog(@"count = %li",[APP_DELEGATE followunfollowCount]);
            NSInteger count=[APP_DELEGATE followunfollowCount]+1;
            [APP_DELEGATE setFollowunfollowCount:count];
           [self CheckStatus];
            if (count!=0 && count%2==0) {
                [APP_DELEGATE PrepareAdv];
            }
            
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            [self CheckStatus];
        }];
    }
    
  
}

@end
