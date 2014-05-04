//
//  EELWMClient.m
//  weedly
//
//  Created by 1debit on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELWMClient.h"

// models
#import "EELAccount.h"
#import "EELDispensary.h"
#import "EELDoctor.h"
#import "EELReview.h"
#import "EELSmokinOn.h"

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

#pragma mark -
#pragma mark Smokin On Actions

#pragma mark -
#pragma mark Review Actions

#pragma mark -
#pragma mark Account Actions

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
