//
//  EELLeaflyClient.m
//  weedly
//
//  Created by Eric LEwis on 8/19/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELLeaflyClient.h"

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
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [configuration setHTTPAdditionalHeaders:@{
                                              @"app_id"  : @"77cf69e2",
                                              @"app_key" : @"05f80bbbc14826df4a7c14b38b854732"
                                              }];

    return [super initWithBaseURL:[NSURL URLWithString:@"http://data.leafly.com"] sessionConfiguration:configuration];
}

- (void)getStrainWithName:(NSString*)name completionBlock:(void (^)(EELStrain *result, NSError *error))block{
    NSParameterAssert(name);
    
    NSString *correctedName = [[name stringByReplacingOccurrencesOfString:@" " withString:@"-"] lowercaseString];
    
    [self GET:[NSString stringWithFormat:@"strains/%@", correctedName] parameters:nil completion:^(OVCResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            block(response.result, error);
        });
    }];
}

#pragma mark - Overcoat
+ (NSDictionary *)modelClassesByResourcePath {
    return @{
             @"strains/*": [EELStrain class],
             };
}

@end
