//
//  EELListTableView.m
//  weedly
//
//  Created by 1debit on 6/9/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELListTableView.h"

@implementation EELListTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    if (point.y<0) {
        return nil;
    }
    return hitView;
}

@end
