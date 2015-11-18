//
//  NTESRegisterManager.m
//  NIM
//
//  Created by amao on 8/7/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESRegisterManager.h"
#import "NTESDemoConfig.h"
#import "AFNetworking.h"
#import "NSDictionary+NTESJson.h"

@implementation NTESRegisterData



@end

@implementation NTESRegisterManager
+ (instancetype)sharedManager
{
    static NTESRegisterManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESRegisterManager alloc] init];
    });
    return instance;
}

- (void)registerUser:(NTESRegisterData *)data
          completion:(NTESRegisterHandler)completion
{
    NSAssert([[NIMSDK sharedSDK] isUsingDemoAppKey], @"只有 demo appKey 才能够使用这个注册接口");
    
    NSString *urlString = [[[NTESDemoConfig sharedConfig] apiURL] stringByAppendingString:@"/createDemoUser"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30];
    [request setHTTPMethod:@"Post"];
    
    [request addValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[[NIMSDK sharedSDK] appKey] forHTTPHeaderField:@"appkey"];
    
    NSString *postData = [NSString stringWithFormat:@"username=%@&password=%@&nickname=%@",[data account],[data token],[data nickname]];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger statusCode = operation.response.statusCode;
        NSError *error = [NSError errorWithDomain:@"ntes domain"
                                             code:statusCode
                                         userInfo:nil];
        if (statusCode == 200 && [responseObject isKindOfClass:[NSData class]]) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:0
                                                                   error:nil];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSInteger res = [dict jsonInteger:@"res"];
                if (res == 200) {
                    error = nil;
                }
                else
                {
                    error = [NSError errorWithDomain:@"ntes domain"
                                                code:res
                                            userInfo:nil];
                }
                DDLogDebug(@"register response %@",dict);
            }
        }
        if (completion) {
            completion(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
    [op start];
}
@end
