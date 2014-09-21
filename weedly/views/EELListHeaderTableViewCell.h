//
//  EELListHeaderTableViewCell.h
//  weedly
//
//  Created by Eric Lewis on 6/11/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EELListHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *myLocationButton;
@property (weak, nonatomic) IBOutlet UIView *amountBackground;

- (void)configureWithAmount:(NSUInteger)amount;

@end
