//
//  EELDispensaryMoreInfoDataSource.m
//  weedly
//
//  Created by 1debit on 8/18/14.
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
    return [self.dispensary creditCardsAccepted] ? @"YES" : @"NO";
}

- (NSString*)hoursStringFromStoreHours:(EELStoreHours*)hours{
    if (hours.opensAt != nil && hours.opensAt != nil) {
        return [NSString stringWithFormat:@"%@-%@", [[hours opensAt] stringByReplacingOccurrencesOfString:@" " withString:@""], [[hours closesAt] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    }
    
    return @"N/A";
}

- (instancetype)initWithDispensary:(EELDispensary *)dispensary
{
    self = [super init];
    if (!self)
        return nil;
    
    _dispensary = dispensary;
    self.defaultMetrics.rowHeight = 50;

    NSMutableArray *itemsToUse = [NSMutableArray new];
    
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
    
    // guard exists
    [itemsToUse addObject:@{
                            @"name": @"Security",
                            @"subtitle": [self stringFromBool:[self.dispensary hasGuard]],
                            }
     ];
    
    
    // hours
    [itemsToUse addObject:@{
                            @"name": @"Monday",
                            @"subtitle": [self hoursStringFromStoreHours:[self.dispensary hoursForDay:@"mon"]],
                            }
     ];
    
    [itemsToUse addObject:@{
                            @"name": @"Tuesday",
                            @"subtitle": [self hoursStringFromStoreHours:[self.dispensary hoursForDay:@"tue"]],
                            }
     ];
    
    [itemsToUse addObject:@{
                            @"name": @"Wednesday",
                            @"subtitle": [self hoursStringFromStoreHours:[self.dispensary hoursForDay:@"wed"]],
                            }
     ];
    
    [itemsToUse addObject:@{
                            @"name": @"Thursday",
                            @"subtitle": [self hoursStringFromStoreHours:[self.dispensary hoursForDay:@"thu"]],
                            @"infoItem": @YES,
                            @"imageName": @"calendar"
                            }
     ];
    
    [itemsToUse addObject:@{
                            @"name": @"Friday",
                            @"subtitle": [self hoursStringFromStoreHours:[self.dispensary hoursForDay:@"fri"]],
                            }
     ];
    
    [itemsToUse addObject:@{
                            @"name": @"Saturday",
                            @"subtitle": [self hoursStringFromStoreHours:[self.dispensary hoursForDay:@"sat"]],
                            }
     ];
    
    [itemsToUse addObject:@{
                            @"name": @"Sunday",
                            @"subtitle": [self hoursStringFromStoreHours:[self.dispensary hoursForDay:@"sun"]],
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
