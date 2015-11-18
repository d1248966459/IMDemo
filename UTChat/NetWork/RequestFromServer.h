//
//  RequestFromServer.h
//  MobileUU
//
//  Created by 王義傑 on 15/5/6.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "ShowMessage.h"
#import "LoadView.h"

@interface RequestFromServer : NSObject
//http request
+ (void)requestWithURL:(NSString *)urlStr type:(NSString *)type requsetHeadDictionary:(NSDictionary *)headDic requestBodyDictionary:(NSDictionary*)bodyDic showHUDView:(UIView *)view showErrorAlertView:(BOOL)showAlert  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/////////////////////////////////////
+ (void)requestWithURL:(NSString *)urlStr type:(NSString *)type requsetHeadDictionary:(NSDictionary *)headDic requestBodyDictionary:(NSDictionary*)bodyDic showHUDView:(UIView *)hudview showlogoView:(UIView*)logoview showErrorAlertView:(BOOL)showAlert reloaddataObject:(id)object  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)requestWithURL:(NSString *)urlStr Type:(NSString *)type requsetHeadDictionary:(NSDictionary *)headDic requestBodyDictionary:(NSDictionary*)bodyDic showHUDView:(UIView *)view showlogoView:(UIView*)logoview showErrorAlertView:(BOOL)showAlert reloaddataObject:(id)object  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
