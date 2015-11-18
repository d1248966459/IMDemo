//
//  MainTabController.m
//  NIMDemo
//
//  Created by chris on 15/2/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESMainTabController.h"
#import "AppDelegate.h"
#import "NTESSessionListViewController.h"
#import "NTESContactViewController.h"
#import "NIMSDK.h"
#import "UIImage+NTESColor.h"
#import "NTESCustomNotificationDB.h"
#import "NTESNotificationCenter.h"
//#import "DDMenuController.h"
//#import "TransitionAnimationPage.h"
#import "NTESLoginManager.h"
//#import "NavigationViewController.h"
#import "UpdateManager.h"
#define TabbarVC    @"vc"
#define TabbarTitle @"title"
#define TabbarImage @"image"
#define TabbarSelectedImage @"selectedImage"
#define TabbarItemBadgeValue @"badgeValue"

@interface NTESMainTabController ()<NIMSystemNotificationManagerDelegate,NIMConversationManagerDelegate,UINavigationControllerDelegate>

@property (nonatomic,assign) NSInteger sessionUnreadCount;

@property (nonatomic,assign) NSInteger systemUnreadCount;

@property (nonatomic,assign) NSInteger customSystemUnreadCount;

@end

@implementation NTESMainTabController

+ (instancetype)instance{
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegete.window.rootViewController;
    if ([vc isKindOfClass:[NTESMainTabController class]]) {
        return (NTESMainTabController *)vc;
    }else{
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubNav];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    extern NSString *NTESCustomNotificationCountChanged;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCustomNotifyChanged:) name:NTESCustomNotificationCountChanged object:nil];
    
    [[UpdateManager shareInstance] checkVersion];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpStatusBar];
    [self checkOtherLogin];
//    [self setTransitionAnimation];
}
-(void)checkOtherLogin{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray * loginArr = [NIMSDK sharedSDK].loginManager.currentLoginClients;
        [loginArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NIMLoginClient * client = obj;
//            if (client.type == NIMLoginClientTypeAOS||client.type == NIMLoginClientTypeIOS) {
//                __weak typeof(self) wself = self;
                [[NIMSDK sharedSDK].loginManager kickOtherClient:client completion:^(NSError *error) {
                    
                }];
                
//            }
        }];
    });
}

-(void)viewWillLayoutSubviews
{
    self.view.frame = [UIScreen mainScreen].bounds;
}


- (void)dealloc{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setTransitionAnimation{
//    LoginData *data = [[NTESLoginManager sdkManager] currentLoginData];
//    NSString *account = [data account];
//    NSString *token = [data token];
//    if ([account length] && [token length]) {
//        [TransitionAnimationPage hideTransitionAnimationViewForView:self.view];
//    }else{
//        [TransitionAnimationPage showTransitionAnimationToView:self.view];
//        
//    }
    
    
}
- (NSArray*)tabbars{
    self.sessionUnreadCount  = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
    self.systemUnreadCount   = [NIMSDK sharedSDK].systemNotificationManager.allUnreadCount;
    self.customSystemUnreadCount = [[NTESCustomNotificationDB sharedInstance] unreadCount];
    NSArray *item = @[
                      @{
                          TabbarVC           : @"NTESSessionListViewController",
                          TabbarTitle        : @"会话",
                          TabbarImage        : @"icon_message_normal",
                          TabbarSelectedImage: @"icon_message_pressed",
                          TabbarItemBadgeValue: @(self.sessionUnreadCount)
                          },
                      @{
                          TabbarVC           : @"NTESContactViewController",
                          TabbarTitle        : @"联系人",
                          TabbarImage        : @"icon_contact_normal",
                          TabbarSelectedImage: @"icon_contact_pressed",
                          TabbarItemBadgeValue: @(self.systemUnreadCount)
                          },
                      @{
                          TabbarVC           : @"NTESSettingViewController",
                          TabbarTitle        : @"设置",
                          TabbarImage        : @"icon_setting_normal",
                          TabbarSelectedImage: @"icon_setting_pressed",
                          TabbarItemBadgeValue: @(self.customSystemUnreadCount)
                          },

                      ];
     return item;
}
//- (void)setUpSubNav{
//    NSMutableArray * array = [[NSMutableArray alloc] init];
//    [self.tabbars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSDictionary * item = obj;
//        NSString * vcName = item[TabbarVC];
//        NSString * title  = item[TabbarTitle];
//        NSString * imageName = item[TabbarImage];
//        NSString * imageSelected = item[TabbarSelectedImage];
//        Class clazz = NSClassFromString(vcName);
//        UIViewController * vc = [[clazz alloc] initWithNibName:nil bundle:nil];
//        vc.hidesBottomBarWhenPushed = NO;
//        
//        [Common setTabbarItem:vc title:title image:imageName selectedImage:imageSelected index:idx];
//        NSInteger badge = [item[TabbarItemBadgeValue] integerValue];
//        if (badge) {
//            vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",badge];
//        }
//        [array addObject:vc];
//    }];
//    self.viewControllers = array;
//}

- (void)setUpSubNav{
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [self.tabbars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary * item = obj;
        NSString * vcName = item[TabbarVC];
        NSString * title  = item[TabbarTitle];
        NSString * imageName = item[TabbarImage];
        NSString * imageSelected = item[TabbarSelectedImage];
        Class clazz = NSClassFromString(vcName);
        UIViewController * vc = [[clazz alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = NO;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.delegate = self;
        UIImage *selectedImage = [UIImage imageNamed:imageSelected];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                       image:[UIImage imageNamed:imageName]
                                               selectedImage:selectedImage];
        [nav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor fromHexValue:0xFF3366], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        nav.tabBarItem.tag = idx;
        NSInteger badge = [item[TabbarItemBadgeValue] integerValue];
        if (badge) {
            nav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",badge];
        }
        [array addObject:nav];
    }];
    self.viewControllers = array;
}

#warning 状态栏设置
- (void)setUpStatusBar{
//    UIStatusBarStyle style = UIStatusBarStyleDefault;
//    [[UIApplication sharedApplication] setStatusBarStyle:style
//                                                animated:NO];
}

#pragma mark - NIMConversationManagerDelegate
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}


- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}


- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}

- (void)messagesDeletedInSession:(NIMSession *)session{
    self.sessionUnreadCount = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
    [self refreshSessionBadge];
}

- (void)allMessagesDeleted{
    self.sessionUnreadCount = 0;
    [self refreshSessionBadge];
}

#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount
{
    self.systemUnreadCount = unreadCount;
    [self refreshContactBadge];
}

#pragma mark - Notification
- (void)onCustomNotifyChanged:(NSNotification *)notification
{
    NTESCustomNotificationDB *db = [NTESCustomNotificationDB sharedInstance];
    self.customSystemUnreadCount = db.unreadCount;
    [self refreshSettingBadge];
}



- (void)refreshSessionBadge{
    UINavigationController *nav = self.viewControllers[0];
    nav.tabBarItem.badgeValue = self.sessionUnreadCount ? @(self.sessionUnreadCount).stringValue : nil;
}

- (void)refreshContactBadge{
    UINavigationController *nav = self.viewControllers[1];
    NSInteger badge = self.systemUnreadCount;
    nav.tabBarItem.badgeValue = badge ? @(badge).stringValue : nil;
}

- (void)refreshSettingBadge{
    UINavigationController *nav = self.viewControllers[2];
    NSInteger badge = self.customSystemUnreadCount;
    nav.tabBarItem.badgeValue = badge ? @(badge).stringValue : nil;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


@end
