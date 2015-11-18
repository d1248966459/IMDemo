//
//  PassportAnalyze.m
//  MobileUU
//
//  Created by 魏鹏 on 15/7/1.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "PassportAnalyze.h"
//#import "menuModel.h"
#import "Result.h"
#import "Userinfo.h"
#import "InterfaceURLs.h"

@implementation PassportAnalyze

#pragma mark  基本信息数据重组
+(id)getUserBasicInfo:(NSDictionary*)jsonstr;{
    NSDictionary *responseObject = jsonstr;
    Result *user_BasicResult = [[Result alloc]init];
    
    BOOL success = [[responseObject objectForKey:@"success"] boolValue];
    
    if (success) {
        
        user_BasicResult.success = YES;
        
        NSDictionary *data_dic = [responseObject objectForKey:@"data"];
        
        user_BasicResult.data =data_dic;
        
        NSString *user_ID = [data_dic objectForKey:@"id"];
        
        NSString *name = [data_dic objectForKey:@"name"];
        
        NSString *urlphoto = [data_dic objectForKey:@"photo"];
        
        NSString *rank;
        NSArray *role_array = [data_dic objectForKey:@"roles"];
        if ([[data_dic objectForKey:@"rank"] isKindOfClass:[NSString class]]) {
            rank = [data_dic objectForKey:@"rank"];
        }else{
            rank = [[data_dic objectForKey:@"rank"] stringValue];
        }
            
        NSString *subjection = [data_dic objectForKey:@"subjection"];
        
        NSString *mission_new = [[data_dic objectForKey:@"mission_new"] stringValue];
        
        NSString *mission_unfinish = [[data_dic objectForKey:@"mission_unfinish"] stringValue];
        
        NSString *im_msg = [[data_dic objectForKey:@"im_msg"] stringValue];
        
        NSString *user_gold = [data_dic objectForKey:@"money"];
        
        NSString *visitor_code = [data_dic objectForKey:@"visitor_code"];
        
        NSString *apply = [[data_dic objectForKey:@"apply"] stringValue];
        
        [Userinfo setApply:apply];
        
        [Userinfo setVisitor_code:visitor_code];
        
        [Userinfo setUserid:user_ID];
        
        [Userinfo setUseridentifier:role_array];
        
        [Userinfo setGold:user_gold];
        
        [Userinfo setUsernewMissionAmount:mission_new];
        
        [Userinfo setUserdoingMissionAmount:mission_unfinish];
        
        [Userinfo setUserIMmessageAmount:im_msg];
        
        [Userinfo setUserName:name];
        
        [Userinfo setRank:rank];
        
        [Userinfo setSubjection:subjection];
        
        
        
        [Userinfo setLoginSatuts:@"1"];
        
        NSString *str = [NSString stringWithFormat:@"%@%@%@_M.jpg",strPicture,str_userphoto, urlphoto];
        [Userinfo setUserHeadUrl:str];
        
          }
    else {
        user_BasicResult.success = NO;
        
        user_BasicResult.msg = [responseObject objectForKey:@"msg"];
        
        if ([[responseObject objectForKey:@"code"]isKindOfClass:[NSString class]]) {
            
            user_BasicResult.code = [responseObject objectForKey:@"code"];
            
        }else{
            
            user_BasicResult.code = [[responseObject objectForKey:@"code"]stringValue ];
            
        }
    }

    return user_BasicResult;
}

