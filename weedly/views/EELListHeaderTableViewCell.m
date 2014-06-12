//
//  EELListHeaderTableViewCell.m
//  weedly
//
//  Created by 1debit on 6/11/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELListHeaderTableViewCell.h"

@interface EELListHeaderTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation EELListHeaderTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)configureWithAmount:(NSUInteger)amount{
    if (amount == 1) {
        self.titleLabel.text = [NSString stringWithFormat:@"%lu Result", (unsigned long)amount];
    }
    else if (amount > 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"%lu Results", (unsigned long)amount];
    }
}

@end
