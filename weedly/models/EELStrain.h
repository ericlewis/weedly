//
//  EELStrain.h
//  weedly
//
//  Created by Eric Lewis on 8/19/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELStrainInfo.h"

@interface EELStrain : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (copy, nonatomic, readonly) NSNumber *id;
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *slug;
@property (copy, nonatomic, readonly) NSString *description;
@property (copy, nonatomic, readonly) NSString *descriptionPlain;
@property (copy, nonatomic, readonly) NSString *symbol;
@property (copy, nonatomic, readonly) NSString *category;
@property (copy, nonatomic, readonly) NSString *aka;
@property (copy, nonatomic, readonly) NSArray  *flavors;
@property (copy, nonatomic, readonly) NSArray  *effects;
@property (copy, nonatomic, readonly) NSArray  *symptoms;
@property (copy, nonatomic, readonly) NSArray  *conditions;
@property (copy, nonatomic, readonly) NSArray  *negatives;

@property (nonatomic, readonly) double rating;
@property (nonatomic, readonly) int ratingCount;

@end
