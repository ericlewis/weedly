//
//  EELLeaflyClient.m
//  weedly
//
//  Created by Eric LEwis on 8/19/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELLeaflyClient.h"
#import "EELLeaflyResponse.h"

@implementation EELLeaflyClient

+ (instancetype)sharedClient {
    static EELLeaflyClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[EELLeaflyClient alloc] init];
        [_sharedClient setRequestSerializer:[AFJSONRequestSerializer serializer]];
    });
    
    return _sharedClient;
}

- (id)init {
    return [super initWithBaseURL:[NSURL URLWithString:@"http://data.leafly.com"]];
}

#pragma mark - Overcoat
+ (NSDictionary *)modelClassesByResourcePath {
    return @{
             @"strains/*": [EELDispensary class],
             };
}

+ (Class)responseClass {
    return [EELLeaflyResponse class];
}

@end
