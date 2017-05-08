//
//  OriginalFollowers+CoreDataProperties.h
//  InstaInSight
//
//  Created by Verma Mukesh on 09/05/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import "OriginalFollowers+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface OriginalFollowers (CoreDataProperties)

+ (NSFetchRequest<OriginalFollowers *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *followerId;
@property (nullable, nonatomic, copy) NSString *fullName;
@property (nullable, nonatomic, copy) NSString *hasMutualFollower;
@property (nullable, nonatomic, copy) NSString *hisFollowerCount;
@property (nullable, nonatomic, copy) NSString *isNew;
@property (nullable, nonatomic, copy) NSString *mutualFollowerCount;
@property (nullable, nonatomic, copy) NSString *profilePictureURL;
@property (nullable, nonatomic, copy) NSString *userName;

+ (OriginalFollowers *)saveFollowersList:(InstagramUser *)objInstaUser;
+ (OriginalFollowers *)fetchFollowersById:(NSString *)userId;
+ (NSArray *)fetchFollowersByType:(NSString *)userType;
+ (NSArray *)fetchFollowersDetails;
+(BOOL)DeleteFollowersDetails;
+(id)CreateDemoObjectWithoutSaving:(InstagramUser *)objInstaUser;
+ (void)fetchAndUpdateIsNewFlagFollowersDetails;
+ (OriginalFollowers *)fetchAndUpdateHasFollowFlagForId:(NSString *)followerId AndCount:(NSString *)strMutualCount;
+ (NSArray *)fetchFollowersByHasMutualFollow;

@end

NS_ASSUME_NONNULL_END
