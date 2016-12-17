//
//  InstaUser.m
//  InstaInSight
//
//  Created by Verma Mukesh on 17/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//

#import "InstaUser.h"

@implementation InstaUser
+ (instancetype _Nonnull)sharedUserInstance {
    static InstaUser *_sharedUser = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedUser = [[InstaUser alloc] init];
    });
    return _sharedUser;
}

@end
