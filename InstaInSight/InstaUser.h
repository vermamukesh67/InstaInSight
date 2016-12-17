//
//  InstaUser.h
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstaUser : NSObject

+ (instancetype _Nonnull)sharedUserInstance;
@property (nonatomic,strong) InstagramUser * _Nonnull objInstaUser;

@end
