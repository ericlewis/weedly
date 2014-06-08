/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  The cat detail data source, of course. Initialised with a cat instance, this data source will fetch the detail information about that cat.
  
 */

#import "AAPLComposedDataSource.h"

@class EELDispensary;

@interface EELDispensaryDetailDataSource : AAPLComposedDataSource

- (instancetype)initWithDispensary:(EELDispensary *)dispensary;

@end
