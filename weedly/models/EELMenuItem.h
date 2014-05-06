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
@property (copy, nonatomic, readonly) NSString *priceEighth;
@property (copy, nonatomic, readonly) NSString *priceGram;
@property (copy, nonatomic, readonly) NSString *priceHalfGram;
@property (copy, nonatomic, readonly) NSString *priceHalfOZ;
@property (copy, nonatomic, readonly) NSString *priceOZ;
@property (copy, nonatomic, readonly) NSString *priceQtr;
@property (copy, nonatomic, readonly) NSString *priceUnit;

@property (nonatomic, readonly) int catID;
@property (nonatomic, readonly) BOOL tested;
@property (nonatomic, readonly) BOOL published;

@end
