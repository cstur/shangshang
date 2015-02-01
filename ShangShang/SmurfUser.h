//
//  SmurfUser.h
//  ShangShang
//
//  Created by 史东杰 on 14/12/15.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SmurfUser : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSNumber * grade;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isEnable;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSNumber * pictureId;
@property (nonatomic, retain) NSNumber * role;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSNumber * space;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * vip;
@property (nonatomic, retain) NSNumber * voteScore;

@end
