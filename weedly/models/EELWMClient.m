//
//  EELWMClient.m
//  weedly
//
//  Created by 1debit on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELWMClient.h"

// models
#import "EELDoctor.h"
#import "EELDispensary.h"

@implementation EELWMClient

- (id)init {
    return [super initWithBaseURL:[NSURL URLWithString:@"https://api.legalmarijuanadispensary.com/api/v4"]];
}

- (void)searchDoctorsWithTerm:(NSString *)term completionBlock:(void (^)(NSArray *results, NSError *error))block {
    [self searchWithType:@"doctor" model:[EELDoctor class] term:term completionBlock:block];
}

- (void)searchDispensariesWithTerm:(NSString *)term completionBlock:(void (^)(NSArray *results, NSError *error))block {
    [self searchWithType:@"dispensary" model:[EELDispensary class] term:term completionBlock:block];
}

#pragma mark -
#pragma mark Private
- (void)searchWithType:(NSString*)type model:(id)class term:(NSString*)term completionBlock:(void (^)(NSArray *results, NSError *error))block{
    NSParameterAssert(type);
    NSParameterAssert(term);
    NSParameterAssert(block);
    
    NSDictionary *parameters = @{
                                 @"type" : type,
                                 @"lat"  : @"0", // temp for now till i get location up and running
                                 @"lng"  : @"0"  // dittio
                                 };
    
    [self GET:@"search" parameters:parameters resultClass:class resultKeyPath:@"results" completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        block(responseObject, error);
    }];
}

@end
