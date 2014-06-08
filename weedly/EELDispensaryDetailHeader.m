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
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *hoursLabel;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UILabel *isOpenLabel;
@property (nonatomic, strong) UIButton *favoriteButton;
@property (nonatomic, getter=isFavorite) BOOL favorite;
@end

@implementation EELDispensaryDetailHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _nameLabel.font = [UIFont systemFontOfSize:18];
    _nameLabel.numberOfLines = 1;
    [self addSubview:_nameLabel];
    
    _hoursLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _hoursLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _hoursLabel.font = [UIFont systemFontOfSize:14];
    _hoursLabel.numberOfLines = 2;
    _hoursLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    [self addSubview:_hoursLabel];
    
    _isOpenLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _isOpenLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _isOpenLabel.font = [UIFont systemFontOfSize:12];
    _isOpenLabel.numberOfLines = 1;
    _isOpenLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    [self addSubview:_isOpenLabel];
    
    _ratingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _ratingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _ratingLabel.font = [UIFont systemFontOfSize:12];
    _ratingLabel.numberOfLines = 1;
    _ratingLabel.textColor = [UIColor orangeColor];
    [self addSubview:_ratingLabel];
    
    _favoriteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _favoriteButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_favoriteButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_favoriteButton setImage:[UIImage imageNamed:@"like-75"] forState:UIControlStateNormal];
    [_favoriteButton addTarget:self action:@selector(favoriteTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_favoriteButton setTintColor:[UIColor blackColor]];
    
    [self addSubview:_favoriteButton];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_nameLabel, _isOpenLabel, _ratingLabel, _favoriteButton, _hoursLabel);
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_nameLabel]-[_favoriteButton]-|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_hoursLabel]-[_favoriteButton]-|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_isOpenLabel]-[_ratingLabel]-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_nameLabel][_hoursLabel]-3-[_ratingLabel]" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_favoriteButton]" options:0 metrics:nil views:views]];
    
    [self addConstraints:constraints];
    return self;
}

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
