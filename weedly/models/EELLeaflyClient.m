//
//  EELLeaflyClient.m
//  weedly
//
//  Created by Eric Lewis on 8/19/14.
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
    return [super initWithBaseURL:[NSURL URLWithString:@"http://api.leafly.com/api2"]];
}

- (void)getStrainWithName:(NSString*)name completionBlock:(void (^)(EELStrain *result, NSError *error))block{
    NSParameterAssert(name);
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\(.*\\)" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSString *correctedName = [[[[[[[regex stringByReplacingMatchesInString:name options:0 range:NSMakeRange(0, [name length]) withTemplate:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@"." withString:@""] stringByReplacingOccurrencesOfString:@"'" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@"-"] lowercaseString];
    NSLog(@"%@", correctedName);
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
