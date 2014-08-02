//
//  EELDispensary.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELDispensary.h"

@interface EELYTimeOfDay : NSObject

@property (nonatomic, assign) uint8_t hour;
@property (nonatomic, assign) uint8_t minute;
@property (nonatomic, assign) BOOL isAnteMerdiem; /* AM */

- (uint32_t) unixTime;

@end

@implementation EELYTimeOfDay

- (void) setHour:(uint8_t)hour {
    if (hour == 12) {
        _hour = 0;
    } else {
        _hour = hour;
    }
}

- (uint32_t) unixTime {
    uint32_t ret = 0;
    if (!self.isAnteMerdiem) {
        ret = ret + 12 * 60 * 60; /* 12 hours forward */
    }
    ret = ret + self.hour * 60 * 60;
    ret = ret + self.minute * 60;
    return ret;
}

- (instancetype) initWithString:(NSString*)string {
    self = [super init];
    NSArray* components = [string componentsSeparatedByString:@":"];
    self.isAnteMerdiem = ![[[components[1] substringWithRange:NSMakeRange(2, 2)] uppercaseString] isEqualToString:@"PM"];
    self.hour = (uint8_t)[components[0] intValue];
    self.minute = (uint8_t)[[components[1] substringWithRange:NSMakeRange(0, 2)] intValue];
    return self;
}

@end

@implementation EELDispensary

NSString * const EELDispensaryFavoriteToggledNotificationName = @"EELDispensaryFavoriteToggledNotificationName";

- (NSUInteger)hash
{
    NSUInteger prime = 31;
    NSUInteger result = 1;
    
    result = prime * result + [self.name hash];
    result = prime * result + [[self formattedTypeString] hash];
    return result;
}

- (void)setFavorite:(BOOL)favorite
{
    if (_favorite == favorite)
        return;
    
    _favorite = favorite;
    
    // Let everyone know our favorite status has changed.
    [[NSNotificationCenter defaultCenter] postNotificationName:EELDispensaryFavoriteToggledNotificationName object:self];
}

- (NSString*)formattedNameString{
    NSAttributedString *formattedName = [[NSAttributedString alloc] initWithData:[self.name dataUsingEncoding:NSUTF8StringEncoding]
                                                                         options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    
    return formattedName.string;
}

- (NSString*)formattedTypeString{
    NSString *dispensaryType  = self.icon;
    
    // disps
    if (self.type == 0 && !self.isDelivery) {
        dispensaryType = @"Dispensary";
    }else if(self.type == 0 && self.isDelivery){
        dispensaryType = @"Delivery";
    }
    
    // doctors
    else if(self.type == 1){
        dispensaryType = @"Doctor";
    }
    
    return dispensaryType.capitalizedString;
}

- (NSString*)formattedAddressString{
    NSString *cleanState = self.state;
    NSString *cleanAddress = [self.address stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    // long state name, change to short one
    if (self.state.length > 2) {
        cleanState = [cleanState stateAbbreviationFromFullName];
    }
    
    // delivery
    if ([self.icon isEqualToString:@"delivery"] || [cleanAddress isEqualToString:@"--"]) {
        return [NSString stringWithFormat:@"%@, %@", self.city.capitalizedString, cleanState.uppercaseString];
    }
    
    return [NSString stringWithFormat:@"%@, %@, %@", cleanAddress, self.city.capitalizedString, cleanState.uppercaseString];
}

- (NSString*)formattedPhoneString{
    return [self formatPhoneNumber:self.phone deleteLastChar:NO];
}

-(NSString*)formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar{
    if(simpleNumber.length==0) return @"";
    
    simpleNumber = [[simpleNumber componentsSeparatedByCharactersInSet:
                     [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                    componentsJoinedByString:@""];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    // check if the number is top long
    if(simpleNumber.length>10) {
        simpleNumber = [simpleNumber substringToIndex:10];
    }
    
    if(deleteLastChar) {
        // should we delete the last digit?
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    // 123 456 7890
    // format the number.. if it's less then 7 digits.. then use this regex.
    if(simpleNumber.length<7)
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
                                                               withString:@"($1) $2"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    
    else   // else do this one..
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
                                                               withString:@"($1) $2-$3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    return simpleNumber;
}

#pragma mark - JSON serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id"          : @"_source.id",
             @"name"        : @"_source.name",
             @"address"     : @"_source.address",
             @"city"        : @"_source.city",
             @"state"       : @"_source.state",
             @"zip"         : @"_source.zip_code",
             @"rating"      : @"_source.rating",
             @"ratingCount" : @"_source.reviews_count",
             @"typeString"  : @"_type",
             @"lng"         : @"_source.longitude",
             @"lat"         : @"_source.latitude",
             @"phone"       : @"_source.phone_number",
             @"license"     : @"_source.license_type",
             @"isDelivery"  : @"_source.is_delivery",
             @"hours"       : @"_source.hours",
             
             // these no longer apply with the new searching api [fix this]
             //@"closesAt"    : @"_source.todaysHours.closes_at",
             //@"opensAt"     : @"_source.todaysHours.opens_at",
             //@"isOpen"      : @"_source.is_open",
             };
}

+ (NSValueTransformer *)photoURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark - Managed object serialization

+ (NSString *)managedObjectEntityName {
    return @"Dispensary";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{};
}

+ (NSValueTransformer *)photoURLEntityAttributeTransformer {
    return [[NSValueTransformer valueTransformerForName:MTLURLValueTransformerName] mtl_invertedTransformer];
}

+ (NSValueTransformer *)hoursJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[EELStoreHours class]];
}

#pragma mark - custom getters

- (int)type{
    if ([self.typeString isEqualToString:@"doctor"]) {
        return 1;
    }else if([self.typeString isEqualToString:@"dispensary"]){
        return 0;
    }
    
    return 2;
}

- (NSString*) isOpen {

    EELYTimeOfDay* start = [[EELYTimeOfDay alloc] initWithString:self.opensAt];
    EELYTimeOfDay* close = [[EELYTimeOfDay alloc] initWithString:self.closesAt];
    
    NSDate* currentDate = [NSDate date];
    EELYTimeOfDay* now = [[EELYTimeOfDay alloc] init];
    now.hour = currentDate.hour;
    now.minute = currentDate.minute;
    now.isAnteMerdiem = YES; /* it's in 24-hour mode, so always AM */
    
    NSLog(@"Start: %d Now: %d Closes: %d", [start unixTime], [now unixTime], [close unixTime]);
    
    if ([start unixTime] <= [now unixTime] && [now unixTime] <= [close unixTime]) {
        return @"YES"; /* traditional time */
    }
    if ([start unixTime] == [close unixTime]) {
        return @"YES"; /* 24-hours */
    }
    if ([close unixTime] <= [start unixTime] && ([now unixTime] <= [close unixTime] || [now unixTime] >= [start unixTime])) {
        return @"YES"; /* wraps over midnight */
    }
    return @"NO";
}

- (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    return [date compare:firstDate] == NSOrderedDescending && [date compare:lastDate]  == NSOrderedAscending;
}

- (NSString*) closesAt{
    return [self.todaysHours.closesAt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString*) opensAt{
    return [self.todaysHours.opensAt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (EELStoreHours*)todaysHours {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE"];
    
    for (int i = 0; self.hours.count > i; i++) {
        EELStoreHours *hours = self.hours[i];
        if ([hours.dayOTW isEqualToString:[[dateFormatter stringFromDate:[NSDate date]] lowercaseString]]) {
            return hours;
        }
    }
    
    return nil;
}

@end
