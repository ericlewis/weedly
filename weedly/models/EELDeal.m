//
//  EELDeal.m
//  weedly
//
//  Created by Ryan Dignard on 6/2/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELDeal.h"

@interface EELDeal ()

@property (nonatomic, strong) NSNumber* id;
@property (nonatomic, strong) NSString* lat;
@property (nonatomic, strong) NSString* lng;
@property (nonatomic, strong) NSNumber* dispensaryId;
@property (nonatomic, strong) NSString* dispensaryName;
@property (nonatomic, strong) NSString* dispensaryCity;
@property (nonatomic, strong) NSNumber* dispensaryCatId;
@property (nonatomic, strong) NSNumber* distance;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSNumber* hits;
@property (nonatomic, strong) NSString* slug;
@property (nonatomic, strong) NSString* catSlug;

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
                           @"dispensaryId" : @"dispensary_id",
                           @"dispensaryName" : @"dispensary_name",
                           @"dispensaryCity" : @"dispensary_city",
                           @"dispensaryCatId" : @"dispensary_catid",
                           @"distance" : @"distance",
                           @"text" : @"text",
                           @"hits" : @"hits",
                           @"slug" : @"slug",
                           @"catSlug" : @"cat_slug"
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
