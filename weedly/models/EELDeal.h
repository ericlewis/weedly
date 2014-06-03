//
//  EELDeal.h
//  weedly
//
//  Created by Ryan Dignard on 6/2/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

@interface EELDeal : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, strong, readonly) NSNumber* id;
@property (nonatomic, strong, readonly) NSString* lat;
@property (nonatomic, strong, readonly) NSString* lng;
@property (nonatomic, strong, readonly) NSNumber* dispensaryId;
@property (nonatomic, strong, readonly) NSString* dispensaryName;
@property (nonatomic, strong, readonly) NSString* dispensaryCity;
@property (nonatomic, strong, readonly) NSNumber* dispensaryCatId;
@property (nonatomic, strong, readonly) NSNumber* distance;
@property (nonatomic, strong, readonly) NSString* text;
@property (nonatomic, strong, readonly) NSNumber* hits;
@property (nonatomic, strong, readonly) NSString* slug;
@property (nonatomic, strong, readonly) NSString* catSlug;

@end
