//
//  SmurfClass.h
//  ShangShang
//
//  Created by 史东杰 on 14-7-30.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmurfClass : NSObject
{
    NSString *classId_;
    NSString *className_;
    NSString *teacherName_;
    NSString *classDescription_;
}

@property (nonatomic, retain) NSString *classId;
@property (nonatomic, retain) NSString *className;
@property (nonatomic, retain) NSString *teacherName;
@property (nonatomic, retain) NSString *classDescription;
@property (nonatomic, assign) BOOL needVerify;
@property (nonatomic, assign) NSNumber *capacity;
@end
