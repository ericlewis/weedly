//
//  EELDetailListCell.h
//  weedly
//
//  Created by Eric Lewis on 6/11/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "AAPLBasicCell.h"

@interface EELDetailListCell : AAPLCollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIImageView *disclosureView;

@end
