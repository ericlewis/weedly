//
//  EELAccount.h
//  weedly
//
//  Created by 1debit on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

@interface EELAccount : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (copy, nonatomic, readonly) NSNumber *id;
@property (copy, nonatomic, readonly) NSString *username;
@property (copy, nonatomic, readonly) NSString *email;
@property (copy, nonatomic, readonly) NSURL    *photo;

@end
