//
//  EELStrain.m
//  weedly
//
//  Created by Eric LEwis on 8/19/14.
//  Copyright (c) 2014 Eric Lewis. All rights reserved.
//

#import "EELStrain.h"

@implementation EELStrain

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id"                 : @"id",
             @"name"               : @"name",
             @"description"        : @"description",
             @"descriptionPlain"   : @"descriptionPlain",
             @"symbol"             : @"symbol",
             @"category"           : @"category",
             @"aka"                : @"aka",
             @"flavors"            : @"flavors",
             @"effects"            : @"effects",
             @"symptoms"           : @"symptoms",
             @"conditions"         : @"conditions",
             @"negatives"          : @"negatives",
             };
}

+ (NSValueTransformer *)flavorsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[EELStrainInfo class]];
}

+ (NSValueTransformer *)effectsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[EELStrainInfo class]];
}

+ (NSValueTransformer *)symptomsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[EELStrainInfo class]];
}

+ (NSValueTransformer *)conditionsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[EELStrainInfo class]];
}

+ (NSValueTransformer *)negativesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[EELStrainInfo class]];
}

#pragma mark - Managed object serialization

+ (NSString *)managedObjectEntityName {
    return @"Strain";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return nil;
}

@end
