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
@property (weak, nonatomic) IBOutlet UIImageView *disclosureArrow;
@property (nonatomic, weak) IBOutlet UIView *leftBorder;
@end

@implementation EELMenuItemCell

- (void)configureWithMenuItem:(EELMenuItem *)menuItem{
    self.disclosureArrow.hidden = NO;
    self.textLabel.text = [menuItem formattedNameString];

    if (menuItem.catID == 1) {
        self.leftBorder.backgroundColor = [UIColor colorWithRed:116/255.0f green:73/255.0f blue:121/255.0f alpha:1.0f];
    } else if (menuItem.catID == 2) {
        self.leftBorder.backgroundColor = [UIColor colorWithRed:183/255.0f green:75/255.0f blue:48/255.0f alpha:1.0f];
    } else if (menuItem.catID == 3) {
        self.leftBorder.backgroundColor = [UIColor colorWithRed:133/255.0f green:176/255.0f blue:43/255.0f alpha:1.0f];
    }else{
        self.leftBorder.backgroundColor = [UIColor clearColor];
        self.disclosureArrow.hidden = YES;
    }
    
    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
}

@end
