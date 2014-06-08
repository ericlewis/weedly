/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  A basic data source for the sightings of a particular cat. When initialised with a cat, this data source will fetch the cat sightings.
  
 */

#import "AAPLBasicDataSource.h"

@class EELDispensary;

@interface EELReviewsDataSource : AAPLBasicDataSource

- (instancetype)initWithDispensary:(EELDispensary *)dispensary;

@end
