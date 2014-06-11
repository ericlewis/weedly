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

#import "EELDetailListCell.h"

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
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([EELDetailListCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([EELDetailListCell class])];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *menuItem = [self itemAtIndexPath:indexPath];
    EELDetailListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EELDetailListCell class]) forIndexPath:indexPath];
    
    cell.nameLabel.text = menuItem[@"name"];
    
    return cell;
}

@end
