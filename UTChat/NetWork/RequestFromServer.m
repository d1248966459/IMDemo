//
//  RequestFromServer.m
//  MobileUU
//
//  Created by 王義傑 on 15/5/6.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "RequestFromServer.h"
#import "InterfaceURLs.h"
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "PassportService.h"


@implementation RequestFromServer

UIAlertView *alertView;
int count ;

#pragma mark - http requeset1
+ (void)requestWithURL:(NSString *)urlStr type:(NSString *)type requsetHeadDictionary:(NSDictionary *)headDic requestBodyDictionary:(NSDictionary*)bodyDic showHUDView:(UIView *)view showErrorAlertView:(BOOL)showAlert success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    if (!urlStr || urlStr.length == 0) {
        return;
    }
    if (!type || type.length == 0) {
        return;
    }
    count = 0;
    //alertView = [[UIAlertView alloc] initWithTitle:@"身份令牌过期" message:@"您的身份令牌已过期, 为了您的帐号安全, 请重新登录." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    MBProgressHUD *hud = nil;
    if (view) {
        hud = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:hud];
        [view bringSubviewToFront:hud];
        [hud setLabelText:@"正在加载"];
        [hud show:YES];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    manager.requestSerializer.timeoutInterval = 15;
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setValue:@"text/html;charset=UTF-8,application/json" forHTTPHeaderField:@"Accept"];
    
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    NSLog(@"\n--------------------->>> urlString : %@\n", urlStr);
    NSLog(@"\n--------------------->>> requestType : %@\n", type);
    NSLog(@"\n--------------------->>> headParameters : %@\n", manager.requestSerializer.HTTPRequestHeaders);
    NSLog(@"\n--------------------->>> bodyParameters : %@\n", bodyDic);
    
    if ([type isEqualToString:@"GET"]) {
        [manager GET:urlStr parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *returnStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *returnDic = [returnStr JSONValue];
          //  NSLog( @"%@", returnDic);

            success(operation, returnDic);
            [self hudHide:hud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
            [self requestFailure:error hud:hud showAlert:showAlert];
        }];
    }
    else if ([type isEqualToString:@"POST"]) {
        [manager POST:urlStr parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *returnStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            NSDictionary *returnDic = [returnStr JSONValue];
            if ([returnDic isKindOfClass:[NSDictionary class]]) {
                
                if ([[returnDic allKeys] containsObject:@"code"]) {
                    
                    NSString *code;
                    if ((NSNull*)[returnDic objectForKey:@"code"] != [NSNull null]) {
                        if ([[returnDic objectForKey:@"code"] isKindOfClass:[NSString class]]) {
                            code = [returnDic objectForKey:@"code"];
                            
                        }else{
                            
                            code = [returnDic objectForKey:@"code"];
                        }
                        
                    }
                    if ([code isEqual:@"025"]) {
                        [PassportService getSTbyTGT:[Userinfo getUserTGT] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            NSDictionary *stObj = (NSDictionary *)responseObject;
                            NSString *st = [stObj objectForKey:@"st"];
                            
                            [Userinfo setST:st];
                            
                            [Userinfo setLoginSatuts:@"1"];

                            //重新组装头部参数
                            NSDictionary *new_head = [AppControlManager getSTHeadDictionary:bodyDic];
                            
                            [self requestWithURL:urlStr type:type requsetHeadDictionary:new_head requestBodyDictionary:bodyDic showHUDView:view showErrorAlertView:(BOOL)showAlert success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                                success(operation, responseObject);
                                [self hudHide:hud];
                                NSLog(@"重新获取ST");
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                NSLog(@"重新获取ST失败"); 
                            }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [Userinfo setST:@"UTOUU-ST-INVALID"];
                            [Userinfo setUserTGT:@""];
                            [Userinfo setLoginSatuts:@"0"];
                            [Userinfo setUserid:@""];
                            [Common saveUserImage:@""];
                            [CacheFile WriteToFile];
                            if (alertView != nil) {
                                
                                if (count == 0) {
                                   // [alertView show];
                                    [Common LoginController];
                                }
                                count++;
                            }
                        }];
                    }
                    else{
                        NSLog( @"%@", returnDic);
                        success(operation, returnDic);
                        returnDic = nil;
                        [self hudHide:hud];
                    }
                }
                else{
                    NSLog( @"%@", returnDic);
                    success(operation, returnDic);
                    returnDic = nil;
                    [self hudHide:hud];
                }
                
            }
             else{
             NSLog( @"%@", returnDic);
             success(operation, returnDic);
                 returnDic = nil;
             [self hudHide:hud];
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
            [self requestFailure:error hud:hud showAlert:showAlert];
            [self hudHide:hud];
        }];
    }
    else if ([type isEqualToString:@"PUT"]) {
        [manager PUT:urlStr parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation, responseObject);
            [self hudHide:hud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
            [self requestFailure:error hud:hud showAlert:showAlert];
        }];
    }
    else if ([type isEqualToString:@"DELETE"]) {
        [manager DELETE:urlStr parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation, responseObject);
            [self hudHide:hud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
            [self requestFailure:error hud:hud showAlert:showAlert];
        }];
    }
    
    [[AFHTTPRequestOperationManager manager].operationQueue cancelAllOperations];
}

