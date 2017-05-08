//
//  OriginalFollowings+CoreDataProperties.h
//  InstaInSight
//
//  Created by Verma Mukesh on 09/05/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import "OriginalFollowings+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface OriginalFollowings (CoreDataProperties)

+ (NSFetchRequest<OriginalFollowings *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *followingId;
@property (nullable, nonatomic, copy) NSString *fullName;
@property (nullable, nonatomic, copy) NSString *isNew;
@property (nullable, nonatomic, copy) NSString *isUnfollowedByMe;
@property (nullable, nonatomic, copy) NSString *profilePictureURL;
@property (nullable, nonatomic, copy) NSString *userName;

+ (OriginalFollowings *)saveFollowingsList:(InstagramUser *)objInstaUser;
+ (OriginalFollowings *)fetchFollowingsById:(NSString *)userId;
+ (NSArray *)fetchFollowingsByType:(NSString *)userType;
+ (NSArray *)fetchFollowingsDetails;
+(BOOL)DeleteFollowingsDetails;
+(id)CreateDemoObjectWithoutSaving:(InstagramUser *)objInstaUser;
+ (void)fetchAndUpdateIsNewFlagFollowingsDetails;
+ (NSArray *)fetchIsUnfollowedByMeByType:(NSString *)isUnfollowedByMe;

@end

NS_ASSUME_NONNULL_END
