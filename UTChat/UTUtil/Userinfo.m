//
//  Userinfo.m
//  MobileUU
//
//  Created by 王義傑 on 14-5-30.
//  Copyright (c) 2014年 Shanghai Pecker Network Technology Co., Ltd. All rights reserved.
//

#import "Userinfo.h"

@interface Userinfo()

@end

@implementation Userinfo

#pragma mark ------单例模式------
static Userinfo * _sharedInstance;

+ (id) sharedInstance {
    @synchronized ([Userinfo class]) {
        if (_sharedInstance == nil) {
            _sharedInstance = [[Userinfo alloc] init];
        }
    }
    return _sharedInstance;
}

#pragma mark ------用户基本资料------
NSString *cellPhoneNumer;//手机号

NSString *password;//密码

NSString *logoPicture;//头像

NSString *useridentity;//用户身份：知府，百夫长，门客

NSString *userId;//用户id

NSString *userGold;//用户账户银子

NSString *companyName;//所属的府

NSString *loginstatus;//0未登录，1登录

NSString *mobileitems;

NSString *userName;//用户昵称

NSString *userqq;//QQ号码

NSString *usersex;//性别

NSString *useremail;//电子邮件

NSString *useraddress;//收货地址

NSString *userjob;//所属行业

NSString *subjection;//??

NSString *country;//？？

NSString *continent;//？？

NSString *prefecture;//？？

NSString *company;//？？

NSString *experience;//经验值

NSString *honor;//荣誉值

NSString *rank;//府内排名

NSString *lishu;//？？

NSString *strtoken;//推送令牌

NSString *userprovince;//？？

NSString *usercity;//所在城市

NSString *usercounty;//所在辖区

NSString *useraddress1;//收货地址

NSString *userversion;//？？

NSString *userudid;//手机识别码

NSString *userplatform;//??

NSString *pushnotification;//？？

NSString *alipayaccount;//支付宝账号

NSString *alipayname;//支付宝姓名

NSString *cautionmoney;//???

NSString *strStockgold;//？？

NSString *strWorkState;//工作状态

NSString *strUserType;//??

NSInteger selectMenu;//??

NSInteger selectRightMenu;//???

NSString *user_sgt;//TGT

NSString *user_st;//ST

NSArray *use_infoImage;//用户身份

NSString *user_newMissionAmount;//新任务数

NSString *user_doingMissionAmount;//未完成任务数

NSString *user_imMessageAmount;//IM消息数量

NSString *user_realauth;//???

NSMutableArray *use_infos;//???

NSString *user_head;//????

NSString *user_finfishedMissionAmount;//完成任务数

NSString *projectid;//用户PID

NSString *stockopen;

NSString *AuthName;//认证名

NSString *AuthIdNumber;//认证证件号码

NSString *AuthAddress;//认证证件地址

#pragma mark ------SET/GET方法
+(void)setCellPhone:(NSString *)cellPhone;
{
    cellPhoneNumer = cellPhone;
}

+(NSString *)getCellPhone;
{
    return cellPhoneNumer;
}

+(void)setPWD:(NSString *)pwd;
{
    password = pwd;
}

+(NSString *)getPWD;
{
    return password;
}

+(void)setLOGO:(NSString *)logo;
{
    logoPicture = logo;
}

+(NSString *)getLOGO;
{
    return logoPicture;
}

+(void)setIdentity:(NSString *)identity;
{
    useridentity=identity;
}

+(NSString *)getIdentity;
{
    return useridentity;
}

+(void)setUserid:(NSString *)userid;
{
    userId = userid;
}

+(NSString *)getUserid;
{
    return userId;
}

+(void)setGold:(NSString *)usergold;
{
    userGold = usergold;
}

+(NSString *)getGold;
{
    return userGold;
}

+(void)setCompanyname:(NSString *)companyname;
{
    companyName = companyname;
}

+(NSString *)getCompanyname;
{
    return companyName;
}


+(void)setLoginSatuts:(NSString *)status;
{
    loginstatus = status;
}
+(NSString *)getLoginSatuts;
{
    return loginstatus;
}


+(void)setMobileitem:(NSString*)mobileitem;
{
    mobileitems = mobileitem;
}

+(NSString *)getMobileitem;
{
    return mobileitems;
}

+(void)setUserName:(NSString*)username;
{
    userName = username;
}

+(NSString *)getUserName;
{
    return userName;
}

+(void)setUserqq:(NSString*)qq;
{
    userqq = qq;
}

+(NSString *)getUserqq;
{
    return userqq;
}

+(void)setUsersex:(NSString*)sex;
{
    usersex = sex;
}

+(NSString*)getUsersex;
{
    return usersex;
}

