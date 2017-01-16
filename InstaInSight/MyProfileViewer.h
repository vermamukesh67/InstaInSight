//
//  MyProfileViewer.h
//  InstaInSight
//
//  Created by Verma Mukesh on 16/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyProfileViewer : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+ (MyProfileViewer *)saveMyProfileViewerList:(InstagramUser *)objInstaUser;
+ (MyProfileViewer *)fetchMyProfileViewerById:(NSString *)userId;
+ (NSArray *)fetchMyProfileViewerByType:(NSString *)userType;
+ (NSArray *)fetchMyProfileViewerDetails;
+(BOOL)DeleteMyProfileViewerDetails;
+(id)CreateDemoObjectWithoutSaving:(InstagramUser *)objInstaUser;
+ (void)fetchAndUpdateIsNewFlagMyProfileViewerDetails;
+ (void)fetchAndUpdateHasFollowFlagForId:(NSString *)followerId AndCount:(NSString *)strMutualCount;
+ (NSArray *)fetchMyProfileViewerByHasMutualFollow;

@end

NS_ASSUME_NONNULL_END

#import "MyProfileViewer+CoreDataProperties.h"
