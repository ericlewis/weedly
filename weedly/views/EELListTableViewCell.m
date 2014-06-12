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
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
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
    
    self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:35/2];
    self.nameLabel.text = [dispensary formattedNameString].uppercaseString;
    
    self.distanceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    self.distanceLabel.textColor = GRAY_COLOR;

    self.hoursLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    self.hoursLabel.textColor = GRAY_COLOR;
    
    self.isOpenLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    self.isOpenLabel.textColor = MAIN_COLOR;
    
    self.ratingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    self.ratingLabel.textColor = ORANGE_COLOR;

    if (dispensary.isOpen.boolValue) {
        self.isOpenLabel.text = @"Currently Open";
    }else{
        self.isOpenLabel.text = @"Currently Closed";
    }
    
    if (dispensary.ratingCount > 0) {
        self.ratingLabel.text = [NSString stringWithFormat:@"%d Reviews • %@", dispensary.ratingCount, [@"" stringByPaddingToLength:dispensary.rating withString:@"★" startingAtIndex:0]];
    }else{
        self.ratingLabel.text = @"No ratings";
    }
    
    if (dispensary.opensAt.length > 0 && dispensary.closesAt.length > 0) {
        self.hoursLabel.text = [NSString stringWithFormat:@"%@  %@ to %@", [dispensary formattedTypeString], [dispensary.opensAt stringByReplacingOccurrencesOfString:@" " withString:@""].uppercaseString, [dispensary.closesAt stringByReplacingOccurrencesOfString:@" " withString:@""].uppercaseString];
    }else{
        self.hoursLabel.text = [NSString stringWithFormat:@"%@  Hours unavailable", [dispensary formattedTypeString]];
    }
    
    CLLocation *locA = [MTLocationManager sharedInstance].lastKnownLocation;
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:dispensary.lat longitude:dispensary.lng];
    CLLocationDistance distance = [locA distanceFromLocation:locB];

    if ((distance/1609.344) > 0 && (distance/1609.344) < 0.2) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.0fft", (distance*3.28084)];
    }
    else if ((distance/1609.344) > 0) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1f mi", (distance/1609.344)];
    }
}

@end
