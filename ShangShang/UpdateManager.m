//
//  UpdateManager.m
//  SmurfApp
//
//  Created by 史东杰 on 14-5-23.
//  Copyright (c) 2014年 史东杰. All rights reserved.
//



#import "UpdateManager.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

@implementation UpdateManager

- (id)initwithType:(sandboxItemtype)Type
{
    self = [super init];
    if (self) {
        NSString* documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        _filePath= [[NSString alloc]initWithString:[documentsDirectory stringByAppendingPathComponent:@"smurfConfig.txt"]];
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
}
- (void)cleanText
{
    NSMutableData *writer = [[NSMutableData alloc]init];
    [writer appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
    [writer writeToFile:_filePath atomically:NO];
    [writer release];
}
#pragma mark - JsonAnalyze
- (NSDictionary *)transformDatatodic:(NSData *)reader
{
    NSObject *obj=[[CJSONDeserializer deserializer] deserialize:reader error:nil];
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dic = (NSDictionary *)obj;
        return  dic;
    }
    return nil;
}
- (NSData *)transformDictodata:(NSDictionary *)dic
{
    NSObject *obj=[[CJSONSerializer serializer]serializeObject:dic error:nil];
    if([obj isKindOfClass:[NSData class]])
    {
        NSData* data = (NSData *)obj;
        return  data;
    }
    return nil;
}
#pragma mark - FilePart
- (NSString *)getObjectbykey:(NSString *)key
{
    NSData *reader = [NSData dataWithContentsOfFile:_filePath];
    return [[self transformDatatodic:reader] objectForKey:key];
}
- (void)addObjectbykey:(NSString *)key value:(NSString *)value
{
    NSData *reader = [NSData dataWithContentsOfFile:_filePath];
    NSDictionary *dic=[[NSMutableDictionary dictionary] retain];
    dic=[[NSMutableDictionary alloc]initWithDictionary:[self transformDatatodic:reader]];
    [dic setValue:value forKey:key];
    NSData *write=[self transformDictodata:(NSDictionary *)dic];
    [write writeToFile:_filePath atomically:NO];
    
}
- (void)updateValuebykey:(NSString *)key value:(NSString *)value
{
    NSData *reader = [NSData dataWithContentsOfFile:_filePath];
    NSDictionary *dic=[[NSMutableDictionary dictionary] retain];
    dic=[[NSMutableDictionary alloc]initWithDictionary:[self transformDatatodic:reader]];
    [dic setValue:value forKey:key];
    NSData *write=[self transformDictodata:(NSDictionary *)dic];
    [write writeToFile:_filePath atomically:NO];
}
- (void)removeObjectbykey:(NSString *)key
{
    NSData *reader = [NSData dataWithContentsOfFile:_filePath];
    NSMutableDictionary *dic=[[NSMutableDictionary dictionary] retain];
    dic=[[NSMutableDictionary alloc]initWithDictionary:[self transformDatatodic:reader]];
    [dic removeObjectForKey:key];
}
#pragma mark - PicturePart
- (void)savePicturefromurl:(NSString *)url path:(NSString *)path imgName:(NSString *)imgName
{
    UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    [self savePicturefromimage:img path:path imgName:imgName];
}

- (void)savePicturefromimage:(UIImage *)image path:(NSString *)path imgName:(NSString *)imgName
{
    if(path==nil)
    {
        path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:imgName];
    }
    [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
    [self addObjectbykey:imgName value:path];
}
-(UIImage *)getImagefrompath:(NSString *)path
{
    return [[UIImage alloc]initWithContentsOfFile:path];
}

@end
