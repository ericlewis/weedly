/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  The dispesary / doctor detail data source, of course. Initialised with a dispensary instance, this data source will fetch the detail information about that dispensary.
  
 */

#import "EELDispensaryDetailDataSource.h"
#import "EELDispensaryInfoListDataSource.h"
#import "AAPLDataSource+Headers.h"

@interface EELDispensaryDetailDataSource ()
@property (nonatomic, strong) EELDispensary *dispensary;
@property (nonatomic, strong) EELDispensaryInfoListDataSource *listDataSource;
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
    
    [self addDataSource:_listDataSource];

    return self;
}

- (void)loadContent
{
    [self loadContentWithBlock:^(AAPLLoading *loading) {
        [[EELWMClient sharedClient] getDispensaryWithID:self.dispensary.id.stringValue completionBlock:^(EELDispensary *dispensary, NSError *error) {
            if (!loading.current) {
                [loading ignore];
                return;
            }
            
            if (error) {
                [loading doneWithError:error];
                return;
            }
            
            // There's always content, because this is a composed data source
            [loading updateWithContent:^(EELDispensaryDetailDataSource *me) {
                
            }];
        }];
    }];
}

@end
