//
//  Followings+CoreDataProperties.m
//  InstaInSight
//
//  Created by Mukesh Verma on 27/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Followings+CoreDataProperties.h"

@implementation Followings (CoreDataProperties)

+ (NSFetchRequest<Followings *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Followings"];
}

@dynamic followingId;
@dynamic fullName;
@dynamic isNew;
@dynamic profilePictureURL;
@dynamic userName;

@end
