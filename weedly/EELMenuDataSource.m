//
//  EELMenuDataSource.m
//  weedly
//
//  Created by Eric LEwis on 6/11/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELMenuDataSource.h"
#import "EELMenuItemsDataSource.h"

#import "UICollectionView+Helpers.h"

@interface EELMenuDataSource ()
@property (nonatomic, strong) EELDispensary *dispensary;
@property (nonatomic, strong) EELMenuItemsDataSource *menuItemsDataSource;
@end

@implementation EELMenuDataSource

- (instancetype)init
{
    return [self initWithDispensary:nil];
}

- (instancetype)initWithDispensary:(EELDispensary *)dispensary
{
    self = [super init];
    if (!self)
        return nil;
    
    _dispensary = dispensary;
    _menuItemsDataSource = [[EELMenuItemsDataSource alloc] initWithDispensary:dispensary];
    
    [self addDataSource:_menuItemsDataSource];
    
    return self;
}

- (void)loadContent
{
    [self loadContentWithBlock:^(AAPLLoading *loading) {
        [[EELWMClient sharedClient] getMenuWithDispensaryID:self.dispensary.id.stringValue completionBlock:^(EELMenu *result, NSError *error) {
            if (!loading.current) {
                [loading ignore];
                return;
            }
            
            if (error) {
                [loading doneWithError:error];
                return;
            }
            
            // There's always content, because this is a composed data source
            [loading updateWithContent:^(EELMenuDataSource *me) {
                
            }];
        }];
    }];
}

@end
