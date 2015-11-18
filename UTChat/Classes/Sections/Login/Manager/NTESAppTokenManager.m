//
//  NTESAppTokenManager.m
//  NIM
//
//  Created by amao on 6/11/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESAppTokenManager.h"
#import "NTESDemoConfig.h"
#import "AFNetworking.h"
#import "NSString+NTES.h"
#import "NTESLoginManager.h"

@implementation NTESAppToken
@end

@interface NTESAppTokenManager ()
@property (nonatomic,strong)    NTESAppToken *token;
@end

@implementation NTESAppTokenManager

+ (instancetype)sharedManager
{
    static NTESAppTokenManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESAppTokenManager alloc] init];
    });
    return instance;
}

- (NTESAppToken *)appToken
{
    return _token;
}

- (void)fetchToken:(NTESFetchTokenBlock)completion
{
    LoginData *data = [[NTESLoginManager appManager] currentLoginData];
    NSString *username = [data account];
    NSString *password = [data token];
    [self fetchTokenBy:username
              password:password
            completion:completion];
}

- (void)fetchTokenBy:(NSString *)username
            password:(NSString *)password
          completion:(NTESFetchTokenBlock)completion
{
    
    if ([username length] == 0 || [password length] == 0)
    {
        if (completion) {
            completion(nil);
            DDLogDebug(@"fetch code param error %@ %@",username,password);
        }
        return;
    }
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@/token", [[NTESDemoConfig sharedConfig] apiURL]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *param = @{@"userid": username,
                            @"secret": [password MD5String],
                            @"client_type": @(0)};
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:0 error:0];
    [request setHTTPBody:data];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NTESAppToken *token = nil;
        NSInteger code = operation.response.statusCode;
        NSData *data = operation.responseData;
        if (code == 200 && data)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:0];
            DDLogDebug(@"fetch code result %@",dict);
            if (dict)
            {
                NSString *accessToken = dict[@"msg"][@"access_token"];
                NSString *sdkToken = dict[@"msg"][@"sdktoken"];
                if (accessToken && sdkToken)
                {
                    token = [[NTESAppToken alloc] init];
                    token.accessToken = accessToken;
                    token.sdkToken = sdkToken;
                    self.token = token;
                }
            }
        }
        else
        {
            DDLogDebug(@"fetch code result %zd",code);
        }
        
        if (completion) {
            completion(token);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil);
        }
    }];

    [op start];
}


- (void)cleanAppToken{
    self.token = nil;
}
@end
