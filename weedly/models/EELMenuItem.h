//
//  EELMenuItem.h
//  weedly
//
//  Created by 1debit on 5/4/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

@interface EELMenuItem : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (copy, nonatomic, readonly) NSNumber *id;
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *strainDescription;
@property (nonatomic, readonly) int priceEighth;
@property (nonatomic, readonly) int priceGram;
@property (nonatomic, readonly) int priceHalfGram;
@property (nonatomic, readonly) int priceHalfOZ;
@property (nonatomic, readonly) int priceOZ;
@property (nonatomic, readonly) int priceQtr;
@property (nonatomic, readonly) int priceUnit;

@property (nonatomic, readonly) int catID;
@property (nonatomic, readonly) BOOL tested;
@property (nonatomic, readonly) BOOL published;

@end