+ (void)hudHide:(MBProgressHUD *)hud {
    if (hud) {
        [hud removeFromSuperview];
    }
}

+ (void)requestFailure:(NSError *)error hud:(MBProgressHUD *)hud showAlert:(BOOL)show {
    NSLog(@"\n--->>> error : %@\n\n", error);
   
    [self hudHide:hud];
    //if (show) {
        [ShowMessage showMessage:@"亲,您的手机网络不太顺畅"];
    //}
}
+ (void)showAlertViewWith:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

+ (void)requestFailure:(NSError *)error loadview:(LoadView *)loadview showAlert:(BOOL)show {
    NSLog(@"\n--->>> error : %@\n\n", error);
    
    [loadview hiddenloadingview:YES];
    [loadview hiddenloadfailview:NO];
    [loadview stopAnimation];
    if (show) {
        [ShowMessage showMessage:@"亲,您的手机网络不太顺畅"];
    }
}



+ (void)requestWithURL:(NSString *)urlStr type:(NSString *)type requsetHeadDictionary:(NSDictionary *)headDic requestBodyDictionary:(NSDictionary*)bodyDic showHUDView:(UIView *)view showlogoView:(UIView*)logoview showErrorAlertView:(BOOL)showAlert reloaddataObject:(id)object  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;{
    
    if (!urlStr || urlStr.length == 0) {
        return;
    }
    if (!type || type.length == 0) {
        return;
    }
    count = 0;
    LoadView *loadview = nil;
    alertView = [[UIAlertView alloc] initWithTitle:@"身份令牌过期" message:@"您的身份令牌已过期, 为了您的帐号安全, 请重新登录." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    MBProgressHUD *hud = nil;
    if (view) {
        hud = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:hud];
        [view bringSubviewToFront:hud];
        [hud setLabelText:@"正在加载"];
        [hud show:YES];
        
    }
    if (logoview) {
        //进度条 进度条 进度条 进度条 进度条进度条 进度条 进度条进度条 进度条 进度条
        loadview = [[LoadView alloc] initWithFrame:logoview.bounds];
        loadview.delegate = object;
        [logoview addSubview:loadview];

    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    manager.requestSerializer.timeoutInterval = 15;
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setValue:@"text/html;charset=UTF-8,application/json" forHTTPHeaderField:@"Accept"];
    
    
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    NSLog(@"\n--------------------->>> urlString : %@\n", urlStr);
    NSLog(@"\n--------------------->>> requestType : %@\n", type);
    NSLog(@"\n--------------------->>> headParameters : %@\n", manager.requestSerializer.HTTPRequestHeaders);
    NSLog(@"\n--------------------->>> bodyParameters : %@\n", bodyDic);
    
        if ([type isEqualToString:@"GET"]) {
            [manager GET:urlStr parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *returnStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary *returnDic = [returnStr JSONValue];
                
                success(operation, returnDic);
                [self hudHide:hud];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failure(operation, error);
                [self requestFailure:error hud:hud showAlert:showAlert];
            }];
            
        }
        else if ([type isEqualToString:@"POST"]) {
            [manager POST:urlStr parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSString *returnStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                NSDictionary *returnDic = [returnStr JSONValue];
                if ([returnDic isKindOfClass:[NSDictionary class]]) {
                    
                    if ([[returnDic allKeys] containsObject:@"code"]) {
                        
                        NSString *code;
                        
                        if ((NSNull*)[returnDic objectForKey:@"code"] != [NSNull null]) {
                            if ([[returnDic objectForKey:@"code"] isKindOfClass:[NSString class]]) {
                                code = [returnDic objectForKey:@"code"];
                                
                            }else{
                                
                                code = [returnDic objectForKey:@"code"];
                            }

                        }
                        
                        if ([code isEqual:@"025"]) {
                            [PassportService getSTbyTGT:[Userinfo getUserTGT] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                                NSDictionary *stObj = (NSDictionary *)responseObject;
                                NSString *st = [stObj objectForKey:@"st"];
                                
                                [Userinfo setST:st];
                                [Userinfo setLoginSatuts:@"1"];
                                
                                //重新组装头部参数
                                NSDictionary *new_head = [AppControlManager getSTHeadDictionary:bodyDic];
                                
                                [self requestWithURL:urlStr type:type requsetHeadDictionary:new_head requestBodyDictionary:bodyDic showHUDView:view showErrorAlertView:(BOOL)showAlert success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                    success(operation, responseObject);
                                    [self hudHide:hud];
                                    NSLog(@"重新获取ST");
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"重新获取ST失败");
                                }];
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                [Userinfo setST:@"UTOUU-ST-INVALID"];
                                [Userinfo setUserTGT:@""];
                                [Userinfo setLoginSatuts:@"0"];
                                [Userinfo setUserid:@""];
                                [Common saveUserImage:@""];
                                [CacheFile WriteToFile];
                                if (alertView != nil) {
                                    
                                    if (count == 0) {
                                        [alertView show];
                                        [Common LoginController];
                                    }
                                    count++;
                                }
                            }];
                            
                        }
                        else{
                            NSLog( @"%@", returnDic);
                            success(operation, returnDic);
                            returnDic = nil;
                            [self hudHide:hud];
                            [loadview hiddenloadingview:YES];
                            [loadview hiddenloadfailview:YES];
                            [loadview hiddenloadNetworkview:YES];
                            [loadview stopAnimation];
                            [loadview removeFromSuperview];
                            
                        }
                    }
                    else{
                        NSLog( @"%@", returnDic);
                        success(operation, returnDic);
                        returnDic = nil;
                        [self hudHide:hud];
                        [loadview hiddenloadingview:YES];
                        [loadview hiddenloadfailview:YES];
                        [loadview hiddenloadNetworkview:YES];
                        [loadview stopAnimation];
                        [loadview removeFromSuperview];
                        
                    }
                    
                }
                else{
                    NSLog( @"%@", returnDic);
                    success(operation, returnDic);
                    returnDic = nil;
                    [self hudHide:hud];
                    [loadview hiddenloadingview:YES];
                    [loadview hiddenloadfailview:YES];
                    [loadview hiddenloadNetworkview:YES];
                    [loadview stopAnimation];
                    [loadview removeFromSuperview];
                    
                }
            }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      failure(operation, error);
                      [self requestFailure:error hud:hud showAlert:showAlert];
                      [self requestFailure:error loadview:loadview showAlert:showAlert];
                      [self hudHide:hud];
                      
                  }];
        }
        else if ([type isEqualToString:@"PUT"]) {
            [manager PUT:urlStr parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                success(operation, responseObject);
                [self hudHide:hud];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failure(operation, error);
                [self requestFailure:error hud:hud showAlert:showAlert];
            }];
        }
        else if ([type isEqualToString:@"DELETE"]) {
            [manager DELETE:urlStr parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                success(operation, responseObject);
                [self hudHide:hud];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failure(operation, error);
                [self requestFailure:error hud:hud showAlert:showAlert];
            }];
        }
        
        [[AFHTTPRequestOperationManager manager].operationQueue cancelAllOperations];
}


