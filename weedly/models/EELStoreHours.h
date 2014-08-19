//
//  EELStoreHours.h
//  weedly
//
//  Created by Eric Lewis on 8/1/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "MTLModel.h"

@interface EELStoreHours : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (copy, nonatomic, readonly) NSNumber *id;
@property (copy, nonatomic, readonly) NSNumber *dayOrder;
@property (copy, nonatomic, readonly) NSString *opensAt;
@property (copy, nonatomic, readonly) NSString *closesAt;
@property (copy, nonatomic, readonly) NSString *dayOTW;

@end
