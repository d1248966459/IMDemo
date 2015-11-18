//
//  NTESNetChatViewController.m
//  NIM
//
//  Created by chris on 15/5/18.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESNetChatViewController.h"
#import "UIAlertView+NTESBlock.h"
#import "UIView+Toast.h"
#import "NTESTimerHolder.h"
#import "NetCallChatInfo.h"
#import <AVFoundation/AVFoundation.h>

//十秒之后如果还是没有收到对方响应的control字段，则自己发起一个假的control，用来激活铃声并自己先进入聊天室
#define DelaySelfStartControlTime 10
//激活铃声后无人接听的超时时间
#define NoBodyResponseTimeOut 40

@interface NTESNetChatViewController ()

@property (nonatomic,strong) NTESTimerHolder *timer;

@property (nonatomic,strong) NSMutableArray *chatRoom;

@end

@implementation NTESNetChatViewController

- (instancetype)initWithCallee:(NSString *)callee{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.callInfo.callee = callee;
        self.callInfo.caller = [[NIMSDK sharedSDK].loginManager currentAccount];
    }
    return self;
}

- (instancetype)initWithCaller:(NSString *)caller callId:(uint64_t)callID{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.callInfo.caller = caller;
        self.callInfo.callee = [[NIMSDK sharedSDK].loginManager currentAccount];
        self.callInfo.callID = callID;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        if (!self.callInfo) {
            [[NIMSDK sharedSDK].mediaManager switchAudioOutputDevice:NIMAudioOutputDeviceSpeaker];
            _callInfo = [[NetCallChatInfo alloc] init];
        }
        _timer = [[NTESTimerHolder alloc] init];
    }
    return self;
}

- (void)dealloc{
    DDLogDebug(@"vc dealloc info : %@",self);
    [[NIMSDK sharedSDK].netCallManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) wself = self;
    [self checkServiceEnable:^(BOOL result) {
        if (result) {
            [wself afterCheckService];
        }else{
            //用户禁用服务，干掉界面
            if (wself.callInfo.callID) {
                //说明是被叫方
                [[NIMSDK sharedSDK].netCallManager response:wself.callInfo.callID accept:NO completion:nil];
            }
            [wself dismiss:nil];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpStatusBar];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player stop];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)afterCheckService{
    id<NIMNetCallManager> manager = [NIMSDK sharedSDK].netCallManager;
    [manager addDelegate:self];
    if (self.callInfo.isStart) {
        [self.timer startTimer:0.5 delegate:self repeats:YES];
        [self onCalling];
    }
    else if (self.callInfo.callID) {
        [self startByCallee];
    }
    else {
        [self startByCaller];
    }
}

#pragma mark - Subclass Impl
- (void)startByCaller{
    [self playConnnetRing];
    __weak typeof(self) wself = self;
    //等铃声播完再打过去，太快的话很假
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!wself) {
            return;
        }
        wself.callInfo.isStart = YES;
        [[NIMSDK sharedSDK].netCallManager start:wself.callInfo.callee type:wself.callInfo.callType completion:^(NSError *error, UInt64 callID) {
            if (!error && wself) {
                wself.callInfo.callID = callID;
                wself.chatRoom = [[NSMutableArray alloc]init];
                //十秒之后如果还是没有收到对方响应的control字段，则自己发起一个假的control，用来激活铃声并自己先进入聊天室
                NSTimeInterval delayTime = DelaySelfStartControlTime;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [wself onControl:callID from:wself.callInfo.callee type:NIMNetCallControlTypeFeedabck];
                });
            }else{
                if (error) {
                    [wself.view.window makeToast:@"连接失败"];
                }else{
                    //说明在start的过程中把页面关了。。
                    [[NIMSDK sharedSDK].netCallManager hangup:callID];
                }
                [wself dismiss:nil];
            }
        }];
    });
}

- (void)startByCallee{
    //告诉对方可以播放铃声了
    self.callInfo.isStart = YES;
    NSMutableArray *room = [[NSMutableArray alloc] init];
    [room addObject:self.callInfo.caller];
    self.chatRoom = room;
    [[NIMSDK sharedSDK].netCallManager control:self.callInfo.callID type:NIMNetCallControlTypeFeedabck];
    [self playReceiverRing];
}


- (void)hangup{
    [[NIMSDK sharedSDK].netCallManager hangup:self.callInfo.callID];
    self.chatRoom = nil;
    [self dismiss:nil];
}

