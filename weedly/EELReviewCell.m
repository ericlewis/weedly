/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  A subclass of AAPLCollectionViewCell that displays an AAPLCatSighting instance.
  
 */

#import "EELReviewCell.h"

#import <Masonry/Masonry.h>

@interface EELReviewCell ()
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet UILabel *ratingLabel;
@property (nonatomic, strong) IBOutlet UILabel *shortDescriptionLabel;
@end

@implementation EELReviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;

    UIView *contentView = self.contentView;
    
    CGFloat padding = 10;

    _dateLabel = [UILabel new];
    _dateLabel.font = [UIFont systemFontOfSize:12];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    
    [contentView addSubview:_dateLabel];

    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.textColor = [UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1.0f];
    _textLabel.font = [UIFont systemFontOfSize:14];

    [contentView addSubview:_textLabel];
    
    _ratingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _ratingLabel.font = [UIFont systemFontOfSize:14];
    _ratingLabel.textColor = [UIColor orangeColor];
    
    [contentView addSubview:_ratingLabel];

    _shortDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _shortDescriptionLabel.font = [UIFont systemFontOfSize:10];
    _shortDescriptionLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    _shortDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _shortDescriptionLabel.numberOfLines = 0;

    [contentView addSubview:_shortDescriptionLabel];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_dateLabel.mas_left);
        make.left.equalTo(contentView).with.offset(padding);
        make.top.equalTo(contentView).with.offset(padding);
        make.bottom.equalTo(_ratingLabel.mas_top).with.offset(-padding/2.5);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).with.offset(-padding);
        make.left.equalTo(_textLabel.mas_right);
        make.top.equalTo(_textLabel);
        make.bottom.equalTo(_textLabel);
    }];
    
    [_ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textLabel.mas_bottom);
        make.right.equalTo(contentView).with.offset(-padding);
        make.left.equalTo(contentView).with.offset(padding);
        make.bottom.equalTo(_shortDescriptionLabel.mas_top).with.offset(-padding/2.5);
    }];
    
    [_shortDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ratingLabel.mas_bottom);
        make.right.equalTo(contentView).with.offset(-padding);
        make.left.equalTo(contentView).with.offset(padding);
        make.bottom.equalTo(contentView).with.offset(-padding);
    }];
    
    [_textLabel contentHuggingPriorityForAxis:UILayoutConstraintAxisVertical];
    [_textLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [_textLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    _textLabel.preferredMaxLayoutWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    [_dateLabel contentHuggingPriorityForAxis:UILayoutConstraintAxisVertical];
    [_dateLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [_dateLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    _dateLabel.preferredMaxLayoutWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    [_ratingLabel contentHuggingPriorityForAxis:UILayoutConstraintAxisVertical];
    [_ratingLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [_ratingLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    _ratingLabel.preferredMaxLayoutWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    [_shortDescriptionLabel contentHuggingPriorityForAxis:UILayoutConstraintAxisVertical];
    [_shortDescriptionLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [_shortDescriptionLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    _shortDescriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);

    return self;
}

- (void)configureWithReview:(EELReview *)review
{
    NSDictionary *newReview = (NSDictionary*)review;
    
    if ([newReview[@"title"] length] > 0) {
        self.textLabel.text = newReview[@"title"];
    }else{
        self.textLabel.text = @"Review";
    }
    
    NSString *reviewStars = [[@"" stringByPaddingToLength:[newReview[@"r"] floatValue] withString:@"★" startingAtIndex:0] stringByPaddingToLength:5 withString:@"☆" startingAtIndex:0];
    self.ratingLabel.text = reviewStars;

    self.shortDescriptionLabel.text = [NSString stringWithFormat:@"%@\n\t", newReview[@"comments"]];
    self.dateLabel.text = [[newReview[@"when"] stringByReplacingOccurrencesOfString:@"about" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
