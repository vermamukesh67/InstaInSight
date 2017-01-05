//
//  Following+CoreDataProperties.h
//  InstaInSight
//
//  Created by Verma Mukesh on 03/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Following.h"

NS_ASSUME_NONNULL_BEGIN

@interface Following (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *followingId;
@property (nullable, nonatomic, retain) NSString *fullName;
@property (nullable, nonatomic, retain) NSString *isNew;
@property (nullable, nonatomic, retain) NSString *profilePictureURL;
@property (nullable, nonatomic, retain) NSString *userName;

@end

NS_ASSUME_NONNULL_END