+(void)setUseremail:(NSString*)email;
{
    useremail = email;
}

+(NSString*)getUseremail;
{
    return  useremail;
}

+(void)setUseraddress:(NSString*)address;
{
    useraddress = address;
}

+(NSString*)getUseraddress;
{
    return useraddress;
}

+(void)setUserjob:(NSString*)job;
{
    userjob = job;
}

+(NSString*)getUserjob;
{
    return userjob;
}

+(void)setSubjection:(NSString*)subject;
{
    subjection = subject;
}

+(NSString*)getSubjection;
{
    return subjection;
}

+(void)setState:(NSString*)state;
{
    country = state;
}

+(NSString*)getState;
{
    return country;
}

+(void)setContinent:(NSString*)contin;
{
    continent = contin;
}

+(NSString*)getContinent;
{
    return continent;
}

+(void)setPrefecture:(NSString*)prefect;
{
    prefecture = prefect;
}

+(NSString*)getPrefecture;
{
    return prefecture;
}

+(void)setCompany:(NSString*)comp;
{
    company = comp;
}

+(NSString*)getCompany;
{
    return company;
}

+(void)setExperience:(NSString*)exp;//经验
{
    experience = exp;
}

+(NSString*)getExperience;
{
    return experience;
}

+(void)setHonor:(NSString*)hon;//荣誉
{
    honor = hon;
}

+(NSString*)getHonor;
{
    return honor;
}

+(void)setRank:(NSString*)ran;//排名
{
    rank = ran;
}

+(NSString*)getRank;
{
    return  rank;
}

+(void)setLishu:(NSString*)li;//隶属
{
    lishu = li;
}

+(NSString*)getLishu;
{
    return lishu;
}

+(void)setUserDevicetoken:(NSString*)token;//令牌
{
    strtoken = token;
}

+(NSString*)getUserDevicetoken;
{
    return strtoken;
}

+(void)setUserprovince:(NSString *)province;//省
{
    userprovince = province;
}

+(NSString*)getsetUserprovince;
{
    return userprovince;
}

+(void)setUsercity:(NSString *)city;//市
{
    usercity = city;
}

+(NSString*)getsetUsercity;
{
    return usercity;
}

+(void)setUsercounty:(NSString *)county;//乡镇
{
    usercounty = county;
}

+(NSString*)getsetUsercounty;
{
    return usercounty;
}

+(void)setUseraddress1:(NSString *)address1;//街道
{
    useraddress1 = address1;
}

+(NSString*)getsetUseraddress1;
{
    return useraddress1;
}

+(void)setUserCellPhoneVersionnum:(NSString *)versionnum;
{
    userversion = versionnum;
}

+(NSString*)getUserCellPhoneVersionnum;
{
    return userversion;
}

+(void)setUserCellPhonePlatform:(NSString *)platform;
{
    userplatform = platform;
}

+(NSString*)getUserCellPhonePlatform;
{
    return userplatform;
}

+(void)setUserCellPhoneUDID:(NSString *)udid;
{
    userudid = udid;
}

+(NSString*)getUserCellPhoneUDID;
{
    return userudid;
}

+(void)setPushnotifiaction:(NSString *)message;
{
    pushnotification = message;
}

+(NSString*)getPushnotifiaction;
{
    return pushnotification;
}

+(void)setUserAlipayaccount:(NSString*)account;
{
    alipayaccount = account;
}

+(NSString*)getUserAlipayaccount;
{
    return alipayaccount;
}
+(void)setUserAlipayname:(NSString*)name;
{
    alipayname = name;
}

+(NSString*)getUserAlipayname;
{
    return alipayname;
}

+(void)setUserCautionmoney:(NSString*)money;
{
    cautionmoney = money;
}

+(NSString*)getUserCautionmoney;
{
    return cautionmoney;
}

+(void)setUserStockgold:(NSString *)stockgold;
{
    strStockgold = stockgold;
}

+(NSString*)getUserStockgold;
{
    return strStockgold;
}
+(void)setUserWorkState:(NSString *)workstate;{
    strWorkState = workstate;
}
+(NSString*)getUserWorkState;{
    return strWorkState;
}

+(void)setUserType:(NSString *)usertype;{
    strUserType = usertype;
}
+(NSString*)getUserType;{
    return strUserType;
}

+(void)setSelectMenu:(NSInteger)selected;{
    selectMenu = selected;
}

+(NSInteger)getSelectMenu;{
    return selectMenu;
}

+(void)setSelectRightMenu:(NSInteger)selected;{
    selectRightMenu = selected;
}

+(NSInteger)getSelectRightMenu;{
    return selectRightMenu;
}


+(void)setUserTGT:(NSString *)tgt;{
    user_sgt = tgt;
}

