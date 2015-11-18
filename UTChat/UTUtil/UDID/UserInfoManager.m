//
//  UserInfoManager.m
//  UTChat
//
//  Created by dcj on 15/11/9.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "UserInfoManager.h"
#import "NIMUser.h"
NSString * const account = @"account";

NSString * const accountList = @"accountList";
NSString * const historyList = @"historyList";


@implementation UserInfoManager

+(void)saveUserName:(NSString *)userName{

    NSMutableArray * userNameList = [self getUserNameList];
    if (!userNameList) {
        userNameList = [[NSMutableArray alloc] init];
    }
    if ([userNameList containsObject:userName]) {
        [userNameList exchangeObjectAtIndex:0 withObjectAtIndex:[userNameList indexOfObject:userName]];
    }else{
        if (userName) {
            if (userNameList.count>0) {
                [userNameList insertObject:userName atIndex:0];
            }else{
                [userNameList addObject:userName];
            }

        }
        
    }
    NSUserDefaults * fd =[NSUserDefaults standardUserDefaults];
    
    [fd setObject:userNameList forKey:accountList];
    [fd synchronize];
}

+(void)saveUserImage{


}

+(NSString *)getUserName{
    
    NSMutableArray * userNameList = [self getUserNameList];
    
    return [userNameList firstObject];
}

+(NSMutableArray *)getUserNameList{
    NSUserDefaults * fd =[NSUserDefaults standardUserDefaults];
    NSMutableArray * userNameList = [fd objectForKey:accountList];
    return [userNameList mutableCopy];
}

+(void)saveToUserListWithName:(NSString *)name{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NIMUser *me = [[NIMSDK sharedSDK].userManager userInfo:[[NIMSDK sharedSDK].loginManager currentAccount]];
        [self saveUserName:name];
        NSMutableDictionary * userNameDict = [self getHistoryDict];
        if (userNameDict == nil) {
            userNameDict = [[NSMutableDictionary alloc] init];
        }
        if (![[userNameDict objectForKey:me.userInfo.mobile] isEqualToString:me.userInfo.avatarUrl]) {
            [userNameDict setObject:me.userInfo.avatarUrl forKey:name];
            [self saveWithDict:userNameDict];
        }
    });
}

+(void)saveWithDict:(NSMutableDictionary *)dict{
    NSUserDefaults * fd = [NSUserDefaults standardUserDefaults];
    [fd setObject:dict forKey:historyList];
    [fd synchronize];
}

+(NSMutableDictionary *)getHistoryDict{
    NSUserDefaults * fd =[NSUserDefaults standardUserDefaults];
    NSMutableDictionary * userNameList = [fd objectForKey:historyList];
    return [userNameList mutableCopy];
}

+(NSString *)getUserImageWithAccount:(NSString *)account{
    NSMutableDictionary * historyDict = [self getHistoryDict];
    return [historyDict objectForKey:account];
}

+(NSString *)myUserId{
    NIMUser *me = [[NIMSDK sharedSDK].userManager userInfo:[[NIMSDK sharedSDK].loginManager currentAccount]];
    return me.userId;
}

@end
