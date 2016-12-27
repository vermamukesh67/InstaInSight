//
//  Followers+CoreDataProperties.m
//  InstaInSight
//
//  Created by Mukesh Verma on 27/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Followers+CoreDataProperties.h"

@implementation Followers (CoreDataProperties)

+ (NSFetchRequest<Followers *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Followers"];
}

@dynamic followerId;
@dynamic fullName;
@dynamic isNew;
@dynamic profilePictureURL;
@dynamic userName;

@end
