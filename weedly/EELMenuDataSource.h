//
//  EELMenuDataSource.h
//  weedly
//
//  Created by Eric LEwis on 6/11/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "AAPLComposedDataSource.h"

@class EELDispensary;

@interface EELMenuDataSource : AAPLComposedDataSource

- (instancetype)initWithDispensary:(EELDispensary *)dispensary;

@end
