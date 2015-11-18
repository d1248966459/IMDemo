//
//  PassportService.m
//  MobileUU
//================================================================
//1.0改写用户详信息方法加上callback，用户获取到ST好TGT后立刻set   万黎君
//1.1用户基本信息解析userID                                   万黎君
//1.2新增注册方法                                            万黎君
//1.3改写方法                                               万黎君
//1.4增加用户统计                                            万黎君
//================================================================
//  Created by 王义杰 on 15/5/14.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "PassportService.h"
#import "InterfaceURLs.h"
#import "RequestFromServer.h"
#import "Result.h"
#import "Userinfo.h"
#import "MD5.h"
#import "Common.h"
#import "AppControlManager.h"
#import "CacheFile.h"
#import "AppDelegate.h"

@implementation PassportService

//获取ST
+ (void) getSTbyTGT:(NSString*)tgt
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    
    NSString *url = [strPassport stringByAppendingString:strst];
    
    NSString *strurl = [NSString stringWithFormat:@"%@/%@",url,tgt];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"http://app.utouu",@"service", nil];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary * headDic = [AppControlManager getSTHeadDictionary:dic];
    
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    
    NSLog(@"\n--------------------->>> headParameters : %@\n", manager.requestSerializer.HTTPRequestHeaders);
    
    
    [manager POST:strurl parameters:dic
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              
              NSString *st = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
              
              NSDictionary *st_dic = [NSDictionary dictionaryWithObjectsAndKeys:st,@"st", nil];
              
              [Userinfo setST:st];
              
              
              //[CacheFile WriteToFile];
              success(operation, st_dic);
              
          }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
              
              //相应不等于200-299
              failure(operation,error);
              
          }];
}

//登录
+(void)login:(UIView *)view
            :(NSDictionary *) parameters
            :(MyCallback)callback
{
    Result *loginResult = [Result alloc];
    
    //判断本地缓存中是否有TGT，如果有则不调用登录接口，如果没有则调用登录接口
    if ([[Userinfo getUserTGT] isEqualToString:@""] || [Userinfo getUserTGT] == nil) {
        //接口地址
        NSString *strMissionList = [strPassport stringByAppendingString:strAccountLoginURL];
        
        NSDictionary *head_dic = [AppControlManager getSTHeadDictionary:parameters];
        
        [RequestFromServer requestWithURL:strMissionList
                                     type:@"POST"
                    requsetHeadDictionary:head_dic
                    requestBodyDictionary:parameters
                              showHUDView:view
                       showErrorAlertView:YES
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      loginResult.success = [[responseObject objectForKey:@"success"] boolValue];
                                      
                                      loginResult.msg = [responseObject objectForKey:@"msg"];
                                      
                                      
                                      NSDictionary *tgtdic = [responseObject objectForKey:@"data"];
                                      
                                      NSString *strTGT = [tgtdic objectForKey:@"tgt"];
                                      
                                      [Userinfo setUserTGT:strTGT];
                                      
                                      if (loginResult.success) {
                                          [self getSTbyTGT:strTGT success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              
                                              
                                              loginResult.success = YES;
                                              
                                              NSDictionary *stObj = (NSDictionary *)responseObject;
                                              
                                              NSString *st = [stObj objectForKey:@"st"];
                                              
                                              [Userinfo setST:st];
                                              
                                              callback(loginResult);
                                              
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              
                                          }];
                                      }else{
                                          loginResult.success = NO;
                                          
                                          loginResult.msg = [responseObject objectForKey:@"msg"];
                                          
                                          if ([[responseObject objectForKey:@"code"]isKindOfClass:[NSString class]]) {
                                              
                                              loginResult.code = [responseObject objectForKey:@"code"];
                                              
                                          }else{
                                              
                                              loginResult.code = [[responseObject objectForKey:@"code"]stringValue ];
                                              
                                          }
                                          
                                          
                                          callback(loginResult);
                                          
                                      }
                                      
                                      loginResult.data = tgtdic;
                                      
                                      
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      
                                      NSLog(@"获取TGT失败了");
                                      //调用失败的方法在这里添加
                                  }];
    }else{
        //如果本地缓存中有TGT，则判断本地缓存中是否有ST，如果没有，取ST，如果有则直接登录
        
        if ([[Userinfo getST] isEqualToString:@"UTOUU-ST-INVALID"] || [Userinfo getST] == nil){
            
            [self getSTbyTGT:[Userinfo getUserTGT] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *stObj = (NSDictionary *)responseObject;
                
                NSString *st = [stObj objectForKey:@"st"];
                
                [Userinfo setST:st];
                
                loginResult.success = true;
                
                loginResult.msg = @"登录成功";
                
                callback(loginResult);
                
                NSLog(@"重新获取ST");
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                loginResult.success = false;
                
                [Userinfo setUserTGT:@""];
                
                loginResult.msg = @"重新获取ST令牌失败,请再次尝试登录";
                
                callback(loginResult);
                
                NSLog(@"重新获取ST失败");
                
            }];
            
        }else{
            
            loginResult.success = true;
            
            loginResult.msg = @"登录成功";
            
            callback(loginResult);
        }
    }
    
}


