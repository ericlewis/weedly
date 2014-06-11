/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  A basic data source for the reviews of a particular dispensary / doctor. When initialised with a dispensary / doctor, this data source will fetch the dispensary / doctor reviews.
  
 */

#import "AAPLBasicDataSource.h"

@class EELDispensary;

@interface EELReviewsDataSource : AAPLBasicDataSource

- (instancetype)initWithDispensary:(EELDispensary *)dispensary;

@end
