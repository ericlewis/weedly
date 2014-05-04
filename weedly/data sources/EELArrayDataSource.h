//
//  EELArrayDataSource.h
//  weedly
//
//  Created by 1debit on 5/4/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EELArrayDataSource : NSObject<UITableViewDataSource>

@property (copy, nonatomic, readonly) NSArray *items;

+ (instancetype)dataSourceWithItems:(NSArray *)items;

- (id)initWithItems:(NSArray *)items;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
