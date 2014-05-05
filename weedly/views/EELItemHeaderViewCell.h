//
//  EELItemHeaderViewCell.h
//  weedly
//
//  Created by 1debit on 5/4/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EELItemHeaderViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *isOpenLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIView *reviewsView;
@property (weak, nonatomic) IBOutlet UILabel *reviewsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *reviewsStarsImage;

@end
