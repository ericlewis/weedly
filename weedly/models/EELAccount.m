//
//  EELAccount.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELAccount.h"

@implementation EELAccount

+ (NSDictionary*) overrideKeysForMapping {
    return @{
             @"photo"       : @"avatar"
             };
}

@end
