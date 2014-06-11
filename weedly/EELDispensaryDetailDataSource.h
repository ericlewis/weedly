/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
 The dispesary / doctor detail data source, of course. Initialised with a dispensary instance, this data source will fetch the detail information about that dispensary.
 
 */

#import "AAPLComposedDataSource.h"

@class EELDispensary;

@interface EELDispensaryDetailDataSource : AAPLComposedDataSource

- (instancetype)initWithDispensary:(EELDispensary *)dispensary;

@end
