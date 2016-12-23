//
//  Followers+CoreDataClass.h
//  InstaInSight
//
//  Created by Mukesh Verma on 23/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Followers : NSManagedObject

+ (Followers *)saveFollowersList:(NSMutableDictionary *)dataDict;
+ (Followers *)fetchFollowersById:(NSString *)userId;
+ (Followers *)fetchFollowersDetails;
+(BOOL)DeleteFollowersDetails;
+(id)CreateDemoObjectWithoutSaving:(NSMutableDictionary *)dataDict;

@end

NS_ASSUME_NONNULL_END

#import "Followers+CoreDataProperties.h"
