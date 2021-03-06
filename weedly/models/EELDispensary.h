//
//  EELDispensary.h
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELStoreHours.h"

@interface EELDispensary : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (copy, nonatomic, readonly) NSNumber *id;
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *phone;
@property (copy, nonatomic, readonly) NSString *address;
@property (copy, nonatomic, readonly) NSString *city;
@property (copy, nonatomic, readonly) NSString *state;
@property (copy, nonatomic, readonly) NSString *zip;
@property (copy, nonatomic, readonly) NSString *icon;
@property (copy, nonatomic, readonly) NSString *license;
@property (copy, nonatomic, readonly) NSString *typeString;
@property (copy, nonatomic, readonly) NSArray *hours;
@property (copy, nonatomic, readonly) EELStoreHours *todaysHours;

@property (copy, nonatomic, readonly) NSString *isOpen;
@property (copy, nonatomic, readonly) NSString *closesAt;
@property (copy, nonatomic, readonly) NSString *opensAt;

@property (copy, nonatomic) NSNumber *currentDistance;

@property (nonatomic, readonly) double lng;
@property (nonatomic, readonly) double lat;

@property (nonatomic, readonly) double rating;
@property (nonatomic, readonly) int ratingCount;

@property (nonatomic, readonly) int type;
@property (nonatomic, readonly) BOOL isDelivery;
@property (nonatomic, readonly) BOOL creditCardsAccepted;
@property (nonatomic, readonly) BOOL hasHandicapAccess;
@property (nonatomic, readonly) BOOL hasGuard;
@property (nonatomic, readonly) BOOL hasTesting;
@property (nonatomic, readonly) BOOL hasLounge;

@property (nonatomic, getter=isFavorite) BOOL favorite;

- (NSString*)formattedNameString;
- (NSString*)formattedTypeString;
- (NSString*)formattedAddressString;
- (NSString*)formattedPhoneString;
- (EELStoreHours*)hoursForDay:(NSString*)dayOTW;

@end
