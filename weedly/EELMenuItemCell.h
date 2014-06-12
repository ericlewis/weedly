//
//  EELMenuItemCell.h
//  weedly
//
//  Created by 1debit on 6/12/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "AAPLCollectionViewCell.h"

@class EELMenuItem;

@interface EELMenuItemCell : AAPLCollectionViewCell

- (void)configureWithMenuItem:(EELMenuItem *)menuItem;

@end
