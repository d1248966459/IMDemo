//
//  InterfaceURLs.m
//  MobileUU
//==================================
//1.0更新新接口 万黎君
//1.1增加问题列表接口   万黎君
//==================================
//  Created by 王義傑 on 15/5/6.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//  提交测试

#import "InterfaceURLs.h"

@implementation InterfaceURLs

#pragma mark ------服务器地址(单一数据）------ 生产
NSString * const strPicture = @"http://cdn1.utouu.com";//图片
NSString * const strUtouuAPI = @"http://api.utouu.com/v1/";
NSString * const strPassport = @"https://passport.utouu.com/";
NSString * const strcountry = @"http://api.nms.utouu.com/";
NSString * const strServer = @"http://api.utouu.com/mobile/v1/";
NSString * const strStockServer = @"http://api.stock.utouu.com/";
NSString * const strWebServer = @"http://stock.utouu.com/";
NSString * const strRegister = @"http://msg.utouu.com/";//注册
NSString * const WebService = @"http://m.utouu.com/";
NSString * const strStockSubService = @"http://api.utouu.com/mobile/v1/";
NSString * const strUtouuAPI2 = @"http://api.utouu.com/v2/";
NSString * const strIMAPI = @"http://srv.im.utouu.com/";

#pragma mark ------服务器地址(单一数据）------ 开发
//NSString * const strPicture = @"http://cdn1.utouu.com";//图片
//NSString * const strUtouuAPI = @"http://api.dev.utouu.com/v1/";
//NSString * const strUtouuAPI2 = @"http://api.dev.utouu.com/v2/";
//NSString * const strPassport = @"https://passport.dev.utouu.com/";
//NSString * const strcountry = @"http://api.nms.dev.utouu.com/";
//NSString * const strStockServer = @"http://api.stock.dev.utouu.com/";
//NSString * const strWebServer = @"http://stock.utouu.dev.com/";
//NSString * const strRegister = @"http://msg.dev.utouu.com/";//注册
//NSString * const strStockSubService = @"http://api.dev.utouu.com/mobile/v1/";
//NSString * const WebService = @"http://m.dev.utouu.com/";
//NSString * const strIMAPI = @"http://srv.im.dev.utouu.com/";

#pragma mark ------服务器地址(单一数据）------ 测试
//NSString * const strPicture = @"http://cdn1.utouu.com";//图片
//NSString * const strUtouuAPI = @"http://api.test.utouu.com/v1/";
//NSString * const strPassport = @"https://passport.test.utouu.com/";
//NSString * const strcountry = @"http://api.nms.test.utouu.com/";
//NSString * const strStockServer = @"http://api.stock.test.utouu.com/";
//NSString * const strWebServer = @"http://stock.test.utouu.com/";
//NSString * const strRegister = @"http://msg.test.utouu.com/";//注册
//NSString * const strStockSubService = @"http://api.test.utouu.com/mobile/v1/";
//NSString * const WebService = @"http://m.test.utouu.com/";
//NSString * const strUtouuAPI2 = @"http://api.test.utouu.com/v2/";
//NSString * const strIMAPI = @"http://srv.im.test.utouu.com/";

#pragma mark ------服务器地址（多数据整合来源）------
#pragma mark ------图片地址------

#pragma mark ------passport地址------

#pragma mark ------接口地址------
NSString * const strLoginURL = @"account/newlogin";//登陆

NSString * const strRegisterResult = @"api/v1/account/register";//注册

NSString * const strMissionListWithoutLogin = @"mission/list";//未登录任务

NSString * const strUserMission=@"user/missions";//新任务

NSString * const strAccountLoginURL = @"m1/tickets";//登录接口

NSString * const strst = @"m1/tickets";//获取ST

NSString * const struser_baseinfo = @"user/info";//用户基本信息

NSString * const struser_detailinfo = @"user/detail";//用户详细信息

NSString * const str_userphoto = @"/picture/userphoto/";//用户头像

NSString * const strMissionDetail=@"mission/detail/";//任务详情

NSString * const strUserexperience = @"mission/appreciate/";//经验

NSString * const strGetQuestion=@"mission/questionnaire/";//获取问卷

NSString * const strUserSub=@"mission/commit";

NSString * const strSMSPic = @"v1/img/vcode";//获取验证码

NSString * const strCheckPic = @"v1/img/vcode/validate";//验证验证码

NSString * const strUserappreciate = @"mission/appreciate/";//预览获取经验

NSString * const str_userbind = @"profile/mobile/bind?platform=app&ticket=";//手机 绑定

NSString * const strRed_packet =@"redpacket/";//转红包

NSString * const strStatistics =@"user/statistics";//用户统计

NSString * const strUserIdentifier = @"user/check-upgrade";

NSString * const str_checkVersion = @"version/ios-p";//检测版本-企业版

//NSString * const str_checkVersion = @"version/ios";//检测版本－appstore版

NSString * const str_upload_photo = @"user/photo/upload";//上传用户图像

NSString * const str_check_photo = @"user/photo/check";//检查用户能否上传图像

