//
//  EELLeaflyClient.h
//  weedly
//
//  Created by Eric Lewis on 8/19/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

@interface EELLeaflyClient : OVCHTTPSessionManager

+ (instancetype)sharedClient;

- (void)getStrainWithName:(NSString*)name completionBlock:(void (^)(EELStrain *result, NSError *error))block;

@end
