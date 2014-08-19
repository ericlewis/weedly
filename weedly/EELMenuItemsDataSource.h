//
//  EELMenuItemsDataSource.h
//  weedly
//
//  Created by Eric Lewis on 6/11/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "AAPLBasicDataSource.h"

@class EELDispensary;

@interface EELMenuItemsDataSource : AAPLBasicDataSource
@property (nonatomic, strong) EELDispensary *dispensary;

- (instancetype)initWithDispensary:(EELDispensary *)dispensary;

@end
