//
//  EELMenu.m
//  weedly
//
//  Created by 1debit on 5/5/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMenu.h"

#define kAPIDateFormat @"yyyy-MM-dd'T'HH:mm:ssz"

@implementation EELMenu

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id"                : @"id",
             @"lastUpdated"       : @"menu_updated_at",
             };
}

+ (NSValueTransformer *)lastUpdatedJSONTransformer{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kAPIDateFormat];
    
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [dateFormatter stringFromDate:date];
    }];
}

#pragma mark - Managed object serialization


+ (NSString *)managedObjectEntityName {
    return @"Menu";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return nil;
}

@end
