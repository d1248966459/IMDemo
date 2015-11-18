//
//  LoginHistoryDAO.m
//  UChat
//
//  Created by dcj on 15/11/12.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "LoginHistoryDAO.h"
#import "BaseDAOCondition.h"

@implementation LoginHistoryDAO

+(NSString *)tableName{

    return @"loginHistory";
}

+(void)insertWithLoginInfo:(UserInfoModel *)userInfo{
    LoginHistoryDAO * dao = [[LoginHistoryDAO alloc] init];
    dao.account = userInfo.account;
    dao.userInfo = userInfo;
    [dao insertModelWithCompeletion:^(BOOL result) {
        if (result) {
            D_Log(@"insert sucess");
        }else{
            D_Log(@"insert failed");
        }
    }];
}


+(UserInfoModel *)searchModelWithAccount:(NSString *)account{
    LoginHistoryDAO * dao = [[LoginHistoryDAO alloc] init];
    BaseDBPair * pair = [[BaseDBPair alloc] init];
    pair.equlPair = @{@"account":account};
    BaseDAOSerchCondition * searchCondition = [[BaseDAOSerchCondition alloc] init];
    searchCondition.andPairs = pair;
    __block UserInfoModel * model;
    [dao searchModelWithCompeletion:^(id result) {
        if (result) {
            model = (UserInfoModel *)result;
        }else{
            
        }
    } andCondition:searchCondition];
    return model;
}

@end
