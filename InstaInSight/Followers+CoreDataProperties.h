//
//  Followers+CoreDataProperties.h
//  InstaInSight
//
//  Created by Mukesh Verma on 23/12/16.
//  Copyright © 2016 Mukesh Verma. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Followers+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Followers (CoreDataProperties)

+ (NSFetchRequest<Followers *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *followerId;
@property (nullable, nonatomic, copy) NSString *fullName;
@property (nullable, nonatomic, copy) NSString *profilePictureURL;
@property (nullable, nonatomic, copy) NSString *userName;

@end

NS_ASSUME_NONNULL_END
