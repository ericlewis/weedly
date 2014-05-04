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
             @"address" : @"a",
             @"city" : @"c",
             @"name" : @"n"
             };
}

#pragma mark - Managed object serialization

+ (NSString *)managedObjectEntityName {
    return @"Dispensary";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return nil;
}

+ (NSValueTransformer *)coverURLEntityAttributeTransformer {
    return [[NSValueTransformer valueTransformerForName:MTLURLValueTransformerName] mtl_invertedTransformer];
}

@end
