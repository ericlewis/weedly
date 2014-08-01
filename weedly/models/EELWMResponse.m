//
//  EELWMResponse.m
//  weedly
//
//  Created by 1debit on 8/1/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELWMResponse.h"

@implementation EELWMResponse

+ (NSString *)resultKeyPathForJSONDictionary:(NSDictionary *)JSONDictionary {
    return @"hits";
}

@end
