//
//  EELAccount.h
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

@interface EELAccount : NSObject

@property (copy, nonatomic, readonly) NSNumber *id;
@property (copy, nonatomic, readonly) NSString *username;
@property (copy, nonatomic, readonly) NSString *email;
@property (copy, nonatomic, readonly) NSString *session;
@property (copy, nonatomic, readonly) NSURL    *photo;

@property (nonatomic, readonly) BOOL confirmed;

@end
