//
//  CacheFile.m
//  MobileUU
//=========================
//1.0 UDID写入缓存                  万黎君
//1.1 将TGT存入写到字典的最后         万黎君
//1.2讲USERID雪如缓存                万黎君
//=========================
//  Created by 王義傑 on 14-5-31.
//  Copyright (c) 2014年 Shanghai Pecker Network Technology Co., Ltd. All rights reserved.
//

#import "CacheFile.h"
#import "InterfaceURLs.h"
#import "Userinfo.h"

@implementation CacheFile

+(void) WriteToFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"usercache.plist"];
    NSLog(@"%@",plistPath);
    //判断是否以创建文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        /*
         注意：此方法更新和写入是共用的
         */
        NSString *st;
        if ([Userinfo getST]==nil) {
            st = @"";
        }else{
            st = [Userinfo getST];
        }

        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:

                              [Userinfo getCellPhone],@"account",
                             
                              [Userinfo getLoginSatuts],@"loginstatus",
                               st,@"st",
                              [Userinfo getUserTGT],@"tgt",
                              [Userinfo getUserid],@"userid",
                              [Userinfo getPWD],@"pwd",
                              
//                              [Userinfo getUserCellPhoneUDID],@"UDID",
//                              
//                              [Userinfo getUserid],@"userid",
//                              
//                              [Userinfo getUseridentifier],@"useridentfier",
//                              
//                              [Userinfo getGold],@"gold",
//                              
//                              [Userinfo getUsernewMissionAmount],@"newmission",
//                              
//                              [Userinfo getUserdoingMissionAmount],@"doingmission",
//                              
//                              [Userinfo getVisitor_code],@"Visitor_code",
//                              
//                              [Userinfo getUserIMmessageAmount] ,@"immsg",
//                              
//                              [Userinfo getUserName],@"username",
//                              
//                              [Userinfo getRank],@"rank",
//                              
//                              [Userinfo getSubjection],@"subjection",
//                              
//                              [Userinfo getUserWorkState],@"workstate",
//                              
//                              [Userinfo getUserRealauth],@"realauth",
//                              
//                              photo, @"pictureurl",
//                              
//                              [Userinfo getHonor],@"honor",
//                              
//                              [Userinfo getUserMob_bind],@"mob_bind",
//                              
//                              [Userinfo getUserPay_bind],@"pay_bind",
//                              
//                              [Userinfo getUserStockgold],@"stockgold",
//                              
//                              [Userinfo getExperience],@"experience",
//                              
//                              [Userinfo getUserInfoArray],@"userinfo",
                              
                              nil];

        //写入文件

        NSFileManager *fm = [NSFileManager defaultManager];
        
        [fm createFileAtPath:plistPath contents:nil attributes:nil];
        
        [data writeToFile:plistPath atomically:YES];
        
        NSLog(@"文件已存在:%@",data);
    }
    else
    {
//        NSString *photo = [NSString stringWithFormat:@"%@%@", strUtouu,[dicLogin objectForKey:@"pictureurl"]];
        //如果没有plist文件就自动创建
        
        
        NSString *st;
        if ([Userinfo getST]==nil) {
            st = @"";
        }else{
            st = [Userinfo getST];
        }
               NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              
                               st,@"st",
                              [Userinfo getPWD],@"pwd",
                              
                              [Userinfo getCellPhone],@"account",
                              
                              [Userinfo getLoginSatuts],@"loginstatus",
                                     
                              [Userinfo getUserTGT],@"tgt",
                              [Userinfo getUserid],@"userid",
                              
                             
//
//                              [Userinfo getUserCellPhoneUDID],@"UDID",
//                              
//                              [Userinfo getUserid],@"userid",
//                              
//                              [Userinfo getUseridentifier],@"useridentfier",
//                              
//                              [Userinfo getGold],@"gold",
//                              
//                              [Userinfo getUsernewMissionAmount],@"newmission",
//                              
//                              [Userinfo getUserdoingMissionAmount],@"doingmission",
//                                     
//                              [Userinfo getVisitor_code],@"Visitor_code",
//                              
//                              [Userinfo getUserIMmessageAmount] ,@"immsg",
//                              
//                              [Userinfo getUserName],@"username",
//                              
//                              [Userinfo getRank],@"rank",
//                              
//                              [Userinfo getSubjection],@"subjection",
//                              
//                              [Userinfo getUserWorkState],@"workstate",
//                              
//                              [Userinfo getUserRealauth],@"realauth",
//                              
//                              [Userinfo getHonor],@"honor",
//                              
//                              [Userinfo getUserMob_bind],@"mob_bind",
//                              
//                              [Userinfo getUserPay_bind],@"pay_bind",
//                              
//                              [Userinfo getUserStockgold],@"stockgold",
//                              
//                              [Userinfo getExperience],@"experience",
//                        
//                              [Userinfo getUserHeadUrl],@"pictureurl",
//                              
//                              [Userinfo getUserInfoArray],@"userinfo",
                              
                              nil];
        
        //写入文件
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        [fm createFileAtPath:plistPath contents:nil attributes:nil];
        
        [data writeToFile:plistPath atomically:YES];
        NSLog(@"写入data:%@",data);
    }
}




