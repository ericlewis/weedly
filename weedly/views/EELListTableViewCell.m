//
//  EELListTableViewCell.m
//  weedly
//
//  Created by 1debit on 6/11/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELListTableViewCell.h"

@interface EELListTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *hoursLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratingLabel;
@property (nonatomic, weak) IBOutlet UILabel *isOpenLabel;
@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;
@property (nonatomic, getter=isFavorite) BOOL favorite;

@end

@implementation EELListTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithDispensary:(EELDispensary *)dispensary
{
    self.backgroundColor = [UIColor whiteColor];
    self.nameLabel.text = dispensary.name;
    
    if (dispensary.isOpen.boolValue) {
        self.isOpenLabel.text = @"Currently Open";
    }else{
        self.isOpenLabel.text = @"Currently Closed";
    }
    
    if (dispensary.ratingCount > 0) {
        self.ratingLabel.text = [NSString stringWithFormat:@"%@ • %d Reviews", [@"" stringByPaddingToLength:dispensary.rating withString:@"★" startingAtIndex:0], dispensary.ratingCount];
    }else{
        self.ratingLabel.text = @"No ratings";
    }
    
    if (dispensary.opensAt.length > 0 && dispensary.closesAt.length > 0) {
        self.hoursLabel.text = [NSString stringWithFormat:@"%@\nOpen %@ to %@", [dispensary formattedTypeString], [dispensary.opensAt stringByReplacingOccurrencesOfString:@" " withString:@""].uppercaseString, [dispensary.closesAt stringByReplacingOccurrencesOfString:@" " withString:@""].uppercaseString];
    }else{
        self.hoursLabel.text = [NSString stringWithFormat:@"%@\nHours unavailable", [dispensary formattedTypeString]];
    }
}

@end
