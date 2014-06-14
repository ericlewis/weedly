//
//  EELReview.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELReview.h"

@implementation EELReview

+ (NSDictionary*) overrideKeysForMapping {
    return @{
             @"r" : @"rating",
             @"when" : @"timeAgo",
             @"thumb" : @"photo",
             @"comments" : @"comment"
             };
}


@end
