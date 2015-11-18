//
//  NTESHttpRequest.m
//  NIM
//
//  Created by amao on 2/10/14.
//  Copyright (c) 2014 Netease. All rights reserved.
//

#import "NTESHttpRequest.h"
#import "NTESSessionUtil.h"
#import "AFNetworking.h"
#import "NTESAppTokenManager.h"

#import "DDLog.h"

@interface NTESHttpRequest ()
@property (nonatomic, strong)  NSMutableURLRequest *request;
@end

@implementation NTESHttpRequest
+ (NTESHttpRequest *)requestWithURL:(NSURL *)url
{
    NTESHttpRequest *instance = [[NTESHttpRequest alloc] init];
    [instance setRequestURL:url];
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

- (void)setPostDict:(NSDictionary *)dict
{
    if (dict)
    {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
       
        if (![self.request valueForHTTPHeaderField:@"Content-Type"]) {
            NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
            [self.request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
        }
        
        [self.request setHTTPBody:data];
    }
    else
    {
        DDLogDebug(@"%@", @"Error: Empty Post Dict");
    }
}

- (void)setPostJsonData:(NSData *)data {
    if (![self.request valueForHTTPHeaderField:@"Content-Type"]) {
        NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        [self.request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    }
    [self.request setHTTPBody:data];
}

- (void)startAsyncWithComplete:(NTESCompleteBlock)result
{
    NTESAppToken *token = [[NTESAppTokenManager sharedManager] appToken];
    
    if(!token) {
        [[NTESAppTokenManager sharedManager] fetchToken:nil];
        DDLogDebug(@"%@", @"Invalid UserList Token");
        if(result) result(kNIMHttpRequestCodeInvalidToken, nil);
        return;
    } else {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:_request];
        [self handle:operation withResult:result];
        [operation start];
    }
}


#pragma mark - 辅助方法
- (void)setRequestURL: (NSURL *)url
{
    NSParameterAssert(url);
    NSString *accessToken = [[[NTESAppTokenManager sharedManager] appToken] accessToken];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [mutableRequest setHTTPMethod:@"POST"];
    mutableRequest.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    mutableRequest.timeoutInterval = 30;
    [mutableRequest setValue:accessToken ? : @"" forHTTPHeaderField:@"access-token"];
    self.request = mutableRequest;
}

- (void)handle:(AFHTTPRequestOperation *)requestOperation withResult:(NTESCompleteBlock)result
{
    void (^responseBlock)(AFHTTPRequestOperation *operation) = ^(AFHTTPRequestOperation *operation){
        NSInteger	responseCode	= [operation.response statusCode];
        NSError		*error			= [operation error];
        NSData		*data           = [operation responseData];
        NSInteger	errorCode = kNIMHttpRequestCodeFailed;
        NSDictionary *resDict = nil;
        if ((responseCode == 200) && (error == nil)) {
            do {
                if (![data length]) {
                    errorCode = kNIMHttpRequestCodeDecryptError;
                    DDLogDebug(@"NIMHttp Request Decrypt Failed %@", [[operation.request URL] absoluteString]);
                    break;
                }
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:0];
                NSNumber *resCode = [result objectForKey:@"res"];
                if(resCode.integerValue != 200) {
                    errorCode = kNIMHttpRequestCodeFailed;
                    if(resCode.integerValue == 401) {
                        errorCode = kNIMHttpRequestCodeInvalidToken;
                        [[NTESAppTokenManager sharedManager] fetchToken:nil];
                    }
                    DDLogDebug(@"NIMHttp Request Error: %@", [result objectForKey:@"errmsg"] ? : @"");
                    break;
                }
                resDict = [result objectForKey:@"msg"];
                errorCode = kNIMHttpRequestCodeSuccess;
                
            } while (false);
        } else if (responseCode == NSURLErrorTimedOut) {	// request timeout
            errorCode = kNIMHttpRequestCodeTimeout;
            DDLogDebug(@"NIMHttp Request Timeout: URL %@ Code %zd",[[operation.request URL] absoluteString],errorCode);
        }
        
        if (result) {
            result(errorCode, resDict);
        }
    };
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseBlock(operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        responseBlock(operation);
    }];
}


@end
