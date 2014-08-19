//
//  EELMenuItemCell.m
//  weedly
//
//  Created by Eric Lewis on 6/12/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMenuItemCell.h"

@interface EELMenuItemCell()
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UIView *leftBorder;
@end

@implementation EELMenuItemCell

- (void)configureWithMenuItem:(EELMenuItem *)menuItem{
    self.textLabel.text = [menuItem formattedNameString];
    
    NSString *pricesString = @"";
    
    if (menuItem.catID == 1) {
        self.leftBorder.backgroundColor = [UIColor colorWithRed:115/255.0f green:73/255.0f blue:121/255.0f alpha:1.0f];
    } else if (menuItem.catID == 2) {
        self.leftBorder.backgroundColor = [UIColor colorWithRed:182/255.0f green:75/255.0f blue:48/255.0f alpha:1.0f];
    } else if (menuItem.catID == 3) {
        self.leftBorder.backgroundColor = [UIColor colorWithRed:132/255.0f green:176/255.0f blue:43/255.0f alpha:1.0f];
    }else{
        self.leftBorder.backgroundColor = [UIColor clearColor];
    }
    
    if (menuItem.priceHalfGram > 0) {
        pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@" %d |HG  •", menuItem.priceHalfGram]];
    }
    
    if (menuItem.priceGram > 0) {
        pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@" %d |G  •", menuItem.priceGram]];
    }
    
    if (menuItem.priceEighth > 0) {
        pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@" %d |1/8  •", menuItem.priceEighth]];
    }
    
    if (menuItem.priceQtr > 0) {
        pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@" %d |1/4  •", menuItem.priceQtr]];
    }
    
    if (menuItem.priceHalfOZ > 0) {
        pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@" %d |1/2  •", menuItem.priceHalfOZ]];
    }
    
    if (menuItem.priceOZ > 0) {
        pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@" %d |OZ  •", menuItem.priceOZ]];
    }
    
    if (menuItem.priceUnit > 0) {
        pricesString = [pricesString stringByAppendingString:[NSString stringWithFormat:@" %d |Per  •", menuItem.priceUnit]];
    }
    
    if (pricesString.length > 0) {
        pricesString = [[pricesString substringToIndex:pricesString.length-(pricesString.length>0)] substringFromIndex:1];
    }
    
    self.subtitleLabel.text = pricesString;

    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    
    self.subtitleLabel.hidden = YES;

}

@end
