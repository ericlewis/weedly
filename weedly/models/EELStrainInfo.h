//
//  EELStrainInfo.h
//  weedly
//
//  Created by Eric Lewis on 8/19/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

@interface EELStrainInfo : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (copy, nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) double score;

@end
