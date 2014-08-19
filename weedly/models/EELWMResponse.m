//
//  EELWMResponse.m
//  weedly
//
//  Created by Eric Lewis on 8/1/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELWMResponse.h"

@implementation EELWMResponse

+ (NSString *)resultKeyPathForJSONDictionary:(NSDictionary *)JSONDictionary {

    // handle the new search api's desire to nest
    if(JSONDictionary[@"_shards"] != nil){
        return @"hits.hits";
    }
    
    return @"hits";
}

@end
