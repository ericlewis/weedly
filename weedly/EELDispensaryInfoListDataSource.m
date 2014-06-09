/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  A basic data source that either fetches the list of all available cats or the user's favorite cats. If this data source represents the favorites, it listens for a notification with the name AAPLCatFavoriteToggledNotificationName and will update itself appropriately.
  
 */

#import "EELDispensaryInfoListDataSource.h"

#import "AAPLBasicCell.h"

#import "UICollectionView+Helpers.h"

#import "AAPLAction.h"
#import "AAPLCollectionViewController.h"

@interface EELDispensaryInfoListDataSource ()
@property (nonatomic, strong) EELDispensary *dispensary;
@end

@implementation EELDispensaryInfoListDataSource

- (instancetype)initWithDispensary:(EELDispensary *)dispensary
{
    self = [super init];
    if (!self)
        return nil;
    
    _dispensary = dispensary;
    
    if ([[self.dispensary formattedTypeString] isEqualToString:@"Delivery"] || self.dispensary.address.length < 4) {
        self.items = @[
                       @{@"name": @"Menu", @"subtitle": @"Check out menu options", @"segue": @"ShowMenu"},
                       @{@"name": @"Phone", @"subtitle": [self.dispensary formattedPhoneString], @"segue": @"ShowPhonePrompt"},
                       ];
    }else if([[self.dispensary formattedTypeString] isEqualToString:@"Doctor"]){
        self.items = @[
                       @{@"name": @"Directions", @"subtitle": @"Get directions from current location", @"segue": @"ShowDirections"},
                       @{@"name": @"Phone", @"subtitle": [self.dispensary formattedPhoneString], @"segue": @"ShowPhonePrompt"},
                       ];
    }else{
        self.items = @[
                       @{@"name": @"Menu", @"subtitle": @"Check out menu options", @"segue": @"ShowMenu"},
                       @{@"name": @"Directions", @"subtitle": @"Get directions from current location", @"segue": @"ShowDirections"},
                       @{@"name": @"Phone", @"subtitle": [self.dispensary formattedPhoneString], @"segue": @"ShowPhonePrompt"},
                       ];
    }
    
    
    return self;
}

- (void)setItems:(NSArray *)items
{
    [super setItems:items];
}

- (void)registerReusableViewsWithCollectionView:(UICollectionView *)collectionView
{
    [super registerReusableViewsWithCollectionView:collectionView];
    [collectionView registerClass:[AAPLBasicCell class] forCellWithReuseIdentifier:NSStringFromClass([AAPLBasicCell class])];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *menuItem = [self itemAtIndexPath:indexPath];
    AAPLBasicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AAPLBasicCell class]) forIndexPath:indexPath];
    cell.style = AAPLBasicCellStyleSubtitle;
    cell.primaryLabel.text = menuItem[@"name"];
    cell.primaryLabel.font = [UIFont systemFontOfSize:14];
    cell.secondaryLabel.text = menuItem[@"subtitle"];
    cell.secondaryLabel.font = [UIFont systemFontOfSize:10];

    return cell;
}

@end
