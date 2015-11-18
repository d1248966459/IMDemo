//
//  InterfaceURLs.h
//  MobileUU
//
//  Created by 王義傑 on 15/5/6.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterfaceURLs : NSObject

//extern NSString * const strUtouu;

extern NSString * const strIMAPI;

extern NSString * const strPicture;

extern NSString * const strLoginURL;

extern NSString * const strLogoutURL;

extern NSString * const strStockSubService;

extern NSString * const strMissionListWithoutLogin;

extern NSString * const strUserMission;//新任务

extern NSString * const strPassport;

extern NSString * const strAccountLoginURL;

extern NSString * const strst;//获取st

extern NSString * const strUtouuAPI;
extern NSString * const strUtouuAPI2;

extern NSString * const struser_baseinfo;//用户基本信息

extern NSString * const struser_detailinfo;//用户详细信息

extern NSString * const str_userphoto;//用户头像

extern NSString * const strMissionDetail;//任务详情

extern NSString * const strUserexperience;

extern NSString * const strGetQuestion;//获取问卷

extern NSString * const strUserSub;//提交答案

extern NSString * const strRegister;//注册

extern NSString * const strSMSPic;//获取验证码

extern NSString * const strCheckPic;//验证验证码

extern NSString * const strUserappreciate;//获取经验

extern NSString * const strRegisterResult;

extern NSString * const str_userbind;//手机绑定

extern NSString * const strRed_packet;//转红包

extern NSString * const strStatistics;//用户统计

extern NSString * const strUserIdentifier;//检查用户是否升级为布衣

extern NSString * const str_checkVersion;//版本检测

extern NSString * const str_check_photo;//检查用户能否上传图像

extern NSString * const str_upload_photo;//上传用户图像

extern NSString * const str_editInfo;//修改资料

extern NSString * const str_realnamestatus;//实名认证状态

extern NSString * const str_menuList;//菜单列表

extern NSString * const str_checkIsUpdate;//检查是否更新菜单


//=====================================================
//我的国家
//=====================================================
extern NSString * const strcountry;

extern NSString * const struser_info;//我的隶属

extern NSString * const struser_assets;//我的资产

extern NSString * const struser_deatil;//用户详情

extern NSString * const strunit_info;//单位信息

extern NSString * const strunit_statistics;//所辖府数及所辖人口

extern NSString * const strunit_users;//所辖人口

extern NSString * const strunit_userdelete;//驱除布衣；

extern NSString * const struser_missions;//获取用户任务

extern NSString * const strunit_population;

#pragma mark   有糖糖市
extern NSString * const strServer;
extern NSString * const strStockServer;
extern NSString * const strWebServer;
extern NSString * const WebService;
extern NSString * const strMarketList;//上市单位列表
extern NSString * const strfiveRange;
extern NSString * const strDetailInfo;
extern NSString * const strbuy;
extern NSString * const strsell;
extern NSString * const strcancel;
extern NSString * const strmyAccount;
extern NSString * const strstocklogin;
extern NSString * const strstockCancel;
extern NSString * const strMoneyOut;
extern NSString * const strMoneyIn;
extern NSString * const strTradeState;
extern NSString * const strtransfer;
extern NSString * const strrecords;
extern NSString * const strnewsStocklist;
extern NSString * const strhistorylist;
extern NSString * const strStockSub;
extern NSString * const strBoundsDay;
extern NSString * const strAccountStatu;
extern NSString * const str_openStockAccount;
extern NSString * const str_marketlistpage;
extern NSString * const str_stocklistfresh;
extern NSString * const str_optionalStock;
extern NSString * const str_validateStock;
extern NSString * const str_attentionStock;
extern NSString * const str_attentionfresh;
extern NSString * const str_deleteStock;
extern NSString * const str_requestId;
extern NSString * const str_availableBuyAmount;
extern NSString * const str_availableSaleAmount;
extern NSString * const str_user_checkin;
extern NSString * const str_purchased;//我的认购记录分页接口



#pragma mark 实名认证
extern NSString * const str_realnamestatus;//实名认证状态

extern NSString * const str_realnameIDtype;//证件类型查询

extern NSString * const str_IDPictures;//证件照上传

extern NSString * const str_realnamesubmit;//提交实名认证

#pragma mark 申购列表
extern NSString * const str_stock_subscription_list;//申购列表
extern NSString * const str_stock_subscription_record;//申购记录
extern NSString * const str_stock_subscription_detail;//认购详情
extern NSString * const str_stock_subscription_submit;//申购接口

#pragma mark -人才市场接口
extern NSString *const job_want_info_mobile_info; //求职信息
extern NSString *const  job_want_info_mobile_recruits;//招聘信息查询及招聘详细
extern NSString *const job_want_info_mobile_manage;//求职管理
extern NSString *const job_want_info_mobile_join;//是否同意加入征兵队伍
extern NSString *const job_want_info_mobile_agreeTalentRecruit;//同意招募
extern NSString *const job_want_info_mobile_reject;//拒绝招募

#pragma mark - im
extern NSString * const str_login;//获取accid和token
extern NSString * const str_check_join_group;//检查该群是否可以加入
extern NSString * const str_serach_im_account;//根据昵称查找im帐号

extern NSString * const changePassWord;

extern NSString * const sendSMS;

extern NSString * const checkSMSCode;


@end
