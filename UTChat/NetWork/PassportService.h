//
//  PassportService.h
//  MobileUU
//====================================
//1.0 新增获取验证码方法   万黎君
//1.1 新增用户注册        万黎君
//====================================
//  Created by 王义杰 on 15/5/14.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "PassportAnalyze.h"
#import "AccountInfo.h"
//#import "DatabaseCache.h"

typedef void(^Compeletion)(id result,NSError * error);

@interface PassportService : NSObject

typedef void (^MyCallback)(id obj);


//从服务获取ST
+ (void) getSTbyTGT:(NSString*)tgt success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;//获取st

//登录
+(void)login:(UIView *)view
            :(NSDictionary *) parameters
            :(MyCallback)callback;

+(void)logout;

+(void)getUserBasicInfo:(NSDictionary*)requesthead
                       :(id)object
                       :(UIView*)view
                       :(UIView*)logoview
                       :(MyCallback)callback;//获取用户基本信息


+(void)getUserDetailInfo:(NSDictionary*)requesthead
                        :(id)object
                        :(UIView*)view
                        :(UIView*)logoview
                        :(MyCallback)callback;//获取用户详细信息

+(void)applyforVerifyCode:(MyCallback)callback;//获取验证码

//+(void)isVerifyCode:(UIViewController *) viewController
//                   :(NSString*)vcode
//                   :(MyCallback)callback;//验证验证码

+(void)registerUserAccount:(UIViewController *)viewController
                          :(NSDictionary *) parameters
                          :(MyCallback)callback;//用户注册

+(void)getUserStatistics:(UIViewController *)viewController
                        :(MyCallback)callback;//用户统计


+(void)UserCheckin:(UIViewController *)viewcontroller
                  :(NSDictionary *)parameters
                  :(MyCallback)callback;//用户签到

+(void)checkUsersIdentifier:(MyCallback)callback;//判断用户是否升级为布衣

+(void)checkOutVersionnext:(NSDictionary*)parameters
                          :(Compeletion)callback;//版本检测

+(void)upLoadUserImage:(UIView*)view str:(NSString*)photo callback:(MyCallback)callback;//用户上传图像

+(void)checkUserisUpload:(UIView*)view callback:(MyCallback)callback;//检查用户是否可以修改图像

+(void)realNameStatus     :(id)objectuserIMLoginAccount
                          :(UIView *)logoview
                  callback:(MyCallback)callback;//实名认证状态

+(void)realNameIDCardType:(UIView *)view callback:(MyCallback)callback;//证件类型查询

+(void)realNameUploadHead:(NSDictionary *) parameters
                         :(id)object
                         :(UIView *)logoview
                 callback:(MyCallback)callback;//上传头像

+(void)realNameSubmit:(NSDictionary *) parameters
                     :(id)object
                     :(UIView *)logoview
             callback:(MyCallback)callback;//提交实名认证

+(void)getMenuList:(UIView*)view callback:(MyCallback)callback;

//登录im
+(void)userIMLoginAccount:(NSString*)account password:(NSString*)password type:(NSString*)type version:(NSString*)version view:(UIView*)view callback:(Compeletion)callback;


+(void)changePasswordSendSMS:(AccountInfo *)account compeletion:(Compeletion)com;

+(void)getPhoneVerifyCode:(AccountInfo *)account compeletion:(Compeletion)com;

+(void)verifyPhoneCode:(AccountInfo *)account compeletion:(Compeletion)com;

@end
