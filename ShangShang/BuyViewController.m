//
//  BuyViewController.m
//  ShangShang
//
//  Created by 史东杰 on 14-7-30.
//  Copyright (c) 2014年 aopai.ios. All rights reserved.
//

#import "BuyViewController.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"

@interface BuyViewController ()

@end

@implementation BuyViewController
@synthesize result = _result;
@synthesize loadingView = _loadingView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateui];
}

-(void)viewWillAppear:(BOOL)animated{
    /*
    if(!_loadingView)
    {
        _loadingView = [[UIView alloc] initWithFrame:self.view.frame];
        [_loadingView setBackgroundColor:[UIColor lightGrayColor]];
        
        UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [actInd setFrame:CGRectMake((_loadingView.frame.size.width / 2 - 10), (_loadingView.frame.size.height / 2 - 10), 20, 20)];
        
        UILabel *lblLoading = [[UILabel alloc] initWithFrame:CGRectMake((_loadingView.frame.size.width / 2 - 30), (_loadingView.frame.size.height / 2 - 5), 60, 30)];
        lblLoading.text = @"Loading";
        
        // you will probably need to adjust those frame values to get it centered
        
        [_loadingView addSubview:actInd];
        [_loadingView addSubview:lblLoading];
        
        [actInd startAnimating];
    }
    
    [self.tableView addSubview:_loadingView];
    [_loadingView setHidden:NO];
     */
}

-(void)updateui{
    HttpUtil *httpUtil=[[HttpUtil alloc] init];
    NSString* url = [NSString stringWithFormat:@"SmurfWeb/rest/ios/resource?userid=%@",[SSUser getInstance].userid];
    [httpUtil GetAsynchronous:url withDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                NSDictionary *body= [NSDictionary dictionaryWithObjectsAndKeys:
                                     [SSUser getInstance].userid,@"userid",
                                     @"100",@"addspace",
                                     nil];
                if ([CommonUtil iosapi_addspace:body]) {
                    [self updateui];
                    [CommonUtil ShowAlert:@"购买成功" withDelegate:self];
                }else{
                    [CommonUtil ShowAlert:@"购买失败" withDelegate:self];
                }
			}
        }
        else
        {
            //交易失败
            [CommonUtil ShowAlert:@"购买失败" withDelegate:self];
        }
    }
    else
    {
        //失败
        [CommonUtil ShowAlert:@"购买失败" withDelegate:self];
    }
    
}


-(NSString*)getOrderInfo:(NSInteger)index
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
	//Product *product = [_products objectAtIndex:index];
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
	order.productName = @"云盘"; //商品标题
	order.productDescription = @"云盘"; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",0.10]; //商品价格
	order.notifyURL =  [NSString stringWithFormat:@"http://%@/restapi/gold", [ServerIP getConfigIP]]; //回调URL
	
	return [order description];
}

- (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[NSMutableString alloc] init] ;
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"%@",result);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row=[indexPath row];
    if (indexPath.section==0&&row==1) {

        NSString *appScheme = @"AlipaySdkDemo";
        NSString* orderInfo = [self getOrderInfo:indexPath.row];
        NSString* signedStr = [self doRsa:orderInfo];
        
        NSLog(@"%@",signedStr);
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                 orderInfo, signedStr, @"RSA"];
        
        [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
        /*
         NSDictionary *body= [NSDictionary dictionaryWithObjectsAndKeys:
         [SSUser getInstance].userid,@"userid",
         @"100",@"addspace",
         nil];
        if ([CommonUtil iosapi_addspace:body]) {
            [self updateui];
            [CommonUtil ShowAlert:@"购买成功" withDelegate:self];
        }else{
            [CommonUtil ShowAlert:@"购买失败" withDelegate:self];
        }*/
    }
    
    if (indexPath.section==1&&row==1) {
        [self addResource:@"class"];
    }
    
    if (indexPath.section==2&&row==1) {
        [self addResource:@"vote"];
    }
    
    if (indexPath.section==3&&row==1) {
        [self addResource:@"topic"];
    }
}

-(void)addResource:(NSString*)type{
    NSDictionary *body= [NSDictionary dictionaryWithObjectsAndKeys:
                         [SSUser getInstance].userid,@"userid",
                         type,@"type",
                         @"1",@"add",
                         nil];
    if ([CommonUtil iosapi_addresource:body]) {
        [self updateui];
        [CommonUtil ShowAlert:@"购买成功" withDelegate:self];
    }else{
        [CommonUtil ShowAlert:@"购买失败" withDelegate:self];
    }
}

-(void)requestFinished:(ASIHTTPRequest*)request
{
    NSData *response = [request responseData];
    NSDictionary *obj=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    NSString *space=[obj objectForKey:@"space"];
    NSString *limit=[obj objectForKey:@"spacelimit"];
    long lspace=[[obj objectForKey:@"lspace"] longValue];
    NSLog(@"%ld",lspace);
    lspace=lspace/(1024*1024);
    float percent=lspace/[limit floatValue];
    self.labelSpace.text=[NSString stringWithFormat:@"容量(%@/%@M %0.2f%%)",space,limit,percent*100];
    [self.progressSapce setProgress:percent];
    
    int ClassCurrent=[[obj objectForKey:@"cclass"] intValue];
    int ClassLimit=[[obj objectForKey:@"classNumber"] intValue];

    self.labelClass.text=[NSString stringWithFormat:@"课程(%d/%d)",ClassCurrent,ClassLimit];
    [self.progressClass setProgress:(float)ClassCurrent/(float)ClassLimit];
    
    int topicCurrent=[[obj objectForKey:@"ctopic"] intValue];
    int topicLimit=[[obj objectForKey:@"topicNumber"] intValue];
    self.labelTopic.text=[NSString stringWithFormat:@"论题(%d/%d)",topicCurrent,topicLimit];
    [self.progressTopic setProgress:(float)topicCurrent/(float)topicLimit];
    
    int voteCurrent=[[obj objectForKey:@"cvote"] intValue];
    int voteLimit=[[obj objectForKey:@"voteNumber"] intValue];
    self.labelVote.text=[NSString stringWithFormat:@"投票(%d/%d)",voteCurrent,voteLimit];
    [self.progressVote setProgress:(float)voteCurrent/(float)voteLimit];
}

-(void)requestFailed:(ASIHTTPRequest*)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
}

- (void)dealloc {
    [_labelSpace release];
    [_progressSapce release];
    [_labelClass release];
    [_labelVote release];
    [_labelTopic release];
    [_progressClass release];
    [_progressVote release];
    [_progressTopic release];
    [_progressVote release];
    [super dealloc];
}
@end
