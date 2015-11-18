//
//  ManagerSetting.h
//  MobileUU
//
//  Created by cunny on 15/6/1.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagerSetting : NSObject

+(void)setVerifyCodeUUID:(NSString *)uuid;//取验证码

+(NSString *)getVerifyCodeUUID;

+(void)setUserLatitude:(NSString *)latitude;//获取用户当前纬度

+(NSString *)getUserLatitude;

+(void)setUserLongitude:(NSString *)longitude;//获取用户当前经度

+(NSString *)getUserLongitude;

+(void)setMissionType:(NSString *)Mission_Type;//判断任务类型

+(NSString *)getMissionType;

+(void)setversionUrl:(NSString *)versionUrl;//版本升级url


+(NSString *)getversionUrl;

@end
