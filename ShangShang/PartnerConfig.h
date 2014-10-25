//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088411818121959"
//收款支付宝账号
#define SellerID  @"15921584900@126.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"lfm3d5t6gsanxbf11fh9ghngi3p0i04f"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAOEgj0ZUGd0FouGcF2I9zfcFmO4yhVQ0yhujMxWytL65m7vsKyT51IkvY0MaK4Pw8gRpQs2wQspFIWYph8mcO0TmhfpB9mY8fdLFJcsADDHqqlQBCZZQbHtmt4A2RDU11g546cCinsquL2C6nzrXqnF2liJE+xrC6gjTaSxAWifrAgMBAAECgYBsUqxd3K2tKb8b621c+fwWtfzF8E0zHUt6TOaRtDE/7DNBEvwXiJZ5g/GxIfB6Rf9NnBBmxD7+8JCHhcgufBwPvaqrvG1k94FF6m5/5SXYkCGGJX/6CcMWvYUV8PQrWfGLymHQprK9VFAwBLzU1FALaXjqGPTwKPe+zEAk/Ul0IQJBAP5SsN5DFdUqYsYtGPgzH9ij3QZ917T1DGxMWDkxdntRCYl4mo3GlfcQwvx5S8Jj4nTsl+tVkAKNGg2Wf3cCUkMCQQDinJW5a3C0805jkbBUJSQDCc6lrU8dHyK6F1kafiWJbfc3Uuyh+ga1e8+ITR2wS0kg9qaaRoiTlWvTa+Ngxt05AkBYBBQ0B7GRoWanwUnH9CGMX0GKEplJhhkzjcRmnsirauNLEVMjx9t0svdYWz4t21WvM4ZsKqN5To36r+ATNtlzAkBNoyH0vaeGhxkjKcXEflkBJXoD7wV8z68BHICtf+xyUhdxf9qMf/GOedWXN/xk6tYqEfbwQhwGnBmt/HeRL3CZAkBcat5vZfk9w/J0RFaCvjFx2tth51Wmbc7apJ6oJW8xgx6Ax/Eg50OmhMRzNwjxYfkFkDhfI5Es1QDUj7gfx2tc"


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
