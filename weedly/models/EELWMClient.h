//
//  EELWMClient.h
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

@interface EELWMClient : OVCHTTPSessionManager

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
- (void)getMenuWithDispensaryID:(NSString*)ID completionBlock:(void (^)(EELMenu *result, NSError *error))block;
- (void)getMenuItemsWithDispensaryID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block;

#pragma mark Review Actions
- (void)getReviewsWithDispensaryID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block;
- (void)getReviewsWithDoctorID:(NSString*)ID completionBlock:(void (^)(NSArray *results, NSError *error))block;

#pragma mark - Offers API
- (void) getDealsAround:(CLLocation*)location completionBlock:(void(^)(NSArray*, NSError*))block;

@end
