//
//  OriginalFollowings+CoreDataProperties.m
//  InstaInSight
//
//  Created by Verma Mukesh on 09/05/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import "OriginalFollowings+CoreDataProperties.h"

#define kOriginalFollowings @"OriginalFollowings"

@implementation OriginalFollowings (CoreDataProperties)

+ (NSFetchRequest<OriginalFollowings *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"OriginalFollowings"];
}

@dynamic followingId;
@dynamic fullName;
@dynamic isNew;
@dynamic isUnfollowedByMe;
@dynamic profilePictureURL;
@dynamic userName;


+ (OriginalFollowings *)saveFollowingsList:(InstagramUser *)objInstaUser
{
    @try {
        NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
        
        OriginalFollowings *objUpdate=[self fetchFollowingsById:objInstaUser.userId];
        
        if (objUpdate!=nil) {
            objUpdate.followingId=objInstaUser.userId;
            objUpdate.fullName=objInstaUser.fullName;
            objUpdate.profilePictureURL=[objInstaUser.profilePictureURL absoluteString];
            objUpdate.userName=objInstaUser.username;
            //objUpdate.isNew=@"0";
            
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
            OriginalFollowings *objInsert = [NSEntityDescription insertNewObjectForEntityForName:kOriginalFollowings inManagedObjectContext:context];
            objInsert.followingId=objInstaUser.userId;
            objInsert.fullName=objInstaUser.fullName;
            objInsert.profilePictureURL=[objInstaUser.profilePictureURL absoluteString];
            objInsert.userName=objInstaUser.username;
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
+ (OriginalFollowings *)fetchFollowingsById:(NSString *)userId
{
    @try {
        NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
        NSEntityDescription *entity = [NSEntityDescription entityForName:kOriginalFollowings inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(followingId = %@)", userId];
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

+ (NSArray *)fetchFollowingsByType:(NSString *)userType
{
    @try {
        NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
        NSEntityDescription *entity = [NSEntityDescription entityForName:kOriginalFollowings inManagedObjectContext:context];
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

+ (NSArray *)fetchIsUnfollowedByMeByType:(NSString *)isUnfollowedByMe
{
    @try {
        NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
        NSEntityDescription *entity = [NSEntityDescription entityForName:kOriginalFollowings inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isUnfollowedByMe = %@)", isUnfollowedByMe];
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


+ (NSArray *)fetchFollowingsDetails
{
    @try {
        NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
        NSEntityDescription *entity = [NSEntityDescription entityForName:kOriginalFollowings inManagedObjectContext:context];
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

+ (void)fetchAndUpdateIsNewFlagFollowingsDetails
{
    @try {
        NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
        NSEntityDescription *entity = [NSEntityDescription entityForName:kOriginalFollowings inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isNew = 1)"];
        [request setPredicate:predicate];
        [request setReturnsObjectsAsFaults:NO];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        [objects enumerateObjectsUsingBlock:^(OriginalFollowings   * _Nonnull objFollowing, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [objFollowing setIsNew:@"0"];
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

+(BOOL)DeleteFollowingsDetails
{
    @try {
        
        NSManagedObjectContext *context = MANAGED_OBJECT_CONTEXT;
        NSEntityDescription *entity = [NSEntityDescription entityForName:kOriginalFollowings inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        [request setReturnsObjectsAsFaults:NO];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        if([objects count] > 0)
        {
            [objects enumerateObjectsUsingBlock:^(OriginalFollowings *obj, NSUInteger idx, BOOL *stop) {
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:kOriginalFollowings inManagedObjectContext:context];
    OriginalFollowings *objInsert = (OriginalFollowings *)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    objInsert.followingId=objInstaUser.userId;
    objInsert.fullName=objInstaUser.fullName;
    objInsert.profilePictureURL=[objInstaUser.profilePictureURL absoluteString];
    objInsert.userName=objInstaUser.username;
    return objInsert;
}


@end
