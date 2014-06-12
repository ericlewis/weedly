//
//  EELEdiblesMenuItemsDataSource.m
//  weedly
//
//  Created by 1debit on 6/12/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELEdiblesMenuItemsDataSource.h"

@implementation EELEdiblesMenuItemsDataSource

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
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 4 or catID = 6 or catID = 11"];
                NSArray *filteredArray = [results filteredArrayUsingPredicate:predicate];
                me.items = filteredArray;
            }];
        }];
    }];
}

@end
