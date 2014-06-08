/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  A basic data source for the sightings of a particular cat. When initialised with a cat, this data source will fetch the cat sightings.
  
 */

#import "EELReviewsDataSource.h"
#import "EELWMClient.h"

#import "AAPLDispensaryReviewCell.h"

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

- (void)registerReusableViewsWithCollectionView:(UICollectionView *)collectionView
{
    [super registerReusableViewsWithCollectionView:collectionView];
    [collectionView registerClass:[AAPLDispensaryReviewCell class] forCellWithReuseIdentifier:NSStringFromClass([AAPLDispensaryReviewCell class])];
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeFittingSize:(CGSize)size forItemAtIndexPath:(NSIndexPath *)indexPath
{
    AAPLDispensaryReviewCell *cell = (AAPLDispensaryReviewCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    CGSize fittingSize = [cell aapl_preferredLayoutSizeFittingSize:size];
    [cell removeFromSuperview];
    return fittingSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AAPLDispensaryReviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AAPLDispensaryReviewCell class]) forIndexPath:indexPath];
    EELReview *review = [self itemAtIndexPath:indexPath];
    
    [cell configureWithReview:review];
    
    return cell;
}

@end
