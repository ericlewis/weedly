//
//  EELMenuItemCell.m
//  weedly
//
//  Created by 1debit on 6/12/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMenuItemCell.h"

@interface EELMenuItemCell()
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@end

@implementation EELMenuItemCell

- (void)configureWithMenuItem:(EELMenuItem *)menuItem{
    self.textLabel.text = [menuItem formattedNameString];
    
    NSString *pricesString = @"";
    
    if (menuItem.priceHalfGram > 0) {
        pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@"%d 1/2gm  ", menuItem.priceHalfGram]];
    }
    
    if (menuItem.priceGram > 0) {
        pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@"%d 1gm  ", menuItem.priceGram]];
    }
    
    if (menuItem.priceEighth > 0) {
        pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@"%d 1/8  ", menuItem.priceEighth]];
    }
    
    if (menuItem.priceQtr > 0) {
        pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@"%d 1/4  ", menuItem.priceQtr]];
    }
    
    if (menuItem.priceHalfOZ > 0) {
        pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@"%d 1/2  ", menuItem.priceHalfOZ]];
    }
    
    if (menuItem.priceOZ > 0) {
        pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@"%d OZ  ", menuItem.priceOZ]];
    }
    
    if (menuItem.priceUnit > 0) {
        pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@"%d Per  ", menuItem.priceUnit]];
    }
    
    self.subtitleLabel.text = pricesString;

}

@end