+(NSString*)getUserTGT;{
    return user_sgt;
}

//set st
+(void)setST:(NSString*)st;{
    user_st = st;
}

+(NSString*)getST;{
    return user_st;
}


+(void)setUseridentifier:(NSArray*)infoidentiarray;{
    use_infoImage = infoidentiarray;
}
+(NSArray*)getUseridentifier;{
    return use_infoImage;
}


+(void)setUsernewMissionAmount:(NSString*)amount;//新任务数量
{
    user_newMissionAmount = amount;
}
+(NSString*)getUsernewMissionAmount;{
    return user_newMissionAmount;
}

+(void)setUserdoingMissionAmount:(NSString*)amount;//未完成任务数量
{
    user_doingMissionAmount = amount;
}
+(NSString*)getUserdoingMissionAmount;{
    return user_doingMissionAmount;
}

+(void)setUserIMmessageAmount:(NSString*)amount;//im未读消息数量
{
    user_imMessageAmount = amount;
}
+(NSString*)getUserIMmessageAmount;
{
    return user_imMessageAmount;
}

+(void)setUserRealauth:(NSString*)auth;//实名验证
{
    user_realauth = auth;
}
+(NSString*)getUserRealauth;{
    return user_realauth;
}

+(void)setUserInfoArray:(NSMutableArray*)infoarray;{
    use_infos = infoarray;
}
+(NSMutableArray*)getUserInfoArray;{
    return use_infos;
}

+(void)setUserHeadUrl:(NSString*)head;{
    user_head = head;

}

+(NSString *)getUserHeadUrl;{

    return user_head;

}


+(void)setUserFinfishedMissionAmount:(NSString *)amount;{

    user_finfishedMissionAmount = amount;

}

+(NSString *)getUserFinfishedMissionAmount;{

    return user_finfishedMissionAmount;

}

+(void)setProjectid:(NSString *)pid;
{
    projectid = pid;
}

+(NSString *)getProjectid;
{
    return projectid;
}

NSString *isMobBind;

+(void)setUserMob_bind:(NSString*)mobBind;//实名认证
{

    isMobBind = mobBind;

}

+(NSString *)getUserMob_bind;
{

    return isMobBind;

}


NSString *isPayBind;

+(void)setUserPay_bind:(NSString*)paybBind;//是否开户
{

    isPayBind = paybBind;

}

+(NSString *)getUserPay_bind;
{
    return isPayBind;


}

NSString *red_count;

+(void)setRed_count:(NSString*)redcount;//红包数量
{

    red_count = redcount;

}
+(NSString *)getRed_count;
{

    return  red_count;


}



NSString *red_money;

+(void)setUserRed_money:(NSString*)redmoney;//红包金钱
{

    red_money = redmoney;

}

+(NSString *)getRed_money;
{

    return red_money;

}




NSString *visitorCode;
+(void)setVisitor_code:(NSString*)visitor_code;//推广码
{

    visitorCode = visitor_code;

}




+(NSString *)getVisitor_code;{
    
    return visitorCode;
}
+(void)setStock_open:(NSString*)open;//推广码
{
    stockopen = open;
}

+(NSString *)getStock_open;{
    return stockopen;
}


+(void)setAuthName:(NSString *)Auth_Name
{
    AuthName = Auth_Name;
}


+(NSString *)getAuth_Name{
    return  AuthName;
}

+(void)setAuthIdNumber:(NSString *)Auth_IdNumber
{
    AuthIdNumber = Auth_IdNumber;
    
}



+(NSString *)getAuth_IdNumber{
    
    return AuthIdNumber;
    
}


+(void)setAuthAddress:(NSString *)Auth_Address{
    
    AuthAddress = Auth_Address;
}

+(NSString *)getAuth_Address{
    
    return AuthAddress;
}

UIImage *imagefront;

+(void)setAuthFrontImage:(UIImage *)Front_image{
    
    imagefront = Front_image;
}

+(UIImage *)getFront_image{
    
    return imagefront;
}

UIImage *imageBack;

+(void)setAuthBackImage:(UIImage *)Back_image{
    
    imageBack = Back_image;
}

+(UIImage *)getBack_image{
    
    return imageBack;
}


NSInteger MissionType;
+(void)setMissionType:(NSInteger)type;{
    MissionType = type;
}
+(NSInteger)getMissionType;{
    return MissionType;
}

NSString *net_work;
+(void)setNetWork:(NSString *)strNetWork{
    net_work = strNetWork;
    
}

+(NSString *)getNetWork{
    
    return net_work;
}
NSString *strApply;
+(void)setApply:(NSString*)apply;{
    strApply = apply;
}
+(NSString*)getApply;{
    return strApply;
}


@end
