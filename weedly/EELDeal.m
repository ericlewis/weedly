//
//  EELDeal.m
//  weedly
//
//  Created by Ryan Dignard on 6/2/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELDeal.h"

@interface EELDeal ()

@property (nonatomic, assign) uint32_t id;
@property (nonatomic, strong) NSString* lat;
@property (nonatomic, strong) NSString* lng;
@property (nonatomic, assign) uint32_t dispensary_id;
@property (nonatomic, strong) NSString* dispensary_name;
@property (nonatomic, strong) NSString* dispensary_city;
@property (nonatomic, assign) uint32_t dispensary_catid;
@property (nonatomic, assign) double distance;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, assign) uint32_t hits;
@property (nonatomic, strong) NSString* slug;
@property (nonatomic, strong) NSString* cat_slug;

@end

@implementation EELDeal

static NSDictionary* _sDealsMapping;
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sDealsMapping = @{
                           @"id" : @"id",
                           @"lat" : @"lat",
                           @"lng" : @"lng",
                           @"dispensary_id" : @"dispensary_id",
                           @"dispensary_name" : @"dispensary_name",
                           @"dispensary_city" : @"dispensary_city",
                           @"dispensary_catid" : @"dispensary_catid",
                           @"distance" : @"distance",
                           @"text" : @"text",
                           @"hits" : @"hits",
                           @"slug" : @"slug",
                           @"cat_slug" : @"cat_slug"
        };
    });
    return _sDealsMapping;
}

+ (NSString*) managedObjectEntityName {
    return NSStringFromClass([self class]);
}

+ (NSDictionary*) managedObjectKeysByPropertyKey {
    return nil;
}

@end
