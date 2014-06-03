//
//  EELDeal.h
//  weedly
//
//  Created by Ryan Dignard on 6/2/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

@interface EELDeal : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, assign, readonly) uint32_t id;
@property (nonatomic, strong, readonly) NSString* lat;
@property (nonatomic, strong, readonly) NSString* lng;
@property (nonatomic, assign, readonly) uint32_t dispensary_id;
@property (nonatomic, strong, readonly) NSString* dispensary_name;
@property (nonatomic, strong, readonly) NSString* dispensary_city;
@property (nonatomic, assign, readonly) uint32_t dispensary_catid;
@property (nonatomic, assign, readonly) double distance;
@property (nonatomic, strong, readonly) NSString* text;
@property (nonatomic, assign, readonly) uint32_t hits;
@property (nonatomic, strong, readonly) NSString* slug;
@property (nonatomic, strong, readonly) NSString* cat_slug;

@end