//注销
+(void)logout{
    [Userinfo setLoginSatuts:@"0"];
    
    [Userinfo setST:@"UTOUU-ST-INVALID"];
    
    [Userinfo setUserTGT:@""];
    
    [Userinfo setPWD:@""];
    
    [Userinfo setUserid:@""];
    
    [Common saveUserImage:@""];
    
    [CacheFile WriteToFile];
}


#pragma mark - 获取用户基本信息
//+(void)getUserBasicInfo:(NSDictionary*)requesthead :(id)object :(UIView*)view : (UIView*)logoview :(MyCallback)callback{
//    /*
//     首先查询本地数据库有无数据，在请求服务器覆盖本地数据，并更新数据库
//     */
//    NSMutableArray *data_array = [DatabaseCache searchData:[Userinfo getUserid] dataType:CACHE_DATATYPE_USERINFO];
//    if (data_array.count != 0) {
//        paramList *param = [data_array objectAtIndex:0];
//        NSDictionary *result_dic   = [Common JsonTodictionary:param.content];
//        Result *user_BasicResult = [PassportAnalyze getUserBasicInfo:result_dic];
//        callback(user_BasicResult);
//    }
//    NSString *strurl = [strUtouuAPI stringByAppendingString:struser_baseinfo];
//    [RequestFromServer requestWithURL:strurl type:@"POST" requsetHeadDictionary:requesthead requestBodyDictionary:nil showHUDView:nil showlogoView:logoview showErrorAlertView:YES reloaddataObject:object  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSString *content = [Common dictionaryToJson:responseObject];
//        NSMutableArray *data_array = [DatabaseCache searchData:[Userinfo getUserid] dataType:CACHE_DATATYPE_USERINFO];
//        if (data_array.count == 0) {
//            paramList *param = [[paramList alloc] init];
//            param.content = content;
//            
//            [NSString stringWithFormat:@"%@",[Userinfo getUserid]];
//            NSMutableDictionary *data_dic = [responseObject objectForKey:@"data"];
//            NSString *user_id = [data_dic objectForKey:@"id"];
//            [Userinfo setUserid:user_id];
//            
//            param.userid = [Userinfo getUserid];
//            param.dataType = CACHE_DATATYPE_USERINFO;
//            [DatabaseCache insertData:param];
//        }
//        else{
//            paramList *param = [data_array objectAtIndex:0];
//            param.content = content;
//            [DatabaseCache updata:param];
//        }
//        Result *user_BasicResult = [PassportAnalyze getUserBasicInfo:responseObject];
//        callback(user_BasicResult);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"调取基本信息失败");
//        callback(nil);
//        
//    }];
//}
//int i;
#pragma mark 获取用户详细信息
//+(void)getUserDetailInfo:(NSDictionary*)requesthead
//                        :(id)object
//                        :(UIView*)view
//                        :(UIView*)logoview
//                        :(MyCallback)callback{
//    i = 0;
//    NSMutableArray *data_array = [DatabaseCache searchData:[Userinfo getUserid] dataType:CACHE_DATATYPE_USERDETAILFINFO];
//    if (data_array.count != 0) {
//        paramList *param = [data_array objectAtIndex:0];
//        NSDictionary *result_dic   = [Common JsonTodictionary:param.content];
//        Result *user_detailResult = [PassportAnalyze getuserDetailInfo:result_dic];
//        callback(user_detailResult);
//    }
//    
//    NSString *strurl = [strUtouuAPI stringByAppendingString:struser_detailinfo];
//    [RequestFromServer requestWithURL:strurl type:@"POST" requsetHeadDictionary:requesthead requestBodyDictionary:nil showHUDView:nil showlogoView:logoview showErrorAlertView:YES reloaddataObject:object  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSString *content = [Common dictionaryToJson:responseObject];
//        NSMutableArray *data_array = [DatabaseCache searchData:[Userinfo getUserid] dataType:CACHE_DATATYPE_USERDETAILFINFO];
//        if (data_array.count == 0) {
//            paramList *param = [[paramList alloc] init];
//            param.content = content;
//            param.userid = [Userinfo getUserid];
//            param.dataType = CACHE_DATATYPE_USERDETAILFINFO;
//            [DatabaseCache insertData:param];
//        }
//        else{
//            paramList *param = [data_array objectAtIndex:0];
//            param.content = content;
//            [DatabaseCache updata:param];
//        }
//        Result *user_DetailResult = [PassportAnalyze getuserDetailInfo:responseObject];
//        callback(user_DetailResult);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        callback(nil);
//        NSLog(@"调取详细信息失败");
//        
//    }];
//    
//}