+ (void)loadLocalUserFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"usercache.plist"];
    
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        [Userinfo setUserName:[dictionary objectForKey:@"username"]];
        
        [Userinfo setCellPhone:[dictionary objectForKey:@"loginName"]];
        
        [Userinfo setLoginSatuts:[dictionary objectForKey:@"loginstatus"]];

        [Userinfo setUserTGT:[dictionary objectForKey:@"tgt"]];
        
        [Userinfo setPWD:[dictionary objectForKey:@"pwd"]];
        
        [Userinfo setCellPhone:[dictionary objectForKey:@"account"]];
        
        [Userinfo setST:[dictionary objectForKey:@"st"]];
        [Userinfo setUserid:[dictionary objectForKey:@"userid"]];
        
//        [Userinfo setUserCellPhoneUDID:[dictionary objectForKey:@"UDID"]];
//        
//        [Userinfo setUserid:[dictionary objectForKey:@"userid"]];
//        
//        [Userinfo setUseridentifier:[dictionary objectForKey:@"useridentfier"]];
//        
//        [Userinfo setGold:[dictionary objectForKey:@"gold"]];
//        
//        [Userinfo setUsernewMissionAmount:[dictionary objectForKey:@"newmission"]];
//        
//        [Userinfo setUserdoingMissionAmount:[dictionary objectForKey:@"doingmission"]];
//        
//        [Userinfo setVisitor_code:[dictionary objectForKey:@"Visitor_code"]];
//        
//        [Userinfo setUserIMmessageAmount:[dictionary objectForKey:@"immsg"]];
//        
//        [Userinfo setUserName:[dictionary objectForKey:@"username"]];
//        
//        [Userinfo setRank:[dictionary objectForKey:@"rank"]];
//        
//        [Userinfo setSubjection:[dictionary objectForKey:@"subjection"]];
//        
//        [Userinfo setUserWorkState:[dictionary objectForKey:@"workstate"]];
//        
//        [Userinfo setUserRealauth:[dictionary objectForKey:@"realauth"]];
//        
//        [Userinfo setHonor:[dictionary objectForKey:@"honor"]];
//        
//        [Userinfo setUserMob_bind:[dictionary objectForKey:@"mob_bind"]];
//        
//        [Userinfo setUserPay_bind:[dictionary objectForKey:@"pay_bind"]];
//        
//        [Userinfo setUserStockgold:[dictionary objectForKey:@"stockgold"]];
//        
//        [Userinfo setExperience:[dictionary objectForKey:@"experience"]];
//        
//        [Userinfo setUserInfoArray:[dictionary objectForKey:@"userinfo"]];
//        
//        //[Userinfo setLoginSatuts:[dictionary objectForKey:@"loginstatus"]];
//        

        

        
        
        NSLog(@"读取data:%@",dictionary);
        
    }
    

    
}



@end
