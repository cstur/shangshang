//
//  ImageUtil.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-27.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtil : NSObject
-(NSData *)dataFromBase64EncodedString:(NSString *)string;
- (NSString *)encodeToBase64String:(UIImage *)image ;
@end
