/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
 The header view shown in the cat detail screen. This view shows the name of the cat, its conservation status, and the favorite flag.
 
 */

#import "EELDispensaryDetailHeader.h"

#import "UIView+Helpers.h"

@interface NSObject ()
- (void)toggleFavorite:(id)sender;
@end

@interface EELDispensaryDetailHeader ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *hoursLabel;
@property (nonatomic, weak) IBOutlet UILabel *ratingLabel;
@property (nonatomic, weak) IBOutlet UILabel *isOpenLabel;
@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;
@property (nonatomic, getter=isFavorite) BOOL favorite;
@end

@implementation EELDispensaryDetailHeader

- (void)setFavorite:(BOOL)favorite
{
    if (_favorite == favorite)
        return;
    
    _favorite = favorite;
    
    UIImage *image;
    if (favorite)
        image = [UIImage imageNamed:@"liked-75"];
    else
        image = [UIImage imageNamed:@"like-75"];
    
    [_favoriteButton setImage:image forState:UIControlStateNormal];
}

- (void)configureWithDispensary:(EELDispensary *)dispensary
{
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

- (void)favoriteTapped:(id)sender
{
    self.favorite = !self.favorite;
    
    [self.superview aapl_sendAction:@selector(toggleFavorite:) from:self];
}
@end
