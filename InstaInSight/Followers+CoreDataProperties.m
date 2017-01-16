//
//  Followers+CoreDataProperties.m
//  InstaInSight
//
//  Created by Verma Mukesh on 03/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Followers+CoreDataProperties.h"

@implementation Followers (CoreDataProperties)

@dynamic followerId;
@dynamic fullName;
@dynamic profilePictureURL;
@dynamic userName;
@dynamic isNew;
@dynamic hasMutualFollower;
@dynamic mutualFollowerCount;

@end
