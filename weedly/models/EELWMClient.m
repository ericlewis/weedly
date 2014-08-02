//
//  EELWMClient.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELWMClient.h"
#import "EELWMResponse.h"

@implementation EELWMClient


+ (instancetype)sharedClient {
    static EELWMClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[EELWMClient alloc] init];
        [_sharedClient setRequestSerializer:[AFJSONRequestSerializer serializer]];
    });
    
    return _sharedClient;
}

- (id)init {
    return [super initWithBaseURL:[NSURL URLWithString:@"https://api.legalmarijuanadispensary.com"]];
}

#pragma mark -
#pragma mark Search Actions
- (void)searchDoctorsWithTerm:(NSString *)term map:(MKMapView*)map completionBlock:(void (^)(NSArray *results, NSError *error))block {
    [self searchWithType:@"doctor" model:[EELDispensary class] term:term map:map completionBlock:block];
}

- (void)searchDispensariesWithTerm:(NSString *)term map:(MKMapView*)map completionBlock:(void (^)(NSArray *results, NSError *error))block {
    [self searchWithType:@"dispensary" model:[EELDispensary class] term:term map:map completionBlock:block];
}

#pragma mark -
#pragma mark Merchant Actions
- (void)getMenuWithDispensaryID:(NSString*)ID completionBlock:(void (^)(EELMenu *result, NSError *error))block{
    NSParameterAssert(ID);
    
    [self GET:[NSString stringWithFormat:@"dispensaries/%@/menu.json", ID] parameters:nil completion:^(OVCResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            block(response.result, error);
        });
    }];
}

- (void)getMenuItemsWithDispensaryID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(ID);
    [self GET:[NSString stringWithFormat:@"dispensaries/%@/menu_items.json", ID] parameters:nil completion:^(OVCResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            block(response.result, error);
        });
    }];
}

#pragma mark Review Actions
- (void)getReviewsWithDispensaryID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(ID);
    
    [self GET:[NSString stringWithFormat:@"api/v4/reviews/dispensary/%@", ID] parameters:nil completion:^(OVCResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            block(response.result, error);
        });
    }];
}

- (void)getReviewsWithDoctorID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(ID);
    
    [self GET:[NSString stringWithFormat:@"api/v4/reviews/doctor/%@", ID] parameters:nil completion:^(OVCResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            block(response.result, error);
        });
    }];
}

#pragma mark -
#pragma mark Private
- (void)searchWithType:(NSString*)type model:(id)class term:(NSString*)term map:(MKMapView*)map completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(type);
    NSParameterAssert(term);
    NSParameterAssert(block);
    NSParameterAssert(map);
    
    CLLocationCoordinate2D topRightCoords = CLLocationCoordinate2DMake(
                                                                  map.region.center.latitude + map.region.span.latitudeDelta / 2.0,
                                                                  map.region.center.longitude - map.region.span.longitudeDelta / 2.0);
    
    CLLocationCoordinate2D bottomLeftCoords = CLLocationCoordinate2DMake(
                                                                  map.region.center.latitude - map.region.span.latitudeDelta / 2.0,
                                                                  map.region.center.longitude + map.region.span.longitudeDelta / 2.0);
    
    id searchQuery = @{@"bool":
                           @{@"should":
                                 @[
                                     @{@"multi_match":
                                           @{@"query": term,
                                             @"fields":
                                                 @[@"name^5", @"_all"]
                                             }
                                       }
                                     ]
                             }
                       };
    
    if ([[term stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0) {
        searchQuery = [NSNull null];
    }
    
    NSDictionary *parametersNewSearch = @{
        @"size" : @"200",
        @"query": @{
            @"function_score": @{
                @"query": @{
                    @"filtered": @{
                        @"query": searchQuery,
                        @"filter": @{
                            @"and": @{
                                @"filters": @[
                                    @{
                                        @"type": @{
                                                @"value": type
                                        }
                                    },
                                    @{
                                        @"term": @{
                                                @"published": @"true"
                                        }
                                    },
                                    @{
                                        @"geo_bounding_box": @{
                                            @"lat_lon": @{
                                                @"bottom_left": @{
                                                        @"lat" : [@(map.region.center.latitude - map.region.span.latitudeDelta) description],
                                                        @"lon": [@(map.region.center.longitude - map.region.span.longitudeDelta) description]
                                                },
                                                @"top_right": @{
                                                        @"lat": [@(map.region.center.latitude + map.region.span.latitudeDelta) description],
                                                        @"lon": [@(map.region.center.longitude + map.region.span.longitudeDelta) description]
                                                }
                                            }
                                        }
                                    }
                                ]
                            }
                        }
                    }
                },
                @"functions": @[
                    @{@"script_score":
                        @{@"script": @"sqrt(_score * doc.feature_level_raw.value)"}
                    }
                ]
            }
        }
    };
    
    [self POST:@"http://search-prod.weedmaps.com:9200/weedmaps/_search?" parameters:parametersNewSearch completion:^(OVCResponse *response, NSError *error) {
        NSLog(@"%@", response);
        block(response.result, error);
    }];
}

+ (NSDictionary *)modelClassesByResourcePath {
    return @{
             @"api/v4/search": [EELDispensary class],
             @"weedmaps/_search": [EELDispensary class],
             @"/api/v4/coupons": [EELDeal class],
             @"dispensaries/#/menu.json": [EELMenu class],
             @"dispensaries/#/menu_items.json": [EELMenuItem class],
             @"api/v4/reviews/*": [EELReview class],
             };
}

+ (Class)responseClass {
    return [EELWMResponse class];
}

#pragma mark - Offers API
- (void) getDealsAround:(CLLocation*)location completionBlock:(void(^)(NSArray*, NSError*))block {
    [self GET:@"/api/v4/coupons" parameters:@{ @"lat" : @(location.coordinate.latitude), @"lng" : @(location.coordinate.longitude) } completion:^(OVCResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(response.result, error);
        });
    }];
}

@end
