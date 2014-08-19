//
//  EELDetailInfoCell.h
//  weedly
//
//  Created by Eric Lewis on 8/19/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "AAPLCollectionViewCell.h"

@interface EELDetailInfoCell : AAPLCollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@end
