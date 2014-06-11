/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  A basic data source that either fetches the list info cell options available
  
 */

#import "AAPLBasicDataSource.h"

@interface EELDispensaryInfoListDataSource : AAPLBasicDataSource
- (instancetype)initWithDispensary:(EELDispensary *)dispensary;
@end