- (void)response:(BOOL)accept{
    __weak typeof(self) wself = self;
    [[NIMSDK sharedSDK].netCallManager response:self.callInfo.callID accept:accept completion:^(NSError *error, UInt64 callID) {
        if (!error) {
                [wself onCalling];
                [wself.player stop];
                [wself.chatRoom addObject:wself.callInfo.callee];
                NSTimeInterval delay = 10.f; //10秒后判断下聊天室
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (wself.chatRoom.count == 1) {
                        [wself.view.window makeToast:@"通话失败"];
                        [wself hangup];
                    }
                });
        }else{
            wself.chatRoom = nil;
            [wself.view.window makeToast:@"连接失败"];
            [wself dismiss:nil];
        }
    }];
    //dismiss需要放在self后面，否在ios7下会有野指针
    if (accept) {
        [self waitForConnectiong];
    }else{
        [self dismiss:nil];
    }
}

- (void)dismiss:(void (^)(void))completion{
    [self dismissViewControllerAnimated:NO completion:completion];
}

- (void)onCalling{
    //子类重写
}

- (void)waitForConnectiong{
    //子类重写
}
#pragma mark - NIMNetCallManagerDelegate
- (void)onControl:(UInt64)callID
             from:(NSString *)user
             type:(NIMNetCallControlType)control;{
    switch (control) {
        case NIMNetCallControlTypeFeedabck:{
            NSMutableArray *room = self.chatRoom;
            if (room && !room.count) {
                [self playSenderRing];
                [room addObject:self.callInfo.caller];
                //40秒之后查看一下聊天室状态，如果聊天室还在一个人的话，就播放铃声超时
                __weak typeof(self) wself = self;
                uint64_t callId = self.callInfo.callID;
                NSTimeInterval delayTime = NoBodyResponseTimeOut;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSMutableArray *room = wself.chatRoom;
                    if (wself && room && room.count == 1) {
                        [[NIMSDK sharedSDK].netCallManager hangup:callId];
                        wself.chatRoom = nil;
                        [wself playTimeoutRing];
                        [wself.view.window makeToast:@"无人接听"];
                        [wself dismiss:nil];
                    }
                });
            }
            break;
        }
        case NIMNetCallControlTypeBusyLine:
            [self playOnCallRing];
            break;
        default:
            break;
    }
}

- (void)onResponse:(UInt64)callID from:(NSString *)callee accepted:(BOOL)accepted{
    if (self.callInfo.callID == callID) {
        if (!accepted) {
            self.chatRoom = nil;
            [self.view.window makeToast:@"对方拒绝接听"];
            [self playHangUpRing];
            [self dismiss:nil];
        }else{
            [self.player stop];
            [self onCalling];
            [self.chatRoom addObject:callee];
        }
    }
}

- (void)onCall:(UInt64)callID status:(NIMNetCallStatus)status{
    if (self.callInfo.callID != callID) {
        return;
    }
    //记时
    switch (status) {
        case NIMNetCallStatusConnect:
            //开始计时
            self.callInfo.startTime = [NSDate date].timeIntervalSince1970;
            [self.timer startTimer:0.5 delegate:self repeats:YES];
            break;
        case NIMNetCallStatusDisconnect:
            //结束计时
            [self.timer stopTimer];
            [self dismiss:nil];
            self.chatRoom = nil;
            break;
        default:
            break;
    }
}


- (void)onResponsedByOther:(UInt64)callID
                  accepted:(BOOL)accepted{
    [self.view makeToast:@"已在其他端处理"];
    [self dismiss:nil];
}


#pragma mark - M80TimerHolderDelegate
- (void)onNTESTimerFired:(NTESTimerHolder *)holder{
  //子类重写
}


#pragma mark - Misc
- (void)checkServiceEnable:(void(^)(BOOL))result{
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            dispatch_async_main_safe(^{
                if (granted) {
                    NSString *mediaType = AVMediaTypeVideo;
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"相机权限受限,无法视频聊天"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                        [alert showAlertWithCompletionHandler:^(NSInteger idx) {
                            if (result) {
                                result(NO);
                            }
                        }];
                    }else{
                        if (result) {
                            result(YES);
                        }
                    }
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"麦克风权限受限,无法聊天"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert showAlertWithCompletionHandler:^(NSInteger idx) {
                        if (result) {
                            result(NO);
                        }
                    }];
                }

            });
        }];
    }
}

- (void)setUpStatusBar{
    UIStatusBarStyle style = UIStatusBarStyleLightContent;
    [[UIApplication sharedApplication] setStatusBarStyle:style
                                                animated:NO];
}

#pragma mark - Ring
//铃声 - 正在呼叫请稍后
- (void)playConnnetRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_connect_chat_tip_sender" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];
}

//铃声 - 对方暂时无法接听
- (void)playHangUpRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_HangUp" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];
}

//铃声 - 对方正在通话中
- (void)playOnCallRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_OnCall" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];
}

//铃声 - 对方无人接听
- (void)playTimeoutRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_onTimer" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];
}

//铃声 - 接收方铃声
- (void)playReceiverRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_receiver" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = 20;
    [self.player play];
}

//铃声 - 拨打方铃声
- (void)playSenderRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_sender" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = 20;
    [self.player play];
}



@end
