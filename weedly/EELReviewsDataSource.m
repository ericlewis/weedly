/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  A basic data source for the sightings of a particular cat. When initialised with a cat, this data source will fetch the cat sightings.
  
 */

#import "EELReviewsDataSource.h"
#import "EELWMClient.h"

#import "UICollectionView+Helpers.h"

@interface EELReviewsDataSource ()
@property (nonatomic, strong) EELDispensary *dispensary;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation EELReviewsDataSource

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
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateStyle = NSDateFormatterShortStyle;
    _dateFormatter.timeStyle = NSDateFormatterShortStyle;
    return self;
}

- (void)loadContent
{
    [self loadContentWithBlock:^(AAPLLoading *loading) {
        [[EELWMClient sharedClient] getReviewsWithDispensaryID:self.dispensary.id.stringValue completionBlock:^(NSArray *reviews, NSError *error) {
            if (!loading.current) {
                [loading ignore];
                return;
            }
            
            if (error) {
                [loading doneWithError:error];
                return;
            }
            
            [loading updateWithContent:^(EELReviewsDataSource *me){
                me.items = reviews;
            }];
        }];
    }];
}

@end
