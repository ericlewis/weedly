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
- (void)getDispensaryWithID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(ID);

    [self GET:[NSString stringWithFormat:@"listing/dispensary/%@", ID] parameters:nil resultClass:[EELDispensary class] resultKeyPath:@"docs" completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        block(responseObject, error);
    }];
}

- (void)getMenuItemsWithDispensaryID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(ID);

    [self GET:[NSString stringWithFormat:@"dispensaries/%@/menu_items.json", ID] parameters:nil resultClass:[EELMenuItem class] resultKeyPath:@"" completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        block(responseObject, error);
    }];
}

#pragma mark Review Actions
- (void)getReviewsWithDispensaryID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(ID);
    
    [self GET:[NSString stringWithFormat:@"reviews/dispensary/%@", ID] parameters:nil resultClass:[EELReview class] resultKeyPath:@"" completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        block(responseObject, error);
    }];
}

- (void)postReviewForDispensaryWithID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(ID);
    
    // POST add-review
    if (!self.account){
        block(nil, [NSError errorWithDomain:@"NeedSignIn" code:0 userInfo:nil]);
        return;
    }else if(!self.account.confirmed){
        block(nil, [NSError errorWithDomain:@"NeedToConfirm" code:0 userInfo:nil]);
        return;
    }
    
}

- (void)deleteReviewWithID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(ID);

    // DELETE delete-review
    if (!self.account){
        block(nil, [NSError errorWithDomain:@"NeedSignIn" code:0 userInfo:nil]);
        return;
    }else if(!self.account.confirmed){
        block(nil, [NSError errorWithDomain:@"NeedToConfirm" code:0 userInfo:nil]);
        return;
    }
    
}

#pragma mark -
#pragma mark Smokin On Actions
- (void)getSmokinOnListWithCompletionBlock:(void (^)(NSArray *results, NSError *error))block{
    CLLocationCoordinate2D coords = [MTLocationManager sharedInstance].lastKnownLocation.coordinate;
    
    NSDictionary *params = @{
                             @"lat"  : [NSString stringWithFormat:@"%f", coords.latitude ?: 37.773972],
                             @"lng"  : [NSString stringWithFormat:@"%f", coords.longitude ?: -122.431297],
                             @"l"    : @"50"
                             };
    
    [self GET:@"smoking" parameters:params resultClass:[EELSmokinOn class] resultKeyPath:@"" completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        block(responseObject, error);
    }];
}

- (void)postSmokinOnStatus:(NSString*)status completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(status);

    // POST smoking-post
    if (!self.account){
        block(nil, [NSError errorWithDomain:@"NeedSignIn" code:0 userInfo:nil]);
        return;
    }else if(!self.account.confirmed){
        block(nil, [NSError errorWithDomain:@"NeedToConfirm" code:0 userInfo:nil]);
        return;
    }
    
}

#pragma mark -
#pragma mark Account Actions

// this may need to use NSURLSession instead.
- (void)loginAccountWithUsername:(NSString*)username password:(NSString*)password completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(username);
    NSParameterAssert(password);

    NSDictionary *params = @{
                             @"agent": @"iphone",
                             @"username" : username,
                             @"password" : password};
    
    [self POST:@"login" parameters:params resultClass:[EELAccount class] resultKeyPath:@"" completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        
        // if successful, setup the account in the singleton
        // or do something, not sure yet. i think they use cookies
        // post a notice stating we are logged in
        self.account = responseObject;
        
        block(responseObject, error);
    }];
}

- (void)registerAccountWithUsername:(NSString*)username password:(NSString*)password completionBlock:(void (^)(NSArray *results, NSError *error))block{}

- (void)logoutAccount{
    // post a notice stating we are logged out
    self.account = nil;
}

- (void)getAccountWithID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(ID);

    [self GET:[NSString stringWithFormat:@"user/id/%@", ID] parameters:nil resultClass:[EELAccount class] resultKeyPath:@"info" completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        block(responseObject, error);
    }];
}

- (void)getFavoritesWithAccountID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(ID);
    
    if (!self.account){
        block(nil, [NSError errorWithDomain:@"NeedSignIn" code:0 userInfo:nil]);
        return;
    }

    [self GET:@"favorites" parameters:@{@"user_id": ID} resultClass:[EELDispensary class] resultKeyPath:@"hits" completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        block(responseObject, error);
    }];
}

- (void)getReviewsWithAccountID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(ID);
    
    if (!self.account){
        block(nil, [NSError errorWithDomain:@"NeedSignIn" code:0 userInfo:nil]);
        return;
    }
    
    [self GET:@"user/reviews" parameters:nil resultClass:[EELReview class] resultKeyPath:@"hits" completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        block(responseObject, error);
    }];
}

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
