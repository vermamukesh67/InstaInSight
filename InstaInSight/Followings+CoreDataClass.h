//
//  Followings+CoreDataClass.h
//  InstaInSight
//
//  Created by Mukesh Verma on 23/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Followings : NSManagedObject
+ (Followings *)saveFollowingsList:(InstagramUser *)objInstaUser;
+ (Followings *)fetchFollowingsById:(NSString *)userId;
+ (Followings *)fetchFollowingsDetails;
+(BOOL)DeleteFollowingsDetails;
+(id)CreateDemoObjectWithoutSaving:(InstagramUser *)objInstaUser;
@end

NS_ASSUME_NONNULL_END

#import "Followings+CoreDataProperties.h"