//
//  ManagerSetting.m
//  MobileUU
//
//  Created by cunny on 15/6/1.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "ManagerSetting.h"

@implementation ManagerSetting
NSString *strUUID;
+(void)setVerifyCodeUUID:(NSString *)uuid{
    strUUID = uuid;

}

+(NSString *)getVerifyCodeUUID{


    return strUUID;
}


NSString *strlatitude;
+(void)setUserLatitude:(NSString *)latitude;//获取用户当前纬度
{

    strlatitude = latitude;

}

+(NSString *)getUserLatitude{

    return strlatitude;

}



NSString *strlongitude;
+(void)setUserLongitude:(NSString *)longitude;//获取用户当前经度
{
    strlongitude = longitude;

}

+(NSString *)getUserLongitude;
{
    return strlongitude;
}



NSString *strMission_Type;
+(void)setMissionType:(NSString *)Mission_Type;//判断任务类型
{

    strMission_Type = Mission_Type;

}

+(NSString *)getMissionType{

    return strMission_Type;

}


NSString *strversionUrl;
+(void)setversionUrl:(NSString *)versionUrl;//版本升级
{
    
    strversionUrl = versionUrl;
    
}

+(NSString *)getversionUrl{
    
    return strversionUrl;
    
}
@end
