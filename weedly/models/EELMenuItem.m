//
//  EELMenuItem.m
//  weedly
//
//  Created by Eric Lewis on 5/4/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMenuItem.h"

@implementation EELMenuItem

+ (NSDictionary*) overrideKeysForMapping {
    return @{
             @"price_half_ounce" : @"priceHalfOZ",
             @"price_ounce" : @"priceOZ",
             @"price_quarter" : @"priceQtr",
             @"menu_item_category_id" : @"catID",
             @"body" : @"strainDescription",
             @"updated_at" : @"lastUpdated"
             };
}

- (NSString*) formattedNameString {
    NSAttributedString *formattedName = [[NSAttributedString alloc] initWithData:[self.name dataUsingEncoding:NSUTF8StringEncoding]
                                                                         options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    
    return formattedName.string;
}

@end
