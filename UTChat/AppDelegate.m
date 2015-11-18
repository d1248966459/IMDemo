//
//  AppDelegate.m
//  UTChat
//
//  Created by dcj on 15/11/6.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "AppDelegate.h"
#import "NIMSDK.h"
#import "UIView+Toast.h"
#import "NTESService.h"
#import "NTESNotificationCenter.h"
#import "NTESLogManager.h"
#import "NTESDemoConfig.h"
#import "NTESAppTokenManager.h"
#import "NTESSessionUtil.h"
#import "NTESMainTabController.h"
#import "NTESLoginManager.h"
#import "NTESCustomAttachmentDecoder.h"
#import "NTESClientUtil.h"
#import "NTESNotificationCenter.h"
#import "NIMKit.h"
#import "NTESDataProvider.h"
#import "LoginViewController.h"
NSString *NTESNotificationLogout = @"NTESNotificationLogout";


@interface AppDelegate ()<NIMLoginManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self setLogin];

    //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
//    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if(sysVer < 8){
//        [self registerPush];
//    }
//    else{
        [self registerPushForIOS8];
//    }
#else
    //iOS8之前注册push方法
    //注册Push服务，注册后才能收到推送
    [self registerPush];
#endif

//    [self registerAPNs];
    [self.window makeKeyAndVisible];
    [self setupServices];
    
    [self commonInitListenEvents];
    [self setupMainViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor grayColor];
    [self.window makeKeyAndVisible];
//    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self setupMainViewController];
    
    return YES;
}



#pragma mark -获取设备令牌
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    DDLogDebug(@"receive remote notification:  %@", userInfo);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DDLogDebug(@"fail to get apns token :%@",error);
}

- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = @"INVITE_CATEGORY";
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= _IPHONE80_

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#endif

}
- (void)registerAPNs
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |         UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound |         UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
}

-(void)setLogin{
    NSString *appKey = [[NTESDemoConfig sharedConfig] appKey];
    NSString *cerName= [[NTESDemoConfig sharedConfig] cerName];
    
    [[NIMSDK sharedSDK] registerWithAppID:appKey
                                  cerName:cerName];
    [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];
    
    [[NIMKit sharedKit] setProvider:[NTESDataProvider new]];

}
- (void)setupMainViewController
{
    LoginData *data = [[NTESLoginManager sdkManager] currentLoginData];
    NSString *account = [data account];
    NSString *token = [data token];
    
    //如果有缓存用户名密码推荐使用自动登录
    if ([account length] && [token length])
    {
        [[[NIMSDK sharedSDK] loginManager] autoLogin:account
                                               token:token];
        [[NTESServiceManager sharedManager] start];
        NTESMainTabController *mainTab = [[NTESMainTabController alloc] initWithNibName:nil bundle:nil];
        self.window.rootViewController = mainTab;
    }
    else
    {
        [self setupLoginViewController];
    }
}

- (void)commonInitListenEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:)
                                                 name:NTESNotificationLogout
                                               object:nil];
    
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
}

- (void)setupLoginViewController
{
    LoginViewController *loginController = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
    self.window.rootViewController = nav;
}


#pragma mark - 注销
-(void)logout:(NSNotification*)note
{
    [self doLogout];
}

- (void)doLogout
{
    [[NTESLoginManager sdkManager] setCurrentLoginData:nil];
    [[NTESLoginManager appManager] setCurrentLoginData:nil];
    [[NTESAppTokenManager sharedManager] cleanAppToken];
    [[NTESServiceManager sharedManager] destory];
    [self setupLoginViewController];
}


#pragma NIMLoginManagerDelegate
-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    NSString *reason = @"你被踢下线";
    switch (code) {
        case NIMKickReasonByClient:
        case NIMKickReasonByClientManually:{
            NSString *clientName = [NTESClientUtil clientName:clientType];
            reason = clientName.length ? [NSString stringWithFormat:@"你的帐号被%@端踢出下线，请注意帐号信息安全",clientName] : @"你的帐号被踢出下线，请注意帐号信息安全";
            break;
        }
        case NIMKickReasonByServer:
            reason = @"你被服务器踢下线";
            break;
        default:
            break;
    }
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)onAutoLoginFailed:(NSError *)error
{
    //添加密码出错等引起的自动登录错误处理
    if ([error code] == NIMRemoteErrorCodeInvalidPass ||
        [error code] == NIMRemoteErrorCodeExist)
    {
        [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
        }];
    }
}


#pragma mark - logic impl
- (void)setupServices
{
    [[NTESLogManager sharedManager] start];
    [[NTESNotificationCenter sharedCenter] start];
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}



@end
