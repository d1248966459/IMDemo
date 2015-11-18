//
//  LoginHistoryDAO.h
//  UChat
//
//  Created by dcj on 15/11/12.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "BaseDAO.h"
#import "UserInfoModel.h"
@interface LoginHistoryDAO : BaseDAO

@property (nonatomic,copy) NSString * account;
@property (nonatomic,strong)UserInfoModel * userInfo;


+(void)insertWithLoginInfo:(UserInfoModel *)userInfo;

+(UserInfoModel *)searchModelWithAccount:(NSString *)account;

@end
