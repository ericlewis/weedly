//
//  EELConcentratesMenuItemsDataSource.m
//  weedly
//
//  Created by Eric LEwis on 6/12/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELConcentratesMenuItemsDataSource.h"

@implementation EELConcentratesMenuItemsDataSource

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
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catID = 5 or catID = 9 or catID = 11 or catID = 13 or catID = 10"];
                NSArray *filteredArray = [results filteredArrayUsingPredicate:predicate];
                me.items = filteredArray;
            }];
        }];
    }];
}

@end
