//
//  UTMainTabbarController.m
//  UTChat
//
//  Created by dcj on 15/11/6.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "UTMainTabbarController.h"
#import "NIMKit.h"
#import "AppDelegate.h"
#import "NTESCustomNotificationDB.h"


#define TabbarVC    @"vc"
#define TabbarTitle @"title"
#define TabbarImage @"image"
#define TabbarSelectedImage @"selectedImage"
#define TabbarItemBadgeValue @"badgeValue"
@interface UTMainTabbarController ()<NIMSystemNotificationManagerDelegate,NIMConversationManagerDelegate,UINavigationControllerDelegate>

@property (nonatomic,assign) NSInteger sessionUnreadCount;

@property (nonatomic,assign) NSInteger systemUnreadCount;

@property (nonatomic,assign) NSInteger customSystemUnreadCount;

@end

@implementation UTMainTabbarController

+(instancetype)instance{
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegete.window.rootViewController;
    if ([vc isKindOfClass:[UTMainTabbarController class]]) {
        return (UTMainTabbarController *)vc;
    }else{
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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


- (NSArray*)tabbars{
    self.sessionUnreadCount  = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
    self.systemUnreadCount   = [NIMSDK sharedSDK].systemNotificationManager.allUnreadCount;
    self.customSystemUnreadCount = [[NTESCustomNotificationDB sharedInstance] unreadCount];
    NSArray *item = @[
                      @{
                          TabbarVC           : @"NTESSessionListViewController",
                          TabbarTitle        : @"有糖",
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
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                       image:[UIImage imageNamed:imageName]
                                               selectedImage:[UIImage imageNamed:imageSelected]];
        nav.tabBarItem.tag = idx;
        NSInteger badge = [item[TabbarItemBadgeValue] integerValue];
        if (badge) {
            nav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",badge];
        }
        [array addObject:nav];
    }];
    self.viewControllers = array;
}

@end
