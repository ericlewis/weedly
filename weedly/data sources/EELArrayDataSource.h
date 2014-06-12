//
//  EELArrayDataSource.h
//  weedly
//
//  Created by Eric Lewis on 5/4/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EELArrayDataSource : NSObject

@property (copy, nonatomic, readonly) NSArray *items;

+ (instancetype)dataSourceWithItems:(NSArray *)items;

- (id)initWithItems:(NSArray *)items;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
