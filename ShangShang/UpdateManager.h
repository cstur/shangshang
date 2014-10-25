//
//  UpdateManager.h
//  SmurfApp
//
//  Created by 史东杰 on 14-5-23.
//  Copyright (c) 2014年 史东杰. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    item = 0 ,
    image = 1 ,
} sandboxItemtype;


@interface UpdateManager : NSObject {
    sandboxItemtype _itemType;//存储信息类型，暂时没用上
    NSString *_filePath;//记录更新日志存储路径
}
- (id)initwithType:(sandboxItemtype)Type;//初始化
- (NSString *)getObjectbykey:(NSString *)key;//根据关键字获取值
- (UIImage *)getImagefrompath:(NSString *)path;//根据路径获取图像
- (NSData *)transformDictodata:(NSDictionary *)dic;//json解析将字典转化成数据
- (NSDictionary *)transformDatatodic:(NSData *)reader;//json解析将数据转化成字典

- (void)cleanText;//清空更新日志
- (void)removeObjectbykey:(NSString *)key;//根据关键字删除记录
- (void)addObjectbykey:(NSString *)key value:(NSString *)value;//添加记录
- (void)updateValuebykey:(NSString *)key value:(NSString *)value;//更新记录
- (void)savePicturefromurl:(NSString *)url path:(NSString *)path imgName:(NSString *)imgName;//根据url将图片下载并保至沙盒，同时记录在更新日志中
- (void)savePicturefromimage:(UIImage *)image path:(NSString *)path imgName:(NSString *)imgName;//
@end
