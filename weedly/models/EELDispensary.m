//
//  EELDispensary.m
//  weedly
//
//  Created by 1debit on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELDispensary.h"

@implementation EELDispensary

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
             @"featured"    : @"featured",
             };
}

+ (NSValueTransformer *)photoURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark - Managed object serialization

+ (NSString *)managedObjectEntityName {
    return @"Dispensary";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return nil;
}

+ (NSValueTransformer *)photoURLEntityAttributeTransformer {
    return [[NSValueTransformer valueTransformerForName:MTLURLValueTransformerName] mtl_invertedTransformer];
}

@end
