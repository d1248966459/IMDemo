//
//  UserInfoManager.h
//  UTChat
//
//  Created by dcj on 15/11/9.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject

/**
 *  存取用户账号 用于登录时记录账号
 *
 *  @param userName 用户账号
 */
+(void)saveToUserListWithName:(NSString *)name;
+(NSString *)getUserName;
+(NSMutableArray *)getUserNameList;
+(NSString *)getUserImageWithAccount:(NSString *)account;

+(NSString *)myUserId;

@end
