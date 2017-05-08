//
//  OriginalFollowers+CoreDataProperties.m
//  InstaInSight
//
//  Created by Verma Mukesh on 09/05/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import "OriginalFollowers+CoreDataProperties.h"

#define kOriginalFollowers @"OriginalFollowers"

@implementation OriginalFollowers (CoreDataProperties)

+ (NSFetchRequest<OriginalFollowers *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"OriginalFollowers"];
}

@dynamic followerId;
@dynamic fullName;
@dynamic hasMutualFollower;
@dynamic hisFollowerCount;
@dynamic isNew;
@dynamic mutualFollowerCount;
@dynamic profilePictureURL;
@dynamic userName;

+ (OriginalFollowers *)saveFollowersList:(InstagramUser *)objInstaUser
{
    @try {
        NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
        
        OriginalFollowers *objUpdate=[self fetchFollowersById:objInstaUser.userId];
        
        if (objUpdate!=nil) {
            objUpdate.followerId=objInstaUser.userId;
            objUpdate.fullName=objInstaUser.fullName;
            objUpdate.profilePictureURL=[objInstaUser.profilePictureURL absoluteString];
            objUpdate.userName=objInstaUser.username;
            objUpdate.hisFollowerCount=[NSString stringWithFormat:@"%li",(long)objInstaUser.followsCount];
            
            NSError *error = nil;
            if ([context save:&error]) {
                
                NSLog(@" saved successfully");
                return objUpdate;
            } else {
                NSLog(@"Failed to save  : %@", [error userInfo]);
                return objUpdate;
            }
        }
        else{
            OriginalFollowers *objInsert = [NSEntityDescription insertNewObjectForEntityForName:kOriginalFollowers inManagedObjectContext:context];
            objInsert.followerId=objInstaUser.userId;
            objInsert.fullName=objInstaUser.fullName;
            objInsert.profilePictureURL=[objInstaUser.profilePictureURL absoluteString];
            objInsert.userName=objInstaUser.username;
            objInsert.hisFollowerCount=[NSString stringWithFormat:@"%li",(long)objInstaUser.followsCount];
            objInsert.isNew=@"1";
            
            
            NSError *error = nil;
            if ([context save:&error])
            {
                return objInsert;
            }
            else
            {
                return objInsert;
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
+ (OriginalFollowers *)fetchFollowersById:(NSString *)userId
{
    @try {
        NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
        NSEntityDescription *entity = [NSEntityDescription entityForName:kOriginalFollowers inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(followerId = %@)", userId];
        [request setPredicate:predicate];
        [request setReturnsObjectsAsFaults:NO];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        if([objects count] > 0)
            return [objects objectAtIndex:0];
        else
            return nil;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

+ (NSArray *)fetchFollowersByType:(NSString *)userType
{
    @try {
        NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
        NSEntityDescription *entity = [NSEntityDescription entityForName:kOriginalFollowers inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isNew = %@)", userType];
        [request setPredicate:predicate];
        [request setReturnsObjectsAsFaults:NO];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        return objects;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

+ (NSArray *)fetchFollowersByHasMutualFollow
{
    @try {
        NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
        NSEntityDescription *entity = [NSEntityDescription entityForName:kOriginalFollowers inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(hasMutualFollower = 1)"];
        [request setPredicate:predicate];
        [request setReturnsObjectsAsFaults:NO];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        return objects;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

+ (NSArray *)fetchFollowersDetails
{
    @try {
        NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
        NSEntityDescription *entity = [NSEntityDescription entityForName:kOriginalFollowers inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        // *** Set Predicate to Find ChatMsg with userId ***
        
        [request setReturnsObjectsAsFaults:NO];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        return objects;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

+ (void)fetchAndUpdateIsNewFlagFollowersDetails
{
    @try {
        NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
        NSEntityDescription *entity = [NSEntityDescription entityForName:kOriginalFollowers inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        // *** Set Predicate to Find ChatMsg with userId ***
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isNew = 1)"];
        [request setPredicate:predicate];
        [request setReturnsObjectsAsFaults:NO];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        [objects enumerateObjectsUsingBlock:^(OriginalFollowers   * _Nonnull objFollower, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [objFollower setIsNew:@"0"];
        }];
        
        if ([context save:&error]) {
            NSLog(@" Saved Succesfully!");
        } else {
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

+ (OriginalFollowers *)fetchAndUpdateHasFollowFlagForId:(NSString *)followerId AndCount:(NSString *)strMutualCount
{
    @try {
        NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
        NSError *error;
        OriginalFollowers *objUpdate=[self fetchFollowersById:followerId];
        if (objUpdate!=nil) {
            
            [objUpdate setMutualFollowerCount:strMutualCount];
            [objUpdate setHasMutualFollower:@"1"];
            if ([context save:&error]) {
                NSLog(@" Saved Succesfully!");
            } else {
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

+(BOOL)DeleteFollowersDetails
{
    @try {
        
        NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
        NSEntityDescription *entity = [NSEntityDescription entityForName:kOriginalFollowers inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        [request setReturnsObjectsAsFaults:NO];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        if([objects count] > 0)
        {
            [objects enumerateObjectsUsingBlock:^(OriginalFollowers *obj, NSUInteger idx, BOOL *stop) {
                [context deleteObject:obj];
            }];
        }
        
        if ([context save:&error]) {
            NSLog(@" Deleted Succesfully!");
            return YES;
        } else {
            NSLog(@" Deletion Failed : %@", [error userInfo]);
            return NO;
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
+(id)CreateDemoObjectWithoutSaving:(InstagramUser *)objInstaUser
{
    NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
    NSEntityDescription *entity = [NSEntityDescription entityForName:kOriginalFollowers inManagedObjectContext:context];
    OriginalFollowers *objInsert = (OriginalFollowers *)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    objInsert.followerId=objInstaUser.userId;
    objInsert.fullName=objInstaUser.fullName;
    objInsert.profilePictureURL=[objInstaUser.profilePictureURL absoluteString];
    objInsert.userName=objInstaUser.username;
    return objInsert;
}

@end
