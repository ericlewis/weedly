//
//  EELWMClient.m
//  weedly
//
//  Created by 1debit on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELWMClient.h"

@implementation EELWMClient


+ (instancetype)sharedClient {
    static EELWMClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[EELWMClient alloc] init];
    });
    
    return _sharedClient;
}

- (id)init {
    return [super initWithBaseURL:[NSURL URLWithString:@"https://api.legalmarijuanadispensary.com/api/v4"]];
}

#pragma mark -
#pragma mark Search Actions
- (void)searchDoctorsWithTerm:(NSString *)term completionBlock:(void (^)(NSArray *results, NSError *error))block {
    [self searchWithType:@"doctor" model:[EELDoctor class] term:term completionBlock:block];
}

- (void)searchDispensariesWithTerm:(NSString *)term completionBlock:(void (^)(NSArray *results, NSError *error))block {
    [self searchWithType:@"dispensary" model:[EELDispensary class] term:term completionBlock:block];
}

#pragma mark -
#pragma mark Merchant Actions
- (void)getMerchantWithID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    
}

- (void)getMenuItemsWithMerchantID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    [self GET:@"/dispensaries/633/menu_items.json" parameters:nil resultClass:[EELMenuItem class] resultKeyPath:@"" completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        block(responseObject, error);
    }];
}

#pragma mark Review Actions
- (void)getReviewsWithMerchantID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    
}

- (void)postReviewForMerchantWithID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    
}

- (void)deleteReviewWithID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    
}

#pragma mark -
#pragma mark Smokin On Actions
- (void)getSmokinOnListWithCompletionBlock:(void (^)(NSArray *results, NSError *error))block{

}

- (void)postSmokinOnStatus:(NSString*)status completionBlock:(void (^)(NSArray *results, NSError *error))block{

}

#pragma mark -
#pragma mark Account Actions
- (void)loginAccountWithUsername:(NSString*)username password:(NSString*)password completionBlock:(void (^)(NSArray *results, NSError *error))block{}
- (void)getAccountWithID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{}
- (void)getReviewsWithAccountID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{}
- (void)getFavoritesWithAccountID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{}

#pragma mark -
#pragma mark Private
- (void)searchWithType:(NSString*)type model:(id)class term:(NSString*)term completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(type);
    NSParameterAssert(term);
    NSParameterAssert(block);
    
    CLLocationCoordinate2D coords = [MTLocationManager sharedInstance].lastKnownLocation.coordinate;
    
    NSDictionary *parameters = @{
                                 @"type" : type,
                                 @"lat"  : [NSString stringWithFormat:@"%f", coords.latitude ?: 37.773972],
                                 @"lng"  : [NSString stringWithFormat:@"%f", coords.longitude ?: -122.431297],
                                 @"q"    : term
                                 };
    
    [self GET:@"search" parameters:parameters resultClass:class resultKeyPath:@"hits" completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        block(responseObject, error);
    }];
}

@end
