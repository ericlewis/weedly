//
//  EELWMClient.h
//  weedly
//
//  Created by 1debit on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

@interface EELWMClient : OVCClient

// users account for singleton usage
@property (nonatomic, strong) EELAccount *account;

+ (instancetype)sharedClient;

#pragma mark -
#pragma mark Search Actions
- (void)searchDoctorsWithTerm:(NSString *)term completionBlock:(void (^)(NSArray *results, NSError *error))block;
- (void)searchDispensariesWithTerm:(NSString *)term completionBlock:(void (^)(NSArray *results, NSError *error))block;
- (void)searchDoctorsWithTerm:(NSString *)term lat:(CGFloat)lat lng:(CGFloat)lng completionBlock:(void (^)(NSArray *results, NSError *error))block;
- (void)searchDispensariesWithTerm:(NSString *)term lat:(CGFloat)lat lng:(CGFloat)lng completionBlock:(void (^)(NSArray *results, NSError *error))block;

#pragma mark -
#pragma mark Merchant Actions
- (void)getDispensaryWithID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block;
- (void)getMenuItemsWithDispensaryID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block;

#pragma mark Review Actions
- (void)getReviewsWithDispensaryID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block;
- (void)postReviewForDispensaryWithID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block;
- (void)deleteReviewWithID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block;

#pragma mark -
#pragma mark Smokin On Actions
- (void)getSmokinOnListWithCompletionBlock:(void (^)(NSArray *results, NSError *error))block;
- (void)postSmokinOnStatus:(NSString*)status completionBlock:(void (^)(NSArray *results, NSError *error))block;

#pragma mark -
#pragma mark Account Actions
- (void)loginAccountWithUsername:(NSString*)username password:(NSString*)password completionBlock:(void (^)(NSArray *results, NSError *error))block;
- (void)registerAccountWithUsername:(NSString*)username password:(NSString*)password completionBlock:(void (^)(NSArray *results, NSError *error))block;
- (void)logoutAccount;
- (BOOL)isAccountLoggedIn;
- (BOOL)isAccountConfirmed;

- (void)getAccountWithID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block;
- (void)getReviewsWithAccountID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block;
- (void)getFavoritesWithAccountID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block;

@end
