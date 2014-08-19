//
//  EELStoreHours.m
//  weedly
//
//  Created by Eric Lewis on 8/1/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELStoreHours.h"

@implementation EELStoreHours

#pragma mark - JSON serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id"          : @"id",
             @"dayOrder"    : @"day_order",
             @"opensAt"     : @"opening_time",
             @"closesAt"    : @"closing_time",
             @"dayOTW"      : @"day_of_the_week"
             };
}

#pragma mark - Managed object serialization

+ (NSString *)managedObjectEntityName {
    return @"Hours";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{};
}

@end
