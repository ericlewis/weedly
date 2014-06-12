/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
 A basic data source for the reviews of a particular dispensary / doctor. When initialised with a dispensary / doctor, this data source will fetch the dispensary / doctor reviews.
 
 */

#import "EELReviewsDataSource.h"

#import "EELReviewCell.h"

#import "UICollectionView+Helpers.h"

@interface EELReviewsDataSource ()
@property (nonatomic, strong) EELDispensary *dispensary;
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
    self.defaultMetrics.rowHeight = AAPLRowHeightVariable;

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
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([EELReviewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([EELReviewCell class])];
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeFittingSize:(CGSize)size forItemAtIndexPath:(NSIndexPath *)indexPath
{
    EELReviewCell *cell = (EELReviewCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    CGSize fittingSize = [cell aapl_preferredLayoutSizeFittingSize:size];
    [cell removeFromSuperview];
    return fittingSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EELReviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EELReviewCell class]) forIndexPath:indexPath];
    EELReview *review = [self itemAtIndexPath:indexPath];
    
    [cell configureWithReview:review];
    
    return cell;
}

@end
