/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  The cat detail data source, of course. Initialised with a cat instance, this data source will fetch the detail information about that cat.
  
 */

#import "EELDispensaryDetailDataSource.h"
#import "AAPLKeyValueDataSource.h"
#import "AAPLTextValueDataSource.h"
#import "AAPLDataSource+Headers.h"

#import "EELWMClient.h"

@interface EELDispensaryDetailDataSource ()
@property (nonatomic, strong) EELDispensary *dispensary;
@property (nonatomic, strong) AAPLKeyValueDataSource *classificationDataSource;
@property (nonatomic, strong) AAPLTextValueDataSource *descriptionDataSource;
@end

@implementation EELDispensaryDetailDataSource

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
    _classificationDataSource = [[AAPLKeyValueDataSource alloc] initWithObject:dispensary];
    _classificationDataSource.defaultMetrics.rowHeight = 22;
    _classificationDataSource.title = NSLocalizedString(@"Classification", @"Title of the classification data section");
    [_classificationDataSource dataSourceTitleHeader];

    [self addDataSource:_classificationDataSource];

    _descriptionDataSource = [[AAPLTextValueDataSource alloc] initWithObject:dispensary];
    _descriptionDataSource.defaultMetrics.rowHeight = AAPLRowHeightVariable;

    [self addDataSource:_descriptionDataSource];

    return self;
}

- (void)updateChildDataSources
{
    self.classificationDataSource.items = @[
                                            @{ @"label" : NSLocalizedString(@"Kingdom", @"label for kingdom cell"), @"keyPath" : @"classificationKingdom" },
                                            @{ @"label" : NSLocalizedString(@"Phylum", @"label for the phylum cell"), @"keyPath" : @"classificationPhylum" },
                                            @{ @"label" : NSLocalizedString(@"Class", @"label for the class cell"), @"keyPath" : @"classificationClass" },
                                            @{ @"label" : NSLocalizedString(@"Order", @"label for the order cell"), @"keyPath" : @"classificationOrder" },
                                            @{ @"label" : NSLocalizedString(@"Family", @"label for the family cell"), @"keyPath" : @"classificationFamily" },
                                            @{ @"label" : NSLocalizedString(@"Genus", @"label for the genus cell"), @"keyPath" : @"classificationGenus" },
                                            @{ @"label" : NSLocalizedString(@"Species", @"label for the species cell"), @"keyPath" : @"classificationSpecies" }
                                            ];

    self.descriptionDataSource.items = @[
                                         @{ @"label" : NSLocalizedString(@"Description", @"Title of the description data section"), @"keyPath" : @"longDescription" },
                                         @{ @"label" : NSLocalizedString(@"Habitat", @"Title of the habitat data section"), @"keyPath" : @"habitat" }
                                         ];
}

- (void)loadContent
{
    [self loadContentWithBlock:^(AAPLLoading *loading) {
        [[EELWMClient sharedClient] getDispensaryWithID:self.dispensary.id.stringValue completionBlock:^(NSArray *results, NSError *error) {
            NSLog(@"%@", results);
            
            if (!loading.current) {
                [loading ignore];
                return;
            }
            
            if (error) {
                [loading doneWithError:error];
                return;
            }
            
            // There's always content, because this is a composed data source
            [loading updateWithContent:^(EELDispensaryDetailDataSource *me) {
                [me updateChildDataSources];
            }];
        }];
    }];
}

@end
