/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
 A basic data source that either fetches the list info cell options available
 
 */

#import "EELDispensaryInfoListDataSource.h"

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
    
    NSMutableArray *itemsToUse = [NSMutableArray new];
    
    // menu if delivery / dispensary
    if ([[self.dispensary formattedTypeString] isEqualToString:@"Delivery"] || [[self.dispensary formattedTypeString] isEqualToString:@"Dispensary"]){
        [itemsToUse addObject:@{
                                @"name": @"Menu",
                                @"subtitle": @"Our menu is frequently updated.",
                                @"segue": @"ShowMenu",
                                @"imageName": @"list_ingredients-128"
                                }
         ];
    }
    
    // directions if able to
    if(self.dispensary.address.length > 4){
        [itemsToUse addObject:@{
                                @"name": @"Directions",
                                @"subtitle": @"Find your way here",
                                @"segue": @"ShowDirections",
                                @"imageName": @"map_marker-128"
                                }
         ];
    }
    
    if (self.dispensary.phone.length > 4) {
        [itemsToUse addObject:@{
                                @"name": @"Call Us",
                                @"subtitle": [self.dispensary formattedPhoneString],
                                @"segue": @"ShowPhonePrompt",
                                @"imageName": @"phone1-128"
                                }
         ];
    }

    self.items = itemsToUse;
    
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
    cell.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.subtitleLabel.text = menuItem[@"subtitle"];
    cell.subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    cell.imageView.image = [UIImage imageNamed:menuItem[@"imageName"]];
    
    return cell;
}

@end
