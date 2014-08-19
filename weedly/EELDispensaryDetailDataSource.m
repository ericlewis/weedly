/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  The dispesary / doctor detail data source, of course. Initialised with a dispensary instance, this data source will fetch the detail information about that dispensary.
  
 */

#import "EELDispensaryDetailDataSource.h"
#import "EELDispensaryInfoListDataSource.h"
#import "EELDispensaryMoreInfoDataSource.h"
#import "AAPLDataSource+Headers.h"

@interface EELDispensaryDetailDataSource ()
@property (nonatomic, strong) EELDispensary *dispensary;
@property (nonatomic, strong) EELDispensaryInfoListDataSource *listDataSource;
@property (nonatomic, strong) EELDispensaryMoreInfoDataSource *moreinfoDataSource;
@end

@implementation EELDispensaryDetailDataSource

- (instancetype)init
{
    return [self initWithDispensary:nil];
}

- (instancetype)initWithDispensary:(EELDispensary *)dispensary
{
    self = [super init];
    if (!self)
        return nil;

    _dispensary = dispensary;
    _listDataSource = [[EELDispensaryInfoListDataSource alloc] initWithDispensary:dispensary];
    _moreinfoDataSource = [[EELDispensaryMoreInfoDataSource alloc] initWithDispensary:dispensary];
    
    [self addDataSource:_listDataSource];

    return self;
}

@end
