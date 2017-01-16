//
//  NSArray+Extra.m
//  InstaInSight
//
//  Created by Mukesh Verma on 16/01/17.
//  Copyright © 2017 Mukesh Verma. All rights reserved.
//

#import "NSArray+Extra.h"

@implementation NSArray (Extra)
- (NSArray *)randomSelectionWithCount:(NSUInteger)count {
    if ([self count] < count) {
        return self;
    } else if ([self count] == count) {
        return self;
    }
    
    NSMutableSet* selection = [[NSMutableSet alloc] init];
    
    while ([selection count] < count) {
        id randomObject = [self objectAtIndex: arc4random() % [self count]];
        [selection addObject:randomObject];
    }
    
    return [selection allObjects];
}
@end