NSString * const str_editInfo = @"profile/info?platform=app&ticket=";//修改信息
NSString * const str_menuList = @"menu/list-ios-p";//获取菜单列表
NSString * const str_checkIsUpdate = @"data/version-ios-p";//检查是否更新菜单列表



/*我的国家*/


NSString * const struser_info = @"user/info";//我的隶属

NSString * const struser_assets = @"user/assets";//我的资产

NSString * const struser_deatil = @"user/detail" ;//用户详情

NSString * const strunit_info = @"unit/info";//单位信息

NSString * const strunit_statistics = @"unit/statistics";//所辖府数及所辖人口

NSString * const strunit_users = @"unit/users";//所辖人口

NSString * const strunit_userdelete = @"unit/delete-user";//驱除布衣；

NSString * const struser_missions = @"user/missions";//获取用户任务

NSString * const strunit_population = @"unit/centurion-population";//所辖百夫长人口数

#pragma mark   有糖糖市
NSString * const strMarketList = @"unit/marketList";//糖市列表

NSString * const strfiveRange = @"unit/fiveRange";//五档数据

NSString * const strDetailInfo = @"unit/detailInfo";//糖票详情及交易明细

NSString * const strbuy = @"trade/buy";//买入糖票

NSString * const strsell = @"trade/sell";//卖出糖票

NSString * const strcancell = @"trade/cancel";//撤销挂单

NSString * const strmyAccount = @"myAccount/info";//糖票账户信息及持股列表及挂单信息

NSString * const strstocklogin = @"token/get";

NSString * const strstockCancel = @"trade/cancel";

NSString * const strMoneyOut = @"myAccount/transferMoneyOut";//糖票资金转出

NSString * const strMoneyIn = @"myAccount/transferMoneyIn";//糖票资金转入

NSString * const strTradeState = @"getStsConfig";//获取糖市状态

NSString * const strtransfer = @"mobile/transfer?t=";//

NSString * const strrecords = @"mobile/records?ticket=";

NSString * const strnewsStocklist = @"newstock/newstocklist";

NSString * const strhistorylist = @"newstock/newstockrecord";

NSString * const strStockSub = @"newstock/buynewstock";

NSString * const strBoundsDay = @"unit/getBounsDay";//分糖日

NSString * const strAccountStatu = @"myAccount/status";//糖票账户状态

NSString * const str_openStockAccount = @"mobile/openAccountView?ticket=";//开通糖票账户

NSString * const str_marketlistpage = @"unit/listpage";//糖票分页列表

NSString * const str_stocklistfresh = @"unit/split-list";//糖市列表刷新

NSString * const str_optionalStock = @"attention/add";//添加自选糖票

NSString * const str_validateStock = @"attention/validate";//验证糖票是否持有或收藏

NSString * const str_attentionStock = @"attention/listpage";//糖票自选

NSString * const str_attentionfresh = @"attention/split-list";//自选糖票刷新

NSString * const str_deleteStock = @"attention/del";//删除自选糖票

NSString * const str_requestId = @"request/id";//获取请求id

NSString * const str_availableBuyAmount = @"trade/calcAvailableBuyAmount";//可买量

NSString * const str_availableSaleAmount = @"trade/calcAvailableSellAmount";//可卖量

NSString * const str_user_checkin = @"user/checkin";

NSString * const str_purchased = @"subscription/my-listpage";//我的认购记录分页接口

NSString * const str_realnamestatus = @"certify/status";//实名认证状态

NSString * const str_realnameIDtype = @"certify/types";//证件类型查询

NSString * const str_IDPictures = @"certify/upload";//证件照上传

NSString * const str_realnamesubmit = @"certify/commit";//提交实名认证


#pragma mark - 申购接口
NSString * const str_stock_subscription_list = @"subscription/list";//申购列表
NSString * const str_stock_subscription_record = @"subscription/my-listpage";//申购记录
NSString * const str_stock_subscription_detail = @"subscription/detail";//认购详情
NSString * const str_stock_subscription_submit = @"subscription/submit";//申购接口

#pragma mark _人才市场接口
NSString *const job_want_info_mobile_info=@"job-want-info-mobile/info-list"; //求职信息
NSString *const job_want_info_mobile_recruits=@"job-want-info-mobile/recruits-list";//招聘信息查询及招聘详细
NSString *const job_want_info_mobile_manage=@"job-want-info-mobile/manage";//求职管理
NSString *const job_want_info_mobile_join=@"job-want-info-mobile/is-join-conscripts";//是否同意加入征兵队伍
NSString *const job_want_info_mobile_agreeTalentRecruit=@"job-want-info-mobile/agreeTalentRecruit";//同意招募
NSString *const job_want_info_mobile_reject=@"job-want-info-mobile/reject";//拒绝招募

#pragma mark _im
NSString * const str_login             = @"api/login-dispatcher";
NSString * const str_check_join_group  = @"api/v1/team/check?tid=";
NSString * const str_serach_im_account = @"api/v1/user/getAccIdByNickName";

NSString * const changePassWord = @"api/user/forget-mod-pwd";//参数 oldPwd 旧密码 newPwd 新密码  source 数据源(传与登陆相同的source)
NSString * const sendSMS = @"forget/sendSms";
NSString * const checkSMSCode = @"forget/check-sms-vcode";

@end

