//
//  NTESHttpRequest.h
//  NIM
//
//  Created by amao on 2/10/14.
//  Copyright (c) 2014 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

enum NTESHttpRequestCode
{
    kNIMHttpRequestCodeInvalidToken  = -501,     //token失效
    kNIMHttpRequestCodeDecryptError  = -502,     //解密出错
    
    kNIMHttpRequestCodeSuccess       = 200,      //请求成功
    kNIMHttpRequestCodeFailed        = 404,      //请求失败
    
    kNIMHttpRequestCodeTimeout       = 2000,     //请求超时
};

typedef void(^NTESCompleteBlock)(NSInteger responseCode, NSDictionary *responseData);


@interface NTESHttpRequest : NSObject
@property (nonatomic,strong)    NSData      *responseData;  //已解密的Response
@property (nonatomic,assign)    NSInteger   responseCode;   //Http返回Code

+ (NTESHttpRequest *)requestWithURL: (NSURL *)url;
- (void)setPostDict: (NSDictionary *)dict;
- (void)setPostJsonData: (NSData *)data;

- (void)startAsyncWithComplete:(NTESCompleteBlock)result; //返回已解密后的data
@end