#pragma mark - 获取验证码
+(void)applyforVerifyCode:(MyCallback)callback{
    
    NSString *url = [strRegister stringByAppendingString:strSMSPic];
    
    NSString *uuid = [NSString stringWithFormat:@"%d",arc4random()];
    
    [ManagerSetting setVerifyCodeUUID:uuid];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         uuid,@"key",
                         @"3600",@"time",
                         @"3",@"source",//ios-p
                         //@"2",@"source",//ios
                         @"100",@"width",
                         @"40",@"height",
                         @"",@"sign",
                         @"4",@"len", nil];
    
    NSMutableDictionary *headDic = [AppControlManager getSTHeadDictionary:dic];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    
    NSLog(@"\n--------------------->>> headParameters : %@\n", manager.requestSerializer.HTTPRequestHeaders);
    [manager POST:url parameters:dic
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              callback(responseObject);
              
          }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
              
          }];
}

#pragma  mark - 注册
+(void)registerUserAccount:(UIViewController *)viewController
                          :(NSDictionary *) parameters
                          :(MyCallback)callback{
    
    NSString *url = [strPassport stringByAppendingString:strRegisterResult];
    
    //    NSString *time = [MD5 getSystemTime];
    //
    //    NSString *sign = [MD5 md5:parameters time:time];
    //
    //    NSString *account = [parameters objectForKey:@"account"];
    //
    //    NSString *password = [parameters objectForKey:@"password"];
    //
    //    NSString *verifyCode = [parameters objectForKey:@"imgVCode"];
    //
    //    NSString *cipher = [parameters objectForKey:@"cipher"];
    //
    //    NSString *uuid = [parameters objectForKey:@"imgVCodeKey"];
    
    //NSDictionary *head_dic = [NSDictionary dictionaryWithObjectsAndKeys:account,@"account",password,@"password",@"6",@"source",@"6",@"visitor",cipher,@"cipher",@"",@"openId",verifyCode,@"imgVCode",uuid,@"imgVCodeKey",sign,@"sign",time,@"time", nil];
    
    NSDictionary * head_dic = [AppControlManager getSTHeadDictionary:parameters];
    
    
    [RequestFromServer requestWithURL:url type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:parameters showHUDView:viewController.view showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Result *registerResult = [[Result alloc]init];
        
        NSString *success = [[responseObject objectForKey:@"success"]stringValue];
        
        NSString *message = [responseObject objectForKey:@"msg"];
        
        if ([success isEqualToString:@"1"]) {
            
            registerResult.success = YES;
            
            registerResult.msg = message;
            
        }else{
            
            registerResult.success = NO;
            
            registerResult.msg = message;
            
        }
        
        callback(registerResult);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark  -用户统计
+(void)getUserStatistics:(UIViewController *)viewController
                        :(MyCallback)callback{
    NSMutableDictionary *head_dic = [AppControlManager getSTHeadDictionary:nil];
    
    NSString *url = [strUtouuAPI stringByAppendingString:strStatistics];
    
    [RequestFromServer requestWithURL:url type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:nil showHUDView:viewController.view showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Result *statistics_Result = [[Result alloc]init];
        
        NSString *success = [[responseObject objectForKey:@"success"] stringValue];
        
        NSString *message = [responseObject objectForKey:@"msg"];
        
        if ([success isEqualToString:@"1"]) {
            
            statistics_Result.success = YES;
            
            statistics_Result.msg = message;
            @try {
                NSMutableDictionary *data_dic = [responseObject objectForKey:@"data"];
                
                NSMutableDictionary *redpacket_dic = [data_dic objectForKey:@"redpacket"];
                
                NSString *red_count = [[redpacket_dic objectForKey:@"count" ]stringValue ];
                if ((NSNull*)red_count == [NSNull null]) {
                    red_count = @"0";
                }
                
                NSString *red_money = [[redpacket_dic objectForKey:@"money" ]stringValue ];
                if ((NSNull*)red_count == [NSNull null]) {
                    red_money = @"0.00";
                }
                
                NSArray *mission_array = [data_dic objectForKey:@"mission"];
                for (int i = 0; i<[mission_array count]; i++) {
                    NSDictionary *mission_dic = [mission_array objectAtIndex:i];
                    NSString *status = [[mission_dic objectForKey:@"status"] stringValue];
                    //                    if ((NSNull*)status == [NSNull null]) {
                    //
                    //                    }
                    NSString *count = [[mission_dic objectForKey:@"count"] stringValue];
                    if ([status isEqualToString:@"1"]) {
                        [Userinfo setUsernewMissionAmount:count];
                    }
                    else if ([status isEqualToString:@"2"]){
                        [Userinfo setUserdoingMissionAmount:count];
                    }
                }
                [Userinfo setRed_count:red_count];
                
                [Userinfo setUserRed_money:red_money];
                
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
        }
        else {
            statistics_Result.success = NO;
            statistics_Result.msg = message;
        }
        
        callback(statistics_Result);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
}
#pragma mark 统计
+(void)UserCheckin:(UIViewController *)viewcontroller
                  :(NSDictionary *)parameters
                  :(MyCallback)callback;//用户签到
{
    
    NSString *url = [strUtouuAPI stringByAppendingString:str_user_checkin ];
    
    NSMutableDictionary *head_dic = [AppControlManager getSTHeadDictionary:parameters];
    
    [RequestFromServer requestWithURL:url type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:parameters showHUDView:viewcontroller.view showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        callback(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common AlertViewTitle:@"提示" message:@"签到失败,请稍候重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    }];
}


#pragma mark - 检查用户是否升级为布衣
//+(void)checkUsersIdentifier:(MyCallback)callback;{
//    i++;
//    NSDictionary *head_dic = [AppControlManager getSTHeadDictionary:nil];
//    NSString *strURL = [strUtouuAPI stringByAppendingString:strUserIdentifier];
//    [RequestFromServer requestWithURL:strURL type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:nil showHUDView:nil showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *result_dic = responseObject;
//        BOOL success = [[result_dic objectForKey:@"success"] boolValue];
//        if (success) {
//            NSDictionary *data_dic = [result_dic objectForKey:@"data"];
//            NSString *code = [data_dic objectForKey:@"code"];
//            while(i<40){
//                if ([code isEqualToString:@"YS"])
//                {   NSLog(@"检查次数=====>%d",i);
//                    
//                    [self checkUsersIdentifier:^(id obj) {
//                        callback(obj);
//                        NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
//                    }];
//                    if (i == 39) {
//                        callback(code);
//                    }
//                    
//                }
//                else{
//                    callback(code);
//                    break ;
//                }
//                
//            }
//            
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//}
//

#pragma mark - 版本检测
+(void)checkOutVersionnext:(NSDictionary*)parameters
                          :(Compeletion)callback
{
    NSString *url = [strUtouuAPI stringByAppendingString:str_checkVersion];
    NSDictionary *head_dic = [[NSMutableDictionary alloc]init];
    head_dic = [AppControlManager getSTHeadDictionary:parameters];
    
    [RequestFromServer requestWithURL:url type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:parameters showHUDView:nil showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result_dic = responseObject;
        NSString * success = [[result_dic objectForKey:@"success"] stringValue];
        Result *versionResult = [[Result alloc]init];
        if ([success isEqualToString:@"1"]) {
            versionResult.success = YES;
            
            versionResult.data = [result_dic objectForKey:@"data"];
            
            versionResult.msg = [result_dic objectForKey:@"msg"];
            
        }else{
            versionResult.success = YES;
            
            versionResult.data = [result_dic objectForKey:@"data"];
            
            versionResult.msg = [result_dic objectForKey:@"msg"];
        }
        callback(versionResult,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil,error);
    }];
}
#pragma  mark - 上传图片
+(void)upLoadUserImage:(UIView*)view str:(NSString*)photo callback:(MyCallback)callback;{
    
    NSString *strURL = [strUtouuAPI stringByAppendingString:str_upload_photo];
    
    NSMutableDictionary *body_dic = [NSMutableDictionary dictionaryWithObject:photo forKey:@"photo"];
    NSDictionary *head_dic = [AppControlManager getSTHeadDictionary:body_dic];
    [RequestFromServer requestWithURL:strURL type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:body_dic showHUDView:view showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result_dic = responseObject;
        BOOL success = [[result_dic objectForKey:@"success"] boolValue];
        NSString *msg = [result_dic objectForKey:@"msg"];
        if (success) {
            NSDictionary *data = [result_dic objectForKey:@"data"];
            callback(data);
        }
        else{
            [Common AlertViewTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 检查用户是否可以上传图片
+(void)checkUserisUpload:(UIView*)view callback:(MyCallback)callback;{
    
    NSString *strURL = [strUtouuAPI stringByAppendingString:str_check_photo];
    NSDictionary *head_dic = [AppControlManager getSTHeadDictionary:nil];
    [RequestFromServer requestWithURL:strURL type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:nil showHUDView:view showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        callback(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


//+(void)realNameStatus:(id)object
//                     :(UIView *)logoview
//             callback:(MyCallback)callback{
//    
//    NSString *strUrl = [strUtouuAPI stringByAppendingString:str_realnamestatus];
//    
//    NSDictionary *head_dic = [AppControlManager getSTHeadDictionary:nil];
//    [ RequestFromServer  requestWithURL:strUrl
//                                   type:@"POST"
//                  requsetHeadDictionary:head_dic
//                  requestBodyDictionary:nil
//                            showHUDView:logoview
//                           showlogoView:nil
//                     showErrorAlertView:YES
//                       reloaddataObject:object
//                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                    
//                                    Result *real_Result = [[Result alloc]init];
//                                    
//                                    NSString *success = [[responseObject objectForKey:@"success"]stringValue];
//                                    
//                                    if ([success isEqualToString:@"1"]) {
//                                        real_Result.success = YES;
//                                        
//                                        NSDictionary *data_dic = [responseObject objectForKey:@"data"];
//                                        
//                                        RealNameInfo *real_status = [[RealNameInfo alloc]init];
//                                        
//                                        real_status.state = [[data_dic objectForKey:@"state"]stringValue];
//                                        
//                                        real_status.state_name = [data_dic objectForKey:@"state_name"];
//                                        
//                                        real_status.real_name = [data_dic objectForKey:@"real_name"];
//                                        
//                                        real_status.sex = [data_dic objectForKey:@"sex"];
//                                        
//                                        real_status.certype = [data_dic objectForKey:@"certype"];
//                                        
//                                        real_status.certype_name = [data_dic objectForKey:@"certype_name"];
//                                        
//                                        real_status.certype_number = [data_dic objectForKey:@"certype_number"];
//                                        
//                                        real_status.address = [data_dic objectForKey:@"address"];
//                                        
//                                        real_status.reject = [data_dic objectForKey:@"reject"];
//                                        
//                                        real_status.pictures = [data_dic objectForKey:@"pirtures"];
//                                        
//                                        real_status.pic1 = [data_dic objectForKey:@"pictureOne"];
//                                        
//                                        real_status.pic2 = [data_dic objectForKey:@"pictureTwo"];
//                                        
//                                        
//                                        real_Result.data =real_status;
//                                        
//                                    }else{
//                                        
//                                        real_Result.success = NO;
//                                        
//                                        real_Result.msg = [responseObject objectForKey:@"msg"];
//                                        
//                                        real_Result.code = [responseObject objectForKey:@"code"];
//                                        
//                                    }
//                                    
//                                    callback(real_Result);
//                                    NSLog(@"123");
//                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                    
//                                }];
//    
//    
//    
//}
////证件类型查询
//+(void)realNameIDCardType:(UIView *)view callback:(MyCallback)callback{
//    
//    NSString *strUrl = [strUtouuAPI stringByAppendingString:str_realnameIDtype];
//    
//    NSDictionary *head_dic = [AppControlManager getSTHeadDictionary:nil];
//    
//    [RequestFromServer requestWithURL:strUrl type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:nil showHUDView:nil showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        Result *idCards_Result = [[Result alloc]init];
//        
//        NSString *success = [[responseObject objectForKey:@"success"]stringValue];
//        
//        if ([success isEqualToString:@"1"]) {
//            idCards_Result.success = YES;
//            
//            NSDictionary *data_dic = [responseObject objectForKey:@"data"];
//            
//            NSMutableArray *data_array = [[NSMutableArray alloc]init];
//            
//            NSArray *list_array = [data_dic objectForKey:@"list"];
//            
//            for (int i = 0; i < list_array.count; i++) {
//                IDCardsInfo *cardInfo = [[IDCardsInfo alloc]init];
//                NSDictionary *list_data = list_array[i];
//                
//                cardInfo.name = [list_data objectForKey:@"name"];
//                
//                cardInfo.type = [list_data objectForKey:@"type"];
//                
//                cardInfo.regex = [list_data objectForKey:@"regex"];
//                
//                cardInfo.pictures = [list_data objectForKey:@"pictures"];
//                
//                [data_array addObject:cardInfo];
//            }
//            idCards_Result.data = data_array;
//        }else{
//            
//            idCards_Result.success = NO;
//            
//            idCards_Result.msg = [responseObject objectForKey:@"msg"];
//            
//            idCards_Result.code = [responseObject objectForKey:@"code"];
//            
//        }
//        
//        callback(idCards_Result);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    
//    
//}
//

////上传头像
//+(void)realNameUploadHead:(NSDictionary *)parameters
//                         :(id)object
//                         :(UIView *)logoview
//                 callback:(MyCallback)callback{
//    
//    NSString *strUrl = [strUtouuAPI stringByAppendingString:str_IDPictures];
//    
//    //NSString *strUrl2 = [@"http://192.168.2.63:38180/v1/" stringByAppendingString:str_IDPictures];
//    
//    NSDictionary *head_dic = [AppControlManager getSTHeadDictionary:nil];
//    
//    
//    [RequestFromServer requestWithURL:strUrl Type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:parameters showHUDView:logoview showlogoView:nil showErrorAlertView:YES reloaddataObject:object
//                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                  
//                                  Result *upload_Result = [[Result alloc]init];
//                                  
//                                  NSString *success = [[responseObject objectForKey:@"success"]stringValue];
//                                  
//                                  if ([success isEqualToString:@"1"]) {
//                                      
//                                      upload_Result.success = YES;
//                                      
//                                      NSMutableDictionary *data_dic = [NSMutableDictionary dictionary];
//                                      
//                                      data_dic = [responseObject objectForKey:@"data"];
//                                      
//                                      NSString *relative = [data_dic objectForKey:@"relative"];
//                                      
//                                      upload_Result.data = relative;
//                                      
//                                  }else{
//                                      
//                                      upload_Result.success = NO;
//                                      
//                                      upload_Result.msg = [responseObject objectForKey:@"msg"];
//                                      
//                                      upload_Result.code = [responseObject objectForKey:@"code"];
//                                      
//                                      [ShowMessage showMessage:@"提交失败"];
//                                      
//                                  }
//                                  
//                                  callback(upload_Result);
//                                  
//                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                  
//                              }];
//    
//    
//}
//
//
//
//
////提交实名认证
//+(void)realNameSubmit:(NSDictionary *) parameters
//                     :(id)object
//                     :(UIView *)logoview
//             callback:(MyCallback)callback{
//    
//    NSString *strUrl = [strUtouuAPI stringByAppendingString:str_realnamesubmit];
//    // NSString *strUrl2 = [@"http://192.168.2.63:38180/v1/" stringByAppendingString:str_realnamesubmit];
//    
//    NSDictionary *head_dic = [AppControlManager getSTHeadDictionary:parameters];
//    [RequestFromServer requestWithURL:strUrl type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:parameters showHUDView:logoview showlogoView:nil showErrorAlertView:YES
//                     reloaddataObject:object  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                         
//                         Result *upload_Result = [[Result alloc]init];
//                         
//                         NSString *success = [[responseObject objectForKey:@"success"]stringValue];
//                         
//                         if ([success isEqualToString:@"1"]) {
//                             
//                             upload_Result.success = YES;
//                             
//                             upload_Result.msg = [responseObject objectForKey:@"msg"];
//                             
//                         }else{
//                             
//                             upload_Result.success = NO;
//                             
//                             upload_Result.msg = [responseObject objectForKey:@"msg"];
//                             
//                             upload_Result.code = [responseObject objectForKey:@"code"];
//                             
//                         }
//                         
//                         callback(upload_Result);
//                         
//                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                         
//                     }];
//    
//    
//}
//#pragma mark - 获取菜单列表
//+(void)getMenuList:(UIView*)view callback:(MyCallback)callback;{
//    
//    NSString *strURL = [strUtouuAPI stringByAppendingString:str_checkIsUpdate];
//    NSDictionary *head_dic = [AppControlManager getSTHeadDictionary:nil];
//    [RequestFromServer requestWithURL:strURL type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:nil showHUDView:view showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        if (responseObject) {
//            BOOL success = [[responseObject objectForKey:@"success"] boolValue];
//            NSString *msg = [responseObject objectForKey:@"msg"];
//            if (success) {
//                
//                NSDictionary *data_dic = [responseObject objectForKey:@"data"];
//                NSDictionary *data_version_dic = [data_dic objectForKey:@"data_version"];
//                NSString *menu = [[data_version_dic objectForKey:@"menu"] stringValue];
//                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//                NSString *menu1 = [user objectForKey:@"menu"];
//                if (menu1 == nil) {
//                    menu1 = @"00";
//                }
//                if ([menu isEqualToString:menu1]) {
//                    NSMutableArray *data_array = [DatabaseCache searchData:@"888" dataType:CACHE_DATATYPE_MENULIST];
//                    if (data_array.count != 0) {
//                        paramList *param = [data_array objectAtIndex:0];
//                        NSDictionary *result_dic   = [Common JsonTodictionary:param.content];
//                        NSArray *user_BasicResult = [PassportAnalyze getMenuList:result_dic];
//                        callback(user_BasicResult);
//                    }else{
//                        [self data:view callback:^(id obj) {
//                            callback(obj);
//                        }];
//                    }
//                }else{
//                    [user setObject:menu forKey:@"menu"];
//                    [self data:view callback:^(id obj) {
//                        callback(obj);
//                    }];
//                }
//            }
//            else{
//                [ShowMessage showMessage:msg];
//            }
//            
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//}
//
//#pragma mark -请求菜单接口数据
//+(void)data:(UIView*)view callback:(MyCallback)callback{
//    
//    NSString *strURL = [strUtouuAPI stringByAppendingString:str_menuList];
//    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
//    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
//    NSString *version = [NSString stringWithFormat:@"%@.%@",[infoDict objectForKey:@"CFBundleShortVersionString"],versionNum];
//    NSDictionary *body_dic = [NSDictionary dictionaryWithObjectsAndKeys:version,@"version", nil];
//    NSDictionary *head_dic = [AppControlManager getSTHeadDictionary:body_dic];
//    
//    [RequestFromServer requestWithURL:strURL type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:body_dic showHUDView:view showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSString *content = [Common dictionaryToJson:responseObject];
//        NSMutableArray *data_array = [DatabaseCache searchData:@"888" dataType:CACHE_DATATYPE_MENULIST];
//        if (data_array.count == 0) {
//            paramList *param = [[paramList alloc] init];
//            param.content = content;
//            param.userid = @"888";
//            param.dataType = CACHE_DATATYPE_MENULIST;
//            [DatabaseCache insertData:param];
//        }
//        else{
//            paramList *param = [data_array objectAtIndex:0];
//            param.content = content;
//            [DatabaseCache updata:param];
//        }
//        menuModel *user_DetailResult = [PassportAnalyze getMenuList:responseObject];
//        callback(user_DetailResult);
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//}
+(void)userIMLoginAccount:(NSString*)account password:(NSString*)password type:(NSString*)type version:(NSString*)version view:(UIView*)view callback:(Compeletion)callback{
    NSString *strURL = [strIMAPI stringByAppendingString:str_login];
    NSMutableDictionary *body_dic = [NSMutableDictionary dictionary];
    [body_dic setObject:account forKey:@"account"];
    [body_dic setObject:password forKey:@"password"];
    [body_dic setObject:type forKey:@"type"];
    [body_dic setObject:version forKey:@"version"];
    NSDictionary *head_dic = [AppControlManager getSTHeadDictionary:body_dic];
    [RequestFromServer requestWithURL:strURL type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:body_dic showHUDView:view showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            callback(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil,error);
    }];
    
}

+(void)changePasswordSendSMS:(AccountInfo *)account compeletion:(Compeletion)com{
    NSString * strUrl = [strPassport stringByAppendingString:changePassWord];
    NSMutableDictionary * paramaDict = [[NSMutableDictionary alloc] init];
    [paramaDict setObject:account.account forKey:@"mobile"];
    [paramaDict setObject:account.willChagePassword forKey:@"password"];
    [paramaDict setObject:account.idenKey forKey:@"idenkey"];
    [RequestFromServer requestWithURL:strUrl type:@"POST" requsetHeadDictionary:nil requestBodyDictionary:paramaDict showHUDView:nil showErrorAlertView:NO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        com(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        com(nil,error);
    }];
}

+(void)getPhoneVerifyCode:(AccountInfo *)account compeletion:(Compeletion)com{
    NSString *uuid = [ManagerSetting getVerifyCodeUUID];
    NSString * strurl = [strPassport stringByAppendingString:sendSMS];
    NSMutableDictionary * paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:account.account forKey:@"username"];
    [paramDict setObject:account.verfiyCode forKey:@"imgVCode"];
    [paramDict setObject:uuid forKey:@"imgVCodeKey"];
    [RequestFromServer requestWithURL:strurl type:@"POST" requsetHeadDictionary:nil requestBodyDictionary:paramDict showHUDView:nil showErrorAlertView:NO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        com(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        com(nil,error);
    }];
}

+(void)verifyPhoneCode:(AccountInfo *)account compeletion:(Compeletion)com{

    NSString * strUrl = [strPassport stringByAppendingString:checkSMSCode];
    NSMutableDictionary * paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:account.account forKey:@"mobile"];
    [paramDict setObject:account.smsVerfiyCode forKey:@"code"];
    [RequestFromServer requestWithURL:strUrl type:@"POST" requsetHeadDictionary:nil requestBodyDictionary:paramDict showHUDView:nil showErrorAlertView:NO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        com(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        com(nil,error);
    }];
    

}

@end