#pragma mark -实名认证上传图片
+ (void)requestWithURL:(NSString *)urlStr Type:(NSString *)type requsetHeadDictionary:(NSDictionary *)headDic requestBodyDictionary:(NSDictionary*)bodyDic showHUDView:(UIView *)view showlogoView:(UIView*)logoview showErrorAlertView:(BOOL)showAlert reloaddataObject:(id)object  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;{
    
    if (!urlStr || urlStr.length == 0) {
        return;
    }
    if (!type || type.length == 0) {
        return;
    }
    count = 0;
    LoadView *loadview = nil;
    
    MBProgressHUD *hud = nil;
    if (view) {
        hud = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:hud];
        [view bringSubviewToFront:hud];
        [hud setLabelText:@"正在加载"];
        [hud show:YES];
        
    }
    if (logoview) {
        //进度条 进度条 进度条 进度条 进度条进度条 进度条 进度条进度条 进度条 进度条
        loadview = [[LoadView alloc] initWithFrame:logoview.bounds];
        loadview.delegate = object;
        [logoview addSubview:loadview];
        
    }
     alertView = [[UIAlertView alloc] initWithTitle:@"身份令牌过期" message:@"您的身份令牌已过期, 为了您的帐号安全, 请重新登录." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    manager.requestSerializer.timeoutInterval = 60;
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setValue:@"text/html;charset=UTF-8,application/json" forHTTPHeaderField:@"Accept"];
    //    [manager.requestSerializer setValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    //    [manager.requestSerializer setValue:@"image/*" forHTTPHeaderField:@"Content-Type"];
    
    
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    NSLog(@"\n--------------------->>> urlString : %@\n", urlStr);
    NSLog(@"\n--------------------->>> requestType : %@\n", type);
    NSLog(@"\n--------------------->>> headParameters : %@\n", manager.requestSerializer.HTTPRequestHeaders);
    //NSLog(@"\n--------------------->>> bodyParameters : %@\n", bodyDic);
    
    if ([type isEqualToString:@"GET"]) {
        [manager GET:urlStr parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *returnStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *returnDic = [returnStr JSONValue];
            
            success(operation, returnDic);
            [self hudHide:hud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
            [self requestFailure:error hud:hud showAlert:showAlert];
        }];
    }
    else if ([type isEqualToString:@"POST"]) {
        
        
        [manager POST:urlStr parameters:bodyDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSData *imageData = [bodyDic objectForKey:@"picture"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
            [formData appendPartWithFileData:imageData name:@"picture" fileName:fileName mimeType:@"image/jpeg"];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *returnStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            NSDictionary *returnDic = [returnStr JSONValue];
            if ([returnDic isKindOfClass:[NSDictionary class]]) {
                
                if ([[returnDic allKeys] containsObject:@"code"]) {
                    
                    NSString *code;
                    
                    if ([[returnDic objectForKey:@"code"] isKindOfClass:[NSString class]]) {
                        code = [returnDic objectForKey:@"code"];
                        
                    }else{
                        
                        code = [[returnDic objectForKey:@"code"]stringValue ];
                    }
                    if ([code isEqual:@"025"]) {
                        [PassportService getSTbyTGT:[Userinfo getUserTGT] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            NSDictionary *stObj = (NSDictionary *)responseObject;
                            NSString *st = [stObj objectForKey:@"st"];
                            
                            [Userinfo setST:st];
                            
                            [Userinfo setLoginSatuts:@"1"];
                            
                            //重新组装头部参数
                            NSDictionary *new_head = [AppControlManager getSTHeadDictionary:bodyDic];
                            
                            [self requestWithURL:urlStr type:type requsetHeadDictionary:new_head requestBodyDictionary:bodyDic showHUDView:view showErrorAlertView:(BOOL)showAlert success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                                success(operation, responseObject);
                                [self hudHide:hud];
                                NSLog(@"重新获取ST");
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                NSLog(@"重新获取ST失败");
                            }];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [Userinfo setST:@"UTOUU-ST-INVALID"];
                            [Userinfo setUserTGT:@""];
                            [Userinfo setLoginSatuts:@"0"];
                            [Userinfo setUserid:@""];
                            [Common saveUserImage:@""];
                            [CacheFile WriteToFile];
                            if (alertView != nil) {
                                
                                if (count == 0) {
                                    [alertView show];
                                    [Common LoginController];
                                }
                                count++;
                            }
                        }];
                        
                    }
                    else{
                        NSLog( @"%@", returnDic);
                        success(operation, returnDic);
                        [self hudHide:hud];
                        [loadview hiddenloadingview:YES];
                        [loadview hiddenloadfailview:YES];
                        [loadview stopAnimation];
                        [loadview removeFromSuperview];
                        
                    }
                }
                else{
                    NSLog( @"%@", returnDic);
                    success(operation, returnDic);
                    [self hudHide:hud];
                    [loadview hiddenloadingview:YES];
                    [loadview hiddenloadfailview:YES];
                    [loadview stopAnimation];
                    [loadview removeFromSuperview];
                    
                }
                
            }
            else{
                NSLog( @"%@", returnDic);
                success(operation, returnDic);
                [self hudHide:hud];
                [loadview hiddenloadingview:YES];
                [loadview hiddenloadfailview:YES];
                [loadview stopAnimation];
                [loadview removeFromSuperview];
                
                
            }
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  failure(operation, error);
                  [self requestFailure:error hud:hud showAlert:showAlert];
                  [self requestFailure:error loadview:loadview showAlert:showAlert];
                  [self hudHide:hud];
                  
              }];
    }
    else if ([type isEqualToString:@"PUT"]) {
        [manager PUT:urlStr parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation, responseObject);
            [self hudHide:hud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
            [self requestFailure:error hud:hud showAlert:showAlert];
        }];
    }
    else if ([type isEqualToString:@"DELETE"]) {
        [manager DELETE:urlStr parameters:bodyDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation, responseObject);
            [self hudHide:hud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
            [self requestFailure:error hud:hud showAlert:showAlert];
        }];
    }
    
    [[AFHTTPRequestOperationManager manager].operationQueue cancelAllOperations];
    
    
}




@end
