//
//  EELSmokinOn.m
//  weedly
//
//  Created by 1debit on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELSmokinOn.h"

@implementation EELSmokinOn

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id"          : @"id",
             @"name"        : @"u",
             @"status"      : @"s",
             @"timeAgo"     : @"c",
             @"photo"       : @"photo_url",
             };
}

+ (NSValueTransformer *)photoURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark - Managed object serialization

+ (NSString *)managedObjectEntityName {
    return @"SmokinOn";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return nil;
}

+ (NSValueTransformer *)photoURLEntityAttributeTransformer {
    return [[NSValueTransformer valueTransformerForName:MTLURLValueTransformerName] mtl_invertedTransformer];
}

@end
