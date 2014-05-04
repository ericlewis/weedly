//
//  EELReview.m
//  weedly
//
//  Created by 1debit on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELReview.h"

@implementation EELReview

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id"          : @"id",
             @"title"       : @"title",
             @"rating"      : @"r",
             @"name"        : @"name",
             @"timeAgo"     : @"when",
             @"comment"     : @"comments",
             @"photo"       : @"thumb",
             };
}

+ (NSValueTransformer *)photoURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark - Managed object serialization

+ (NSString *)managedObjectEntityName {
    return @"Review";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return nil;
}

+ (NSValueTransformer *)photoURLEntityAttributeTransformer {
    return [[NSValueTransformer valueTransformerForName:MTLURLValueTransformerName] mtl_invertedTransformer];
}

@end
