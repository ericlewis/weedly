//
//  EELArrayDataSource.m
//  weedly
//
//  Created by Eric Lewis on 5/4/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELArrayDataSource.h"

@implementation EELArrayDataSource

+ (instancetype)dataSourceWithItems:(NSArray *)items{
    return [[self alloc] initWithItems:items];
}

- (id)initWithItems:(NSArray *)items{
    if (self) {
        _items = [items copy];
    }
    
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.items[(NSUInteger) indexPath.row];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

@end
