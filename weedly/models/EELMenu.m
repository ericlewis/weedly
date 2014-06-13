//
//  EELMenu.m
//  weedly
//
//  Created by Eric Lewis on 5/5/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMenu.h"

@implementation EELMenu

+ (NSDictionary*) overrideKeysForMapping {
    return @{
             @"menu_updated_at" : @"lastUpdated"
             };
}

@end
