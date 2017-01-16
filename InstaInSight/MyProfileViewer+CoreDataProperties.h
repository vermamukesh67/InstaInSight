//
//  MyProfileViewer+CoreDataProperties.h
//  InstaInSight
//
//  Created by Verma Mukesh on 16/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MyProfileViewer.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyProfileViewer (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *followerId;
@property (nullable, nonatomic, retain) NSString *fullName;
@property (nullable, nonatomic, retain) NSString *hasMutualFollower;
@property (nullable, nonatomic, retain) NSString *mutualFollowerCount;
@property (nullable, nonatomic, retain) NSString *profilePictureURL;
@property (nullable, nonatomic, retain) NSString *userName;

@end

NS_ASSUME_NONNULL_END
