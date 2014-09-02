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
    self.defaultMetrics.rowHeight = 68;

    NSMutableArray *itemsToUse = [NSMutableArray new];
    
    // menu & coupons if delivery / dispensary
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
    if(!self.dispensary.isDelivery){
        [itemsToUse addObject:@{
                                @"name": @"Uber",
                                @"subtitle": @"Request an Uber.",
                                @"segue": @"OpenUber",
                                @"imageName": @"uberIcon"
                                }];
        
        [itemsToUse addObject:@{
                                @"name": @"Directions",
                                @"subtitle": @"Find your way here",
                                @"segue": @"ShowDirections",
                                @"imageName": @"map_marker-128"
                                }
         ];
    }
    
    // phone if avail
    if (self.dispensary.phone.length > 4 && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
        [itemsToUse addObject:@{
                                @"name": @"Call",
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
    cell.nameLabel.textColor = [UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1.0f];
    cell.subtitleLabel.text = menuItem[@"subtitle"];
    cell.subtitleLabel.textColor = [UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:1.0f];
    cell.subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    cell.imageView.image = [UIImage imageNamed:menuItem[@"imageName"]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([menuItem objectForKey:@"infoItem"]) {
        cell.backgroundColor = [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f];
        cell.disclosureView.hidden = YES;
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        cell.disclosureView.hidden = NO;
    }
    
    return cell;
}

@end
