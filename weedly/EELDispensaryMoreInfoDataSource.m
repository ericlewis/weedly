//
//  EELDispensaryMoreInfoDataSource.m
//  weedly
//
//  Created by Eric Lewis on 8/18/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELDispensaryMoreInfoDataSource.h"

#import "UICollectionView+Helpers.h"

#import "AAPLAction.h"
#import "AAPLCollectionViewController.h"

#import "EELDetailInfoCell.h"

@interface EELDispensaryMoreInfoDataSource ()
@property (nonatomic, strong) EELDispensary *dispensary;
@end

@implementation EELDispensaryMoreInfoDataSource

- (NSString*)stringFromBool:(BOOL)value{
    return value ? @"YES" : @"NO";
}

- (instancetype)initWithDispensary:(EELDispensary *)dispensary
{
    self = [super init];
    if (!self)
        return nil;
    
    _dispensary = dispensary;
    self.defaultMetrics.rowHeight = 40;

    NSMutableArray *itemsToUse = [NSMutableArray new];
    
    // handicap accessible
    [itemsToUse addObject:@{
                            @"name": @"ADA Accessible",
                            @"subtitle": [self stringFromBool:[self.dispensary hasHandicapAccess]],
                            }
     ];
    
    // CC accepted
    [itemsToUse addObject:@{
                            @"name": @"Credit Cards",
                            @"subtitle": [self stringFromBool:[self.dispensary creditCardsAccepted]],
                            }
     ];
    
    // testing exists
    [itemsToUse addObject:@{
                            @"name": @"Lab Testing",
                            @"subtitle": [self stringFromBool:[self.dispensary hasTesting]],
                            }
     ];
    
    // lounge exists
    [itemsToUse addObject:@{
                            @"name": @"Lounge",
                            @"subtitle": [self stringFromBool:[self.dispensary hasLounge]],
                            }
     ];
    
    // guard exists
    [itemsToUse addObject:@{
                            @"name": @"Security",
                            @"subtitle": [self stringFromBool:[self.dispensary hasGuard]],
                            }
     ];
 
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
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([EELDetailInfoCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([EELDetailInfoCell class])];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *menuItem = [self itemAtIndexPath:indexPath];
    
    EELDetailInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EELDetailInfoCell class]) forIndexPath:indexPath];
    
    cell.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    cell.nameLabel.textColor = [UIColor colorWithRed:145.0f/255.0f green:145.0f/255.0f blue:145.0f/255.0f alpha:1.0f];
    
    cell.nameLabel.text = menuItem[@"subtitle"];
    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@:", menuItem[@"name"]];
    cell.subtitleLabel.textColor = cell.nameLabel.textColor;
    cell.subtitleLabel.font = cell.nameLabel.font;
    
    
    return cell;
}


@end
