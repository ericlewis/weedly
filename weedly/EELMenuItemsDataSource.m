//
//  EELMenuItemsDataSource.m
//  weedly
//
//  Created by Eric Lewis on 6/11/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMenuItemsDataSource.h"
#import "EELMenuItemCell.h"
#import "UICollectionView+Helpers.h"

@implementation EELMenuItemsDataSource

- (instancetype)initWithDispensary:(EELDispensary *)dispensary
{
    self = [super init];
    if (!self)
        return nil;
    
    _dispensary = dispensary;
    
    return self;
}

- (void)registerReusableViewsWithCollectionView:(UICollectionView *)collectionView
{
    [super registerReusableViewsWithCollectionView:collectionView];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([EELMenuItemCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([EELMenuItemCell class])];
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeFittingSize:(CGSize)size forItemAtIndexPath:(NSIndexPath *)indexPath
{
    EELMenuItemCell *cell = (EELMenuItemCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    CGSize fittingSize = [cell aapl_preferredLayoutSizeFittingSize:size];
    [cell removeFromSuperview];
    return fittingSize;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EELMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EELMenuItemCell class]) forIndexPath:indexPath];
    EELMenuItem *item = [self itemAtIndexPath:indexPath];
    
    [cell configureWithMenuItem:item];
    
    return cell;
}
@end
