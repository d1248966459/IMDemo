//
//  Userinfo.h
//  MobileUU
//
//  Created by 王義傑 on 14-5-30.
//  Copyright (c) 2014年 Shanghai Pecker Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Userinfo : NSObject

+(void)setSelectRightMenu:(NSInteger)selected;

+(NSInteger)getSelectRightMenu;

+(void)setSelectMenu:(NSInteger)selected;

+(NSInteger)getSelectMenu;

+ (id) sharedInstance;

+(void)setCellPhone:(NSString *)cellPhone;

+(NSString *)getCellPhone;

+(void)setPWD:(NSString *)pwd;

+(NSString *)getPWD;

+(void)setLOGO:(NSString *)logo;

+(NSString *)getLOGO;

+(void)setIdentity:(NSString *)identity;//身份

+(NSString *)getIdentity;

+(void)setUserid:(NSString *)userid;

+(NSString *)getUserid;

+(void)setGold:(NSString *)usergold;

+(NSString *)getGold;

+(void)setCompanyname:(NSString *)companyname;

+(NSString *)getCompanyname;

+(void)setLoginSatuts:(NSString *)status;

+(NSString *)getLoginSatuts;

+(void)setProjectid:(NSString *)pid;

+(NSString *)getProjectid;

+(void)setMobileitem:(NSString*)mobileitem;

+(NSString *)getMobileitem;

+(void)setUserName:(NSString*)username;//昵称

+(NSString *)getUserName;

+(void)setUserqq:(NSString*)qq;

+(NSString *)getUserqq;

+(void)setUsersex:(NSString*)sex;

+(NSString*)getUsersex;

+(void)setUseremail:(NSString*)email;

+(NSString*)getUseremail;

+(void)setUseraddress:(NSString*)address;

+(NSString*)getUseraddress;

+(void)setUserjob:(NSString*)job;

+(NSString*)getUserjob;

+(void)setSubjection:(NSString*)subject;

+(NSString*)getSubjection;

+(void)setState:(NSString*)state;//国

+(NSString*)getState;

+(void)setContinent:(NSString*)contin;//州

+(NSString*)getContinent;

+(void)setPrefecture:(NSString*)prefect;//郡

+(NSString*)getPrefecture;

+(void)setCompany:(NSString*)comp;//府

+(NSString*)getCompany;

+(void)setExperience:(NSString*)exp;//经验

+(NSString*)getExperience;

+(void)setHonor:(NSString*)hon;//荣誉

+(NSString*)getHonor;

+(void)setRank:(NSString*)ran;//排名

+(NSString*)getRank;

+(void)setLishu:(NSString*)li;//隶属

+(NSString*)getLishu;

+(void)setUserDevicetoken:(NSString*)token;//令牌

+(NSString*)getUserDevicetoken;

+(void)setUserprovince:(NSString *)province;//省

+(NSString*)getsetUserprovince;

+(void)setUsercity:(NSString *)city;//市

+(NSString*)getsetUsercity;

+(void)setUsercounty:(NSString *)county;//乡镇

+(NSString*)getsetUsercounty;

+(void)setUseraddress1:(NSString *)address1;//街道

+(NSString*)getsetUseraddress1;

+(void)setUserCellPhoneVersionnum:(NSString *)versionnum;

+(NSString*)getUserCellPhoneVersionnum;

+(void)setUserCellPhonePlatform:(NSString *)platform;

+(NSString*)getUserCellPhonePlatform;

+(void)setUserCellPhoneUDID:(NSString *)udid;

+(NSString*)getUserCellPhoneUDID;

+(void)setPushnotifiaction:(NSString *)message;

+(NSString*)getPushnotifiaction;

+(void)setUserAlipayaccount:(NSString*)account;

+(NSString*)getUserAlipayaccount;

+(void)setUserAlipayname:(NSString*)name;

+(NSString*)getUserAlipayname;

+(void)setUserCautionmoney:(NSString*)money;

+(NSString*)getUserCautionmoney;

+(void)setUserStockgold:(NSString *)stockgold;

+(NSString*)getUserStockgold;

+(void)setUserWorkState:(NSString *)workstate;

+(NSString*)getUserWorkState;

+(void)setUserType:(NSString *)usertype;

+(NSString*)getUserType;

+(void)setUserTGT:(NSString *)tgt;

+(NSString*)getUserTGT;

+(void)setST:(NSString*)st;

+(NSString*)getST;

+(void)setUseridentifier:(NSArray*)infoidentiarray;//用户身份

+(NSArray*)getUseridentifier;

+(void)setUsernewMissionAmount:(NSString*)amount;//新任务数量

+(NSString*)getUsernewMissionAmount;

+(void)setUserdoingMissionAmount:(NSString*)amount;//未完成任务数量

+(NSString*)getUserdoingMissionAmount;

+(void)setUserIMmessageAmount:(NSString*)amount;//im未读消息数量

+(NSString*)getUserIMmessageAmount;

+(void)setUserRealauth:(NSString*)auth;//是否通过实名认证

+(NSString*)getUserRealauth;


+(void)setUserInfoArray:(NSArray*)infoarray;

+(NSArray*)getUserInfoArray;


+(void)setUserHeadUrl:(NSString*)head;//用户头像URL

+(NSString *)getUserHeadUrl;


+(void)setUserFinfishedMissionAmount:(NSString*)amount;//完成任务数量

+(NSString *)getUserFinfishedMissionAmount;


+(void)setUserMob_bind:(NSString*)mobBind;//手机绑定

+(NSString *)getUserMob_bind;



+(void)setUserPay_bind:(NSString*)paybBind;//是否绑定支付宝

+(NSString *)getUserPay_bind;


+(void)setRed_count:(NSString*)redcount;//红包数量

+(NSString *)getRed_count;


+(void)setUserRed_money:(NSString*)redmoney;//红包金钱

+(NSString *)getRed_money;


+(void)setVisitor_code:(NSString*)visitor_code;//推广码

+(NSString *)getVisitor_code;

+(void)setStock_open:(NSString*)open;//推广码

+(NSString *)getStock_open;

+(void)setAuthName:(NSString *)Auth_Name;

+(NSString *)getAuth_Name;

+(void)setAuthIdNumber:(NSString *)Auth_IdNumber;

+(NSString *)getAuth_IdNumber;

+(void)setAuthAddress:(NSString *)Auth_Address;

+(NSString *)getAuth_Address;

+(void)setAuthFrontImage:(UIImage *)Front_image;

+(UIImage *)getFront_image;

+(void)setAuthBackImage:(UIImage *)Back_image;

+(UIImage *)getBack_image;

+(void)setMissionType:(NSInteger)type;
+(NSInteger)getMissionType;

+(void)setNetWork:(NSString *)strNetWork;

+(NSString *)getNetWork;

+(void)setApply:(NSString*)apply;
+(NSString*)getApply;



@end
