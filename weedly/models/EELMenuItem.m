//
//  EELMenuItem.m
//  weedly
//
//  Created by Eric Lewis on 5/4/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMenuItem.h"

#define kAPIDateFormat @"yyyy-MM-dd'T'HH:mm:ssz"

@implementation EELMenuItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id"                : @"id",
             @"name"              : @"name",

             @"priceEighth"       : @"price_eighth",
             @"priceGram"         : @"price_gram",
             @"priceHalfGram"     : @"price_half_gram",
             @"priceHalfOZ"       : @"price_half_ounce",
             @"priceOZ"           : @"price_ounce",
             @"priceQtr"          : @"price_quarter",
             @"priceUnit"         : @"price_unit",
             
             @"tested"            : @"tested",
             @"catID"             : @"menu_item_category_id",
             @"strainDescription" : @"body",
             @"published"         : @"published",
             
             @"lastUpdated"       : @"updated_at",
             };
}

- (NSString*)formattedNameString{
    NSAttributedString *formattedName = [[NSAttributedString alloc] initWithData:[self.name dataUsingEncoding:NSUTF8StringEncoding]
                                                                         options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    
    return formattedName.string;
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
    return @"MenuItem";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return nil;
}

@end
