//
//  EELDoctor.m
//  weedly
//
//  Created by 1debit on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELDoctor.h"

@implementation EELDoctor

#pragma mark - JSON serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id"          : @"id",
             @"name"        : @"n",
             @"address"     : @"a",
             @"city"        : @"c",
             @"state"       : @"state",
             @"zip"         : @"zip",
             @"rating"      : @"r",
             @"ratingCount" : @"rc",
             @"type"        : @"type",
             @"icon"        : @"marker",
             @"lng"         : @"longitude",
             @"lat"         : @"latitude",
             @"photoURL"    : @"photo1",
             @"phone"       : @"phone",
             @"license"     : @"license_type",
             @"closesAt"    : @"todaysHours.closes_at",
             @"opensAt"     : @"todaysHours.opens_at",
             @"dayOTW"      : @"todaysHours.day_of_the_week",
             @"isOpen"      : @"is_open",
             };
}

+ (NSValueTransformer *)photoURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark - Managed object serialization

+ (NSString *)managedObjectEntityName {
    return @"Doctor";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return nil;
}

+ (NSValueTransformer *)coverURLEntityAttributeTransformer {
    return [[NSValueTransformer valueTransformerForName:MTLURLValueTransformerName] mtl_invertedTransformer];
}

@end
