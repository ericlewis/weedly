//
//  EELAccount.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELAccount.h"

@implementation EELAccount

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id"          : @"id",
             @"email"       : @"email",
             @"username"    : @"username",
             @"photo"       : @"avatar",
             @"session"     : @"session",
             @"activation"  : @"activation",
             };
}

+ (NSValueTransformer *)photoURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark - Managed object serialization

+ (NSString *)managedObjectEntityName {
    return @"Account";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return nil;
}

+ (NSValueTransformer *)photoURLEntityAttributeTransformer {
    return [[NSValueTransformer valueTransformerForName:MTLURLValueTransformerName] mtl_invertedTransformer];
}

@end
