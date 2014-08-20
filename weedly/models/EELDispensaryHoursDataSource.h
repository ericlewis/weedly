//
//  EELDispensaryHoursDataSource.h
//  weedly
//
//  Created by 1debit on 8/20/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "AAPLBasicDataSource.h"

@interface EELDispensaryHoursDataSource : AAPLBasicDataSource
- (instancetype)initWithDispensary:(EELDispensary *)dispensary;
@end
