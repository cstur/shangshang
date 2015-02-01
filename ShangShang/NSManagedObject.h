//
//  NSManagedObject.h
//  ShangShang
//
//  Created by 史东杰 on 14/12/15.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject(safeSetValuesKeysWithDictionary)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter;
- (NSMutableDictionary*)getDictionary;
@end
