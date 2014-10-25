//
//  HttpUtil.m
//  SmurfApp
//
//  Created by 史东杰 on 14-5-23.
//  Copyright (c) 2014年 史东杰. All rights reserved.
//

#import "HttpUtil.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@implementation HttpUtil

-(id)init
{
    if(self=[super init])
    {
        server=  [ServerIP getConfigIP];
    }
    return self;
}

-(NSData*) SendGetRequest:(NSString*)str{
    NSString* urlStr=[NSString stringWithFormat:@"http://%@/%@",server,str];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSData *response = [request responseData];
        return response;
    }
    return nil;
}

+(NSString*)toJSONString:(id)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}

- (NSData *)toJSONData:(id)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

- (void)simpleJsonParsingPostMetod:(NSData*)imgData
{
    //UIDevice * dev = [UIDevice currentDevice];
    //NSString *uniqueId = dev.uniqueIdentifier;
    //NSString *name = @"photo1";
    //NSData *imageData = UIImageJPEGRepresentation(image.image, 90);
    //NSData * imageData = UIImagePNGRepresentation(image);
    // NSString *postLength = [NSString stringWithFormat:@"%d", [imageData length]];
    NSString *urlString = @"http://192.168.2.104:8018/SmurfWeb/View/UserServlet/?action=uploadattach&userid=100060";
    //urlString = [urlString stringByAppendingString:@"123213sdfsdfsdf"];
    //urlString = [urlString stringByAppendingString:@"&name="];
    //urlString = [urlString stringByAppendingString:name];
    //urlString = [urlString stringByAppendingString:@"&lang=en_US.UTF-8"];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSString *stringBoundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSMutableData *postBody = [NSMutableData data];
    
    
    
    //add data field and file data
    [postBody appendData:[NSData dataWithData:imgData]];
    
    //
    
    [request setHTTPBody:postBody];
    
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",returnString);
    /*
#warning set webservice url to "jsonUrlString" & parse GET or POST method in JSON before access methods
    
    //-- Temp Initialized variables
    NSString *first_name=@"11";
    NSString *last_name=@"22";
    NSString *image_name=@"33";
    NSData *imageData=imgData;
    
    //-- Convert string into URL
    NSString *urlString = [NSString stringWithFormat:@"http://localhost:8018/SmurfWeb/View/UserServlet/?action=uploadVideo"];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    //adding header information:
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setTimeoutInterval:60.0];
    NSString *stringBoundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //NSData *imageData =UIImagePNGRepresentation(self.convertImage);
    
    
    NSMutableData *postBody = [[NSMutableData alloc] init];
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"%@",@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:first_name];
    [postBody appendData:[[NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"%@",@"Content-Disposition: form-data; name=\"profilepic\"; filename=\"ipodfile.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[NSData dataWithData:imageData]];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postRequest setHTTPBody:postBody];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",returnString);*/
    /*
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
    
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        NSMutableData *receivedData = [[NSMutableData data] retain];
    }
    [postRequest release];*/
   /* NSMutableURLRequest *request =[[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //-- Append data into posr url using following method
    NSMutableData *body = [NSMutableData data];
    
    
    //-- For Sending text
    
    //-- "firstname" is keyword form service
    //-- "first_name" is the text which we have to send
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"firstname"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",first_name] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //-- "lastname" is keyword form service
    //-- "last_name" is the text which we have to send
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"lastname"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",last_name] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //-- For sending image into service (send as imagedata)
    
    //-- "image_name" is file name of the image (we can set custom name)
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"file\"; filename=\"%@\"\r\n",image_name] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //-- Sending data into server through URL
    [request setHTTPBody:body];
    
    //-- Getting response form server
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *error1 = [request error];

    //-- JSON Parsing with response data
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"Result = %@",result);*/
}


-(NSString*)SendPostRequest:(NSString *)str withBody:(id) obj{
    
    NSData *jsonData = [self toJSONData:obj];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON Output: %@", jsonString);
    
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    
    NSString* urlStr=[NSString stringWithFormat:@"http://%@/%@",server,str];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request setRequestMethod:@"POST"];
    [request setPostBody:tempJsonData];
    [request startSynchronous];
    NSError *error1 = [request error];
    if (!error1) {
        NSString *response = [request responseString];
        NSLog(@"Test：%@",response);
        return response;
    }
    
    return @"-1";
}

-(NSString*)SendPostRequestWithParam:(NSDictionary *)param withURL:(NSString*) urlShort{
    
    NSString* urlStr=[NSString stringWithFormat:@"http://%@/%@",server,urlShort];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];

    NSArray *keys = [param allKeys];
    
    // values in foreach loop
    for (NSString *key in keys) {
        //NSLog(@"%@ is %@",key, [dict objectForKey:key]);
        [request addRequestHeader:key value:[param objectForKey:key]];
    }
    [request setRequestMethod:@"POST"];
    [request startSynchronous];
    NSError *error1 = [request error];
    if (!error1) {
        NSString *response = [request responseString];
        NSLog(@"Test：%@",response);
        return response;
    }
    
    return @"-1";
}
@end
