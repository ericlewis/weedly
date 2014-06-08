/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  The cat detail data source, of course. Initialised with a cat instance, this data source will fetch the detail information about that cat.
  
 */

#import "EELDispensaryDetailDataSource.h"
#import "AAPLKeyValueDataSource.h"
#import "AAPLTextValueDataSource.h"
#import "AAPLDataSource+Headers.h"

#import "EELWMClient.h"

@interface EELDispensaryDetailDataSource ()
@property (nonatomic, strong) EELDispensary *dispensary;
@property (nonatomic, strong) AAPLKeyValueDataSource *classificationDataSource;
@property (nonatomic, strong) AAPLTextValueDataSource *descriptionDataSource;
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

    return self;
}

- (void)updateChildDataSources
{
    
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
                [me updateChildDataSources];
            }];
        }];
    }];
}

@end
