//
//  EELFlowerMenuItemsDataSource.m
//  weedly
//
//  Created by Eric LEwis on 6/12/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELFlowerMenuItemsDataSource.h"

@implementation EELFlowerMenuItemsDataSource

- (void)loadContent
{
    [self loadContentWithBlock:^(AAPLLoading *loading) {
        [[EELWMClient sharedClient] getMenuItemsWithDispensaryID:self.dispensary.id.stringValue completionBlock:^(NSArray *results, NSError *error) {
            if (!loading.current) {
                [loading ignore];
                return;
            }
            
            if (error) {
                [loading doneWithError:error];
                return;
            }
            
            [loading updateWithContent:^(EELMenuItemsDataSource *me){
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 1 OR catID = 2 OR catID = 3 or catID = 12 or catID = 7 or catID = 8"];
                NSArray *filteredArray = [results filteredArrayUsingPredicate:predicate];
                me.items = filteredArray;
            }];
        }];
    }];
}

@end
