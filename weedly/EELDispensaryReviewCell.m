/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  A subclass of AAPLCollectionViewCell that displays an AAPLCatSighting instance.
  
 */

#import "EELDispensaryReviewCell.h"

@interface EELDispensaryReviewCell ()
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UILabel *shortDescriptionLabel;
@end

@implementation EELDispensaryReviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;

    UIView *contentView = self.contentView;

    _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _dateLabel.font = [UIFont systemFontOfSize:12];
    _dateLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    [_dateLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    [contentView addSubview:_dateLabel];

    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _textLabel.font = [UIFont systemFontOfSize:14];

    [contentView addSubview:_textLabel];
    
    _ratingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _ratingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _ratingLabel.font = [UIFont systemFontOfSize:14];
    _ratingLabel.textColor = [UIColor orangeColor];
    
    [contentView addSubview:_ratingLabel];

    _shortDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _shortDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _shortDescriptionLabel.font = [UIFont systemFontOfSize:10];
    _shortDescriptionLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    _shortDescriptionLabel.numberOfLines = 0;

    [contentView addSubview:_shortDescriptionLabel];

    NSMutableArray *constraints = [NSMutableArray array];
    NSDictionary *views = NSDictionaryOfVariableBindings(_dateLabel, _textLabel, _ratingLabel, _shortDescriptionLabel);

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_textLabel]-[_dateLabel]-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_ratingLabel]-|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_shortDescriptionLabel]-|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_textLabel][_ratingLabel][_shortDescriptionLabel]-3-|" options:0 metrics:nil views:views]];

    [contentView addConstraints:constraints];

    return self;
}

- (void)configureWithReview:(EELReview *)review
{
    if (review.title.length > 0) {
        self.textLabel.text = review.title;
    }else{
        self.textLabel.text = @"Review";
    }
    
    self.ratingLabel.text = [NSString stringWithFormat:@"%@ • %@", [@"" stringByPaddingToLength:review.rating withString:@"★" startingAtIndex:0], review.name];

    self.shortDescriptionLabel.text = review.comment;
    self.dateLabel.text = review.timeAgo;
}
@end
