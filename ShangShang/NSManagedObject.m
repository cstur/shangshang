//
//  NSManagedObject.m
//  ShangShang
//
//  Created by 史东杰 on 14/12/15.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "NSManagedObject.h"

@implementation NSManagedObject (safeSetValuesKeysWithDictionary)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter
{
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in attributes) {
        id value = [keyedValues objectForKey:attribute];
        if (value == nil) {
            continue;
        }
        
        NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
        
        if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
            value = [value stringValue];
        } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithInteger:[value integerValue]];
        } else if ((attributeType == NSFloatAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithDouble:[value doubleValue]];
        } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]]) && (dateFormatter != nil)) {
            value = [dateFormatter dateFromString:value];
        }
        [self setValue:value forKey:attribute];
    }
}

-(NSMutableDictionary*)getDictionary{
    NSMutableDictionary *fields = [NSMutableDictionary dictionary];
    for (NSAttributeDescription *attribute in [[self entity] properties]) {
        NSString *attributeName = attribute.name;
        id attributeValue = [self valueForKey:attributeName];
        if (attributeValue) {
            [fields setObject:attributeValue forKey:attributeName];
        }
    }
    return fields;
}

@end
