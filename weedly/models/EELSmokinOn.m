//
//  EELSmokinOn.m
//  weedly
//
//  Created by Eric Lewis on 5/3/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELSmokinOn.h"

#define kAPIDateFormat @"yyyy-MM-dd'T'HH:mm:ssz"

@implementation EELSmokinOn

+ (NSDictionary*) overrideKeysForMapping {
    return @{
             @"u" : @"name",
             @"s" : @"status",
             @"c" : @"timeAgo",
             @"photo_url" : @"photo"
             };
}

- (NSString*)formattedStatusString{
    NSAttributedString *formattedName = [[NSAttributedString alloc] initWithData:[self.status dataUsingEncoding:NSUTF8StringEncoding]
                                                                         options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    
    return formattedName.string;
}

@end
