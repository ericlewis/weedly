//
//  EELMenuItem.m
//  weedly
//
//  Created by 1debit on 5/4/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMenuItem.h"

@implementation EELMenuItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id"             : @"id",
             @"name"           : @"name",
             @"tested"         : @"tested",
             @"cbd"            : @"cbd",
             @"cbn"            : @"cbn",
             @"thc"            : @"thc",
             @"catID"          : @"menu_item_category_id",
             @"description"    : @"body",
             @"priceEighth"    : @"price_eighth",
             @"priceGram"      : @"price_gram",
             @"priceHalfGram"  : @"price_half_gram",
             @"priceHalfOZ"    : @"price_half_ounce",
             @"priceOZ"        : @"price_ounce",
             @"priceQtr"       : @"price_quarter",
             @"priceUnit"      : @"price_unit",
             @"published"      : @"published",
             @"lastUpdated"    : @"updated_at",
             };
}

#pragma mark - Managed object serialization

+ (NSString *)managedObjectEntityName {
    return @"MenuItem";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return nil;
}

@end