#pragma mark 详细信息
+(id)getuserDetailInfo:(NSDictionary*)result_dic;{
    Result *user_DetailResult = [[Result alloc]init];
    
    NSDictionary *responseObject = result_dic;
    
    BOOL success = [[responseObject objectForKey:@"success"] boolValue];
    @try {
        if (success) {
            
            user_DetailResult.success = YES;
            
            NSDictionary *data_dic = [responseObject objectForKey:@"data"];
            
            user_DetailResult.data = data_dic;
            
            NSString *money = [[data_dic objectForKey:@"money"] stringValue];
            
            NSString *stock;
            
            if (((NSNumber *)[data_dic objectForKey:@"stock"]).intValue < 0) {
                stock = @"尚未开户";
            }
            else {
                stock = [[data_dic objectForKey:@"stock"] stringValue];
            }
            
            NSString *apply = [[data_dic objectForKey:@"apply"] stringValue];
            
            NSString *stock_open = [data_dic objectForKey:@"stock_open"];
            
            NSString *intentional = [data_dic objectForKey:@"intentional"];
            if (intentional == nil) {
                intentional = @"--";
            }
            NSString *finish_mission = [[data_dic objectForKey:@"mission_finish"] stringValue];
            
            NSString *register0 = [data_dic objectForKey:@"register"];
            
            NSString *honor = [[data_dic objectForKey:@"honor"] stringValue];
            
            NSString *experience = [[data_dic objectForKey:@"experience"] stringValue];
            
            NSString *subjection = [data_dic objectForKey:@"subjection"];
            if (subjection == nil) {
                subjection = @"--";
            }
            NSString *rank;
            if ([[data_dic objectForKey:@"rank"] isKindOfClass:[NSString class]]) {
                rank = [data_dic objectForKey:@"rank"];
            }else{
                rank = [[data_dic objectForKey:@"rank"] stringValue];
            }
            
            NSString *workstate = [[data_dic objectForKey:@"workstate"] stringValue];
            
            NSString *real_auth = [[data_dic objectForKey:@"real_auth"] stringValue];
            
            NSString *mob_bind = [[data_dic objectForKey:@"mob_bind"]stringValue ];
            
            NSString *pay_bind = [[data_dic objectForKey:@"pay_bind"]stringValue];
            
            NSString *stock_state = [[data_dic objectForKey:@"stock_account_state"] stringValue];
            
            NSArray *role_array = [data_dic objectForKey:@"roles"];
            
            
            [Userinfo setUserWorkState:workstate];
            
            [Userinfo setUserRealauth:real_auth];
            
            [Userinfo setHonor:honor];
            
            [Userinfo setUseridentifier:role_array];
            
            [Userinfo setUserStockgold:stock];
            
            [Userinfo setExperience:experience];
            
            [Userinfo setLoginSatuts:@"1"];
            
            [Userinfo setUserMob_bind:mob_bind];
            
            [Userinfo setUserPay_bind:pay_bind];
            
            [Userinfo setStock_open:stock_state];
            
            
            
            
            NSString *workstate_name = [data_dic objectForKey:@"workstate_name"];
            
            NSString * ranks = [NSString stringWithFormat:@"%@",rank];
            if (ranks == nil || (NSNull *)ranks == [NSNull null]) {
                ranks = @"";
            }
            NSString *moneys = [NSString stringWithFormat:@"%@",money];
            
            NSString * stocks = [NSString stringWithFormat:@"%@",stock];
            
            NSString * applys = [NSString stringWithFormat:@"%@",apply];
            
            NSString * stock_opens = [NSString stringWithFormat:@"%@",stock_open];
            
            NSString * finish_missions = [NSString stringWithFormat:@"%@个",finish_mission];
            
            NSMutableArray *detailArray = [NSMutableArray arrayWithObjects:subjection,ranks,workstate_name,experience,honor,moneys,stocks,applys,stock_opens,intentional,finish_missions,register0, nil];
            
            [Userinfo setUserInfoArray:detailArray];
        }
        else{
            user_DetailResult.success = NO;
            
            if ([[responseObject objectForKey:@"code"]isKindOfClass:[NSString class]]) {
                
                user_DetailResult.code = [responseObject objectForKey:@"code"];
                
            }else{
                
                user_DetailResult.code = [[responseObject objectForKey:@"code"]stringValue ];
                
            }
            
            user_DetailResult.msg = [responseObject objectForKey:@"msg"];
            
            
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return user_DetailResult;
}
//+(id)getMenuList:(NSDictionary*)result_dic;{
//    
//    NSString *msg = [result_dic objectForKey:@"msg"];
//    
//    
//    NSDictionary *data_dic = [result_dic objectForKey:@"data"];
//    NSArray *list_array = [data_dic objectForKey:@"list"];
//    NSMutableArray *temp_array = [[NSMutableArray alloc] init];
//    BOOL success = [[result_dic objectForKey:@"success"] boolValue];
//    if (success) {
//        if (list_array.count != 0) {
//            
//            for (NSDictionary *temp_dic in list_array) {
//                menuModel *m_model = [[menuModel alloc] init];
//                m_model.name = [temp_dic objectForKey:@"name"];
//                m_model.code = [temp_dic objectForKey:@"code"];
//                m_model.type = [[temp_dic objectForKey:@"type"] stringValue];
//                m_model.value = [temp_dic objectForKey:@"value"];
//                m_model.disable = [[temp_dic objectForKey:@"disable"] boolValue];
//                m_model.disable_url = [temp_dic objectForKey:@"disableUrl"];
//                m_model.icon = [temp_dic objectForKey:@"icon"];
//                m_model.icon_selected = [temp_dic objectForKey:@"iconSelected"];
//                m_model.position = [[temp_dic objectForKey:@"position"] stringValue];
//                m_model.index = [[temp_dic objectForKey:@"index"] longValue];
//                m_model.visible = [[temp_dic objectForKey:@"visible"] boolValue];
//                [temp_array addObject:m_model];
//            }
//        }
//        return temp_array;
//    }
//    else{
//        [ShowMessage showMessage:msg];
//        return nil;
//    }
//
//}



@end
