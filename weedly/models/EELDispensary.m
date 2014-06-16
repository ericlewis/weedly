//
//  EELDispensary.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELDispensary.h"

@implementation EELDispensary

- (NSUInteger)hash
{
    NSUInteger prime = 31;
    NSUInteger result = 1;
    
    result = prime * result + [self.name hash];
    result = prime * result + [[self formattedTypeString] hash];
    return result;
}

- (NSURL*) formattedPhotoURL {
    NSString *urlString = self.photoURL.absoluteString;
    [urlString stringByReplacingOccurrencesOfString:@"/square_" withString:@"/"];
    return [NSURL URLWithString:urlString];
}

- (NSString*)formattedNameString{
    NSAttributedString *formattedName = [[NSAttributedString alloc] initWithData:[self.name dataUsingEncoding:NSUTF8StringEncoding]
                                                                         options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    
    return formattedName.string;
}

- (NSString*)formattedTypeString{
    NSString *dispensaryType  = self.icon;
    
    // disps
    if (self.type == 0) {
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"gold" withString:@"Dispensary"];
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"silver" withString:@"Dispensary"];
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"bronze" withString:@"Dispensary"];
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"lp" withString:@"Dispensary"];
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"free" withString:@"Dispensary"];
    }
    
    // doctors
    else if(self.type == 1){
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"lp" withString:@"Doctor"];
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"free" withString:@"Doctor"];
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"bronze" withString:@"Doctor"];
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"silver" withString:@"Doctor"];
        dispensaryType = [dispensaryType stringByReplacingOccurrencesOfString:@"gold" withString:@"Doctor"];
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

+ (NSDictionary*) overrideKeysForMapping {
    return @{
             @"n" : @"name",
             @"a" : @"address",
             @"c" : @"city",
             @"r" : @"rating",
             @"rc" : @"ratingCount",
             @"marker" : @"icon",
             @"longitude" : @"lng",
             @"latitude" : @"lat",
             @"photo1" : @"photoURL",
             @"license_type" : @"license",
             @"todaysHours.closes_at" : @"closesAt",
             @"todaysHours.opens_at" : @"opensAt",
             @"todaysHours.day_of_the_week" : @"dayOTW"
             };
}

@end
