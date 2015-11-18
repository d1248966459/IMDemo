//
//  NTESNotificationCenter.m
//  NIM
//
//  Created by Xuhui on 15/3/25.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESNotificationCenter.h"
#import "NTESVideoChatViewController.h"
#import "NTESAudioChatViewController.h"
#import "NTESMainTabController.h"
#import "NTESSessionViewController.h"
#import "NSDictionary+NTESJson.h"
#import "NTESCustomNotificationDB.h"
#import "NTESCustomNotificationObject.h"
#import "UIView+Toast.h"
#import "NTESWhiteboardViewController.h"
#import "NTESCustomSysNotificationSender.h"


NSString *NTESCustomNotificationCountChanged = @"NTESCustomNotificationCountChanged";

@interface NTESNotificationCenter () <NIMSystemNotificationManagerDelegate,NIMNetCallManagerDelegate,NIMRTSManagerDelegate>

@end

@implementation NTESNotificationCenter

+ (instancetype)sharedCenter
{
    static NTESNotificationCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESNotificationCenter alloc] init];
    });
    return instance;
}

- (void)start
{
    DDLogInfo(@"Notification Center Setup");
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
        [[NIMSDK sharedSDK].netCallManager addDelegate:self];
        [[NIMSDK sharedSDK].rtsManager addDelegate:self];
    }
    return self;
}


- (void)dealloc{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].netCallManager removeDelegate:self];
    [[NIMSDK sharedSDK].rtsManager removeDelegate:self];
}

- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
    
    NSString *content = notification.content;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            if ([dict jsonInteger:NTESNotifyID] == NTESCustom)
            {
                //SDK并不会存储自定义的系统通知，需要上层结合业务逻辑考虑是否做存储。这里给出一个存储的例子。
                NTESCustomNotificationObject *object = [[NTESCustomNotificationObject alloc] initWithNotification:notification];
                //这里只负责存储可离线的自定义通知，推荐上层应用也这么处理，需要持久化的通知都走可离线通知
                if (!notification.sendToOnlineUsersOnly) {
                    [[NTESCustomNotificationDB sharedInstance] saveNotification:object];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:NTESCustomNotificationCountChanged object:nil];
                NSString *content  = [dict jsonString:NTESCustomContent];
                [[NTESMainTabController instance].selectedViewController.view makeToast:content duration:2.0 position:CSToastPositionCenter];
            }
        }
    }
}

#pragma mark - NIMNetCallManagerDelegate
- (void)onReceive:(UInt64)callID from:(NSString *)caller type:(NIMNetCallType)type{
    if ([NIMSDK sharedSDK].netCallManager.currentCallID > 0) {
        [[NIMSDK sharedSDK].netCallManager control:callID type:NIMNetCallControlTypeBusyLine];
        return;
    };
    UIViewController *vc;
    switch (type) {
        case NIMNetCallTypeVideo:{
            vc = [[NTESVideoChatViewController alloc] initWithCaller:caller callId:callID];
        }
            break;
        case NIMNetCallTypeAudio:{
            vc = [[NTESAudioChatViewController alloc] initWithCaller:caller callId:callID];
        }
            break;
        default:
            break;
    }
    if (!vc) {
        return;
    }
    NTESMainTabController *tabVC = [NTESMainTabController instance];
    [tabVC.view endEditing:YES];
    if (tabVC.presentedViewController) {
        __weak NTESMainTabController *wtabVC = (NTESMainTabController *)tabVC;
        [tabVC.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [wtabVC presentViewController:vc animated:NO completion:nil];
        }];
    }else{
        [tabVC presentViewController:vc animated:NO completion:nil];
    }

}

- (void)onRTSRequest:(NSString *)sessionID
                from:(NSString *)caller
            services:(NSUInteger)types
             message:(NSString *)info
{
    NTESMainTabController *tabVC = [NTESMainTabController instance];
    [tabVC.view endEditing:YES];
    NTESWhiteboardViewController *vc = [[NTESWhiteboardViewController alloc] initWithSessionID:sessionID
                                                                          peerID:caller
                                                                           types:types
                                                                            info:info];
    if (tabVC.presentedViewController) {
        __weak NTESMainTabController *wtabVC = (NTESMainTabController *)tabVC;
        [tabVC.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [wtabVC presentViewController:vc animated:NO completion:nil];
        }];
    }else{
        [tabVC presentViewController:vc animated:NO completion:nil];
    }
}


@end
