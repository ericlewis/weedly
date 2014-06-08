/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  A subclass of AAPLCollectionViewCell that displays an AAPLCatSighting instance.
  
 */

#import "AAPLCollectionViewCell.h"

@class EELReview;

@interface AAPLCatSightingCell : AAPLCollectionViewCell

- (void)configureWithReview:(EELReview *)review;

@end
