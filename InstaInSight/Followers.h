//
//  Followers.h
//  InstaInSight
//
//  Created by Verma Mukesh on 03/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Followers : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+ (Followers *)saveFollowersList:(InstagramUser *)objInstaUser;
+ (Followers *)fetchFollowersById:(NSString *)userId;
+ (Followers *)fetchFollowersByType:(NSString *)userType;
+ (Followers *)fetchFollowersDetails;
+(BOOL)DeleteFollowersDetails;
+(id)CreateDemoObjectWithoutSaving:(InstagramUser *)objInstaUser;

@end

NS_ASSUME_NONNULL_END

#import "Followers+CoreDataProperties.h"
