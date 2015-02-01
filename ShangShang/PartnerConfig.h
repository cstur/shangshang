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
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANyBUuriaee5CnzE3mTbjHp9BLbFA+8tyLsCTkXq+FbFTmhESFmt+alGYfbR3zZ8p0NeC+xCvxoBXpykQQvNdRfs41VfkcrnqS3ROQuVZc0q6AEFxEBzjT3TA+R1gqGICiE9TrAg/N4dk2s12ou3akPvHlBPOgTcQ8goNnoKXdmxAgMBAAECgYBXrYiV4v9vZ1F3OSSg//eEwO896WreENtvGMSc4ohqoDvEE9qc5iOOnnDXnq3d0YUEsYGWKRgps/+1004V7lUvOAaqvFe4oOIYbclkYu9fXYlAA307NreIMNOO/zsZgWvyemyKy1vkvmMTZanrkKyJD/67aq2wO4fUygdPfWYsTQJBAPrFuKpGiVkMFt/Y8rN2GEd5HJBS/+7gKjZsTpXh2Ae1bQDi88KLz9FzqagJAu2qGSu51qwr3eOhnidLcgAZX38CQQDhGhPwtsnRY53xi00Du5kO7VwCBPnxtCubnLmdZQf51nfp8wcjqKDgXi3TR6d41JzzWsZjAK9BaHIcsvEft17PAkBy9BP0qiTn1uzda/vFXEtA6Dm5xvJfNA7lp7xWZJK85eOz1lVbRu/a2aRZzNe0zpZ/Ps8zWWB7qmhvJtx5QyhNAkEAx2AwrzFHWiXQnEOUqCy96aHEr6k2tKWvRjovkUAOK3SRa26tMSFHtNLV5d/+bqBqj4UkWEYf9GANSmwX886XswJBAIuQu037P9GGn8ZYYjyGwY+Sa4mYapoRrowT+Vnbwu7CjqG8c4fDjNzlUR0b37uxbGwC5stmamePkog+6pMRUJY="


//支付宝公钥
#define AlipayPubKey   @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB-----END PUBLIC KEY-----"

#endif
