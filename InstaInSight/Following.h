//
//  Following.h
//  InstaInSight
//
//  Created by Verma Mukesh on 03/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Following : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+ (Following *)saveFollowingsList:(InstagramUser *)objInstaUser;
+ (Following *)fetchFollowingsById:(NSString *)userId;
+ (NSArray *)fetchFollowingsByType:(NSString *)userType;
+ (NSArray *)fetchFollowingsDetails;
+(BOOL)DeleteFollowingsDetails;
+(id)CreateDemoObjectWithoutSaving:(InstagramUser *)objInstaUser;
+ (void)fetchAndUpdateIsNewFlagFollowingsDetails;
+ (NSArray *)fetchIsUnfollowedByMeByType:(NSString *)isUnfollowedByMe;
@end

NS_ASSUME_NONNULL_END

#import "Following+CoreDataProperties.h"
