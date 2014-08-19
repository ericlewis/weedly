//
//  EELStrainInfo.m
//  weedly
//
//  Created by 1debit on 8/19/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELStrainInfo.h"

@implementation EELStrainInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name"    : @"name",
             @"score"   : @"score",
             };
}

#pragma mark - Managed object serialization

+ (NSString *)managedObjectEntityName {
    return @"StrainInfo";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return nil;
}

@end
