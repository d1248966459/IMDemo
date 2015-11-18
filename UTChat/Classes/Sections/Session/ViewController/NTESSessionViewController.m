//
//  NTESSessionViewController.m
//  NIM
//
//  Created by amao on 8/11/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESSessionViewController.h"
@import MobileCoreServices;
@import AVFoundation;
#import "Reachability.h"
#import "UIActionSheet+NTESBlock.h"
#import "NTESCustomSysNotificationSender.h"
#import "NTESSessionConfig.h"
#import "NIMMediaItem.h"
#import "NTESSessionMsgConverter.h"
#import "NTESFileLocationHelper.h"
#import "NTESSessionMsgConverter.h"
#import "UIView+Toast.h"
#import "NTESLocationViewController.h"
#import "NTESSnapchatAttachment.h"
#import "NTESJanKenPonAttachment.h"
#import "NTESFileTransSelectViewController.h"
#import "NTESAudioChatViewController.h"
#import "NTESWhiteboardViewController.h"
#import "NTESVideoChatViewController.h"
#import "NTESChartletAttachment.h"
#import "NTESGalleryViewController.h"
#import "NTESLocationViewController.h"
#import "NTESVideoViewController.h"
#import "NTESLocationPoint.h"
#import "NTESFilePreViewController.h"
#import "NTESAudio2TextViewController.h"
#import "NSDictionary+NTESJson.h"
#import "NIMAdvancedTeamCardViewController.h"
#import "NTESSessionRemoteHistoryViewController.h"
#import "NIMNormalTeamCardViewController.h"
#import "UIView+NTES.h"
#import "NTESBundleSetting.h"
#import "NTESPersonalCardViewController.h"
#import "NTESSessionSnapchatContentView.h"
#import "NTESSessionLocalHistoryViewController.h"
#import "NIMContactSelectViewController.h"
#import "SVProgressHUD.h"
//#import "NTESAdvancedTeamViewController.h"

typedef enum : NSUInteger {
    NTESImagePickerModeImage,
    NTESImagePickerModeSnapChat,
} NTESImagePickerMode;

@interface NTESSessionViewController ()
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
NTESLocationViewControllerDelegate,
NIMSystemNotificationManagerDelegate,
NIMMediaManagerDelgate,
NTESTimerHolderDelegate,
NIMContactSelectDelegate>

@property (nonatomic,strong)    NTESCustomSysNotificationSender *notificaionSender;
@property (nonatomic,strong)    NTESSessionConfig       *sessionConfig;
@property (nonatomic,strong)    UIImagePickerController *imagePicker;
@property (nonatomic,assign)    NTESImagePickerMode      mode;
@property (nonatomic,strong)    NTESTimerHolder         *titleTimer;
@property (nonatomic,strong)    NSString *playingAudioPath; //正在播放的音频路径
@end

@implementation NTESSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _notificaionSender = [[NTESCustomSysNotificationSender alloc] init];
    [self setUpNav];
    self.disableCommandTyping = (self.session.sessionType == NIMSessionTypeP2P &&[[NIMSDK sharedSDK].userManager isUserInBlackList:self.session.sessionId]);
    if (!self.disableCommandTyping) {
        _titleTimer = [[NTESTimerHolder alloc] init];
        [[[NIMSDK sharedSDK] systemNotificationManager] addDelegate:self];
    }
}

- (void)dealloc
{
    [[[NIMSDK sharedSDK] systemNotificationManager] removeDelegate:self];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NIMSDK sharedSDK].mediaManager stopRecord];
    [[NIMSDK sharedSDK].mediaManager stopPlay];
}

- (id<NIMSessionConfig>)sessionConfig
{
    if (_sessionConfig == nil) {
        _sessionConfig = [[NTESSessionConfig alloc] init];
        _sessionConfig.session = self.session;
    }
    return _sessionConfig;
}


#pragma mark - NIMSystemNotificationManagerProcol
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    if (!notification.sendToOnlineUsersOnly) {
        return;
    }
    NSData *data = [[notification content] dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict jsonInteger:NTESNotifyID] == NTESCommandTyping && self.session.sessionType == NIMSessionTypeP2P && [notification.sender isEqualToString:self.session.sessionId])
        {
            self.title = @"对方正在输入...";
            [_titleTimer startTimer:5
                           delegate:self
                            repeats:NO];
        }
    }
    
    
}



- (void)onNTESTimerFired:(NTESTimerHolder *)holder
{
    self.title = [self sessionTitle];

}

#pragma mark - NIMInputActionDelegate
- (void)onTapMediaItem:(NIMMediaItem *)item
{
    NSDictionary *actions = [self inputActions];
    NSString *value = actions[@(item.tag)];
    BOOL handled = NO;
    if (value) {
        SEL selector = NSSelectorFromString(value);
        if (selector && [self respondsToSelector:selector]) {
            SuppressPerformSelectorLeakWarning([self performSelector:selector]);
            handled = YES;
        }
    }
    if (!handled) {
        NSAssert(0, @"invalid item tag");
    }
}

- (void)onTextChanged:(id)sender
{
    [_notificaionSender sendTypingState:self.session];
}

- (void)onSelectChartlet:(NSString *)chartletId
                 catalog:(NSString *)catalogId
{
    NTESChartletAttachment *attachment = [[NTESChartletAttachment alloc] init];
    attachment.chartletId = chartletId;
    attachment.chartletCatalog = catalogId;
    [self sendMessage:[NTESSessionMsgConverter msgWithChartletAttachment:attachment]];
}

#pragma mark - 相册
- (void)mediaPicturePressed
{
    [self initImagePicker];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    _mode = NTESImagePickerModeImage;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

#pragma mark - 摄像
- (void)mediaShootPressed
{
    if ([self initCamera]) {
#if TARGET_IPHONE_SIMULATOR
        NSAssert(0, @"not supported");
#elif TARGET_OS_IPHONE
        self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
#endif
    }
}

#pragma mark - 位置
- (void)mediaLocationPressed
{
    NTESLocationViewController *vc = [[NTESLocationViewController alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onSendLocation:(NTESLocationPoint*)locationPoint{
    [self sendMessage:[NTESSessionMsgConverter msgWithLocation:locationPoint]];
}

#pragma mark - 石头剪子布
- (void)mediaJankenponPressed
{
    NTESJanKenPonAttachment *attachment = [[NTESJanKenPonAttachment alloc] init];
    attachment.value = arc4random() % 3 + 1;
    [self sendMessage:[NTESSessionMsgConverter msgWithJenKenPon:attachment]];
}

#pragma mark - 实时语音
- (void)mediaAudioChatPressed
{
    if ([self checkCondition]) {
        NTESAudioChatViewController *vc = [[NTESAudioChatViewController alloc] initWithCallee:self.session.sessionId];
        [self presentViewController:vc animated:NO completion:nil];
        
    }
}

#pragma mark - 视频聊天
- (void)mediaVideoChatPressed
{
    if ([self checkCondition]) {
        NTESVideoChatViewController *vc = [[NTESVideoChatViewController alloc] initWithCallee:self.session.sessionId];
        [self presentViewController:vc animated:NO completion:nil];
    }
}

#pragma mark - 文件传输
- (void)mediaFileTransPressed
{
    NTESFileTransSelectViewController *vc = [[NTESFileTransSelectViewController alloc]
                                             initWithNibName:nil bundle:nil];
    __weak typeof(self) wself = self;
    vc.completionBlock = ^void(id sender,NSString *ext){
        if ([sender isKindOfClass:[NSString class]]) {
            [wself sendMessage:[NTESSessionMsgConverter msgWithFilePath:sender]];
        }else if ([sender isKindOfClass:[NSData class]]){
            [wself sendMessage:[NTESSessionMsgConverter msgWithFileData:sender extension:ext]];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 阅后即焚
- (void)mediaSnapchatPressed
{
    [self initImagePicker];
    UIActionSheet *sheet;
    BOOL isCamraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (isCamraAvailable) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取",nil];
    }else{
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取",nil];
    }
    __weak typeof(self) wself = self;
    [sheet showInView:self.view completionHandler:^(NSInteger index) {
        UIImagePickerControllerSourceType type;
        switch (index) {
            case 0:
                //相册
                if (isCamraAvailable) {
                    type =  UIImagePickerControllerSourceTypeCamera;
                }else{
                    type =  UIImagePickerControllerSourceTypePhotoLibrary;
                }
                break;
            case 1:
                //相机
                if (isCamraAvailable) {
                    type =  UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                }
            default:
                return;
        }
        wself.imagePicker.sourceType = type;
        wself.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        wself.mode = NTESImagePickerModeSnapChat;
        [wself presentViewController:_imagePicker animated:YES completion:nil];
    }];
}

- (void)sendSnapchatMessage:(UIImage *)image
{
    NTESSnapchatAttachment *attachment = [[NTESSnapchatAttachment alloc] init];
    [attachment setImage:image];
    [self sendMessage:[NTESSessionMsgConverter msgWithSnapchatAttachment:attachment]];
}

#pragma mark - 白板
- (void)mediaWhiteBoardPressed
{
    NTESWhiteboardViewController *vc = [[NTESWhiteboardViewController alloc] initWithSessionID:nil
                                                                                        peerID:self.session.sessionId
                                                                                         types:NIMRTSServiceReliableTransfer | NIMRTSServiceAudio
                                                                                          info:@"白板演示"];
    [self presentViewController:vc animated:NO completion:nil];
}



#pragma mark - ImagePicker初始化
- (void)initImagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
}

- (BOOL)initCamera{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"检测不到相机设备"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        return NO;
    }
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"相机权限受限"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
        return NO;
        
    }
    [self initImagePicker];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        [picker dismissViewControllerAnimated:YES completion:^{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *inputURL  = [info objectForKey:UIImagePickerControllerMediaURL];
                NSString *outputFileName = [NTESFileLocationHelper genFilenameWithExt:VideoExt];
                NSString *outputPath = [NTESFileLocationHelper filepathForVideo:outputFileName];
                AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
                AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset
                                                                                 presetName:AVAssetExportPresetMediumQuality];
                session.outputURL = [NSURL fileURLWithPath:outputPath];
                session.outputFileType = AVFileTypeMPEG4;   // 支持安卓某些机器的视频播放
                session.shouldOptimizeForNetworkUse = YES;
                [session exportAsynchronouslyWithCompletionHandler:^(void)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (session.status == AVAssetExportSessionStatusCompleted) {
                             [self sendMessage:[NTESSessionMsgConverter msgWithVideo:outputPath]];
                         }
                         else {
                             [self.view makeToast:@"发送失败"];
                         }
                     });
                 }];
                
            });
        }];
    }else{
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        __weak typeof(self) wself = self;
        [picker dismissViewControllerAnimated:YES completion:^{
            switch (_mode) {
                case NTESImagePickerModeImage:
                    [wself sendMessage:[NTESSessionMsgConverter msgWithImage:orgImage]];
                    break;
                case NTESImagePickerModeSnapChat:
                    [wself sendSnapchatMessage:orgImage];
                    break;
                default:
                    break;
            }
            
        }];
    }
}

#pragma mark - 录音事件
- (void)onRecordFailed:(NSError *)error
{
    [self.view makeToast:@"录音失败" duration:2 position:CSToastPositionCenter];
}

- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    NSURL    *movieURL = [NSURL fileURLWithPath:filepath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:movieURL options:nil];
    CMTime time = urlAsset.duration;
    CGFloat mediaLength = CMTimeGetSeconds(time);
    return mediaLength > 2;
}

- (void)showRecordFileNotSendReason
{
    [self.view makeToast:@"录音时间太短" duration:0.2f position:CSToastPositionCenter];
}

#pragma mark - 系统通知

#pragma mark - Cell事件
- (void)onTapCell:(NIMKitEvent *)event
{
    BOOL handled = NO;
    NSString *eventName = event.eventName;
    if ([eventName isEqualToString:NIMKitEventNameTapContent])
    {
        NIMMessage *message = event.message;
        NSDictionary *actions = [self cellActions];
        NSString *value = actions[@(message.messageType)];
        if (value) {
            SEL selector = NSSelectorFromString(value);
            if (selector && [self respondsToSelector:selector]) {
                SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:message]);
                handled = YES;
            }
        }
    }
    else if([eventName isEqualToString:NIMKitEventNameTapLabelLink])
    {
        NSString *link = event.data;
        [self.view makeToast:[NSString stringWithFormat:@"tap link : %@",link]];
        handled = YES;
    }
    else if([eventName isEqualToString:NIMDemoEventNameOpenSnapPicture])
    {
        NIMCustomObject *object = event.message.messageObject;
        NTESSnapchatAttachment *attachment = (NTESSnapchatAttachment *)object.attachment;
        if(attachment.isFired){
            return;
        }
        UIView *sender = event.data;
        [NTESGalleryViewController alertSingleSnapViewWithMessage:object.message baseView:sender];
        handled = YES;
    }
    else if([eventName isEqualToString:NIMDemoEventNameCloseSnapPicture])
    {
        NIMCustomObject *object = event.message.messageObject;
        //点击很快的时候可能会触发两次查看，所以这里不管有没有查看过 先强直销毁掉
        UIView *senderView = event.data;
        [senderView dismissPresentedView:YES complete:nil];
        
        NTESSnapchatAttachment *attachment = (NTESSnapchatAttachment *)object.attachment;
        if(attachment.isFired){
            return;
        }
        attachment.isFired  = YES;
        NIMMessage *message = object.message;
        if ([NTESBundleSetting sharedConfig].autoRemoveSnapMessage) {
            [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
            [self uiDeleteMessage:message];
        }else{
            [[NIMSDK sharedSDK].conversationManager updateMessage:message forSession:message.session completion:nil];
            [self uiUpdateMessage:message];
        }
        [[NSFileManager defaultManager] removeItemAtPath:attachment.filepath error:nil];
        handled = YES;
    }

    if (!handled) {
        NSAssert(0, @"invalid event");
    }
}

- (void)onLongPressCell:(NIMMessage *)message inView:(UIView *)view
{
    [super onLongPressCell:message
                    inView:view];
}


- (void)onTapAvatar:(NSString *)userId{
    NTESPersonalCardViewController *vc = [[NTESPersonalCardViewController alloc] initWithUserId:userId];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Cell Actions
- (void)showImage:(NIMMessage *)message
{
    NIMImageObject *object = message.messageObject;
    NTESGalleryItem *item = [[NTESGalleryItem alloc] init];
    item.thumbPath      = [object thumbPath];
    item.imageURL       = [object url];
    item.name           = [object displayName];
    NTESGalleryViewController *vc = [[NTESGalleryViewController alloc] initWithItem:item];
    [self.navigationController pushViewController:vc animated:YES];
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.thumbPath]){
        //如果缩略图下跪了，点进看大图的时候再去下一把缩略图
        __weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.thumbUrl filepath:object.thumbPath progress:nil completion:^(NSError *error) {
            if (!error) {
                [wself uiUpdateMessage:message];
            }
        }];
    }
}

- (void)playAudio:(NIMMessage *)message
{
    NIMAudioObject *audioObject = (NIMAudioObject*)message.messageObject;
    if ([self.playingAudioPath isEqualToString:audioObject.path]) {
        [[NIMSDK sharedSDK].mediaManager stopPlay];
    } else {
        [[NIMSDK sharedSDK].mediaManager switchAudioOutputDevice:NIMAudioOutputDeviceSpeaker];
        [[NIMSDK sharedSDK].mediaManager playAudio:audioObject.path withDelegate:self];
    }
}

- (void)showVideo:(NIMMessage *)message
{
    NIMVideoObject *object = message.messageObject;
    NTESVideoViewController *playerViewController = [[NTESVideoViewController alloc] initWithVideoObject:object];
    [self.navigationController pushViewController:playerViewController animated:YES];
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.coverPath]){
        //如果封面图下跪了，点进视频的时候再去下一把封面图
        __weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.coverUrl filepath:object.coverPath progress:nil completion:^(NSError *error) {
            if (!error) {
                [wself uiUpdateMessage:message];
            }
        }];
    }
}

- (void)showLocation:(NIMMessage *)message
{
    NIMLocationObject *object = message.messageObject;
    NTESLocationPoint *locationPoint = [[NTESLocationPoint alloc] initWithLocationObject:object];
    NTESLocationViewController *vc = [[NTESLocationViewController alloc] initWithLocationPoint:locationPoint];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showFile:(NIMMessage *)message
{
    NIMFileObject *object = message.messageObject;
    NTESFilePreViewController *vc = [[NTESFilePreViewController alloc] initWithFileObject:object];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showCustom:(NIMMessage *)message
{
   //普通的自定义消息点击事件可以在这里做哦~
}


#pragma mark - NIMMediaManagerDelgate
- (void)playAudio:(NSString *)filePath didBeganWithError:(NSError *)error {
    self.playingAudioPath = filePath;
}

- (void)playAudio:(NSString *)filePath didCompletedWithError:(NSError *)error
{
    self.playingAudioPath = nil;
}


#pragma mark - 导航按钮
- (void)onTouchUpInfoBtn:(id)sender{
    NSMutableArray *users = [[NSMutableArray alloc] init];
    NSString *currentUserID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    [users addObject:currentUserID];
    NIMContactFriendSelectConfig *config = [[NIMContactFriendSelectConfig alloc] init];
    config.filterIds = users;
    config.needMutiSelected = YES;
    config.alreadySelectedMemberId = @[self.session.sessionId];
    NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
    vc.delegate = self;
    [vc show];
}

- (void)enterHistory:(id)sender{
    [self.view endEditing:YES];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"搜索本地消息",@"查看云端消息",@"清空聊天记录", nil];
    [sheet showInView:self.view completionHandler:^(NSInteger index) {
        switch (index) {
            case 0:{ //搜索本地消息
                    NTESSessionLocalHistoryViewController *vc = [[NTESSessionLocalHistoryViewController alloc] initWithSession:self.session];
                    [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1:{ //查看云端消息
                NTESSessionRemoteHistoryViewController *vc = [[NTESSessionRemoteHistoryViewController alloc] initWithSession:self.session];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:{ //清空聊天记录
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定清空聊天记录？" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
                __weak UIActionSheet *wSheet;
                [sheet showInView:self.view completionHandler:^(NSInteger index) {
                    if (index == wSheet.destructiveButtonIndex) {
                        BOOL removeRecentSession = [NTESBundleSetting sharedConfig].removeSessionWheDeleteMessages;
                        [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:self.session removeRecentSession:removeRecentSession];
                    }
                }];
                break;
            }
            default:
                break;
        }
    }];
}

- (void)enterTeamCard:(id)sender{
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
    UIViewController *vc;
    if (team.type == NIMTeamTypeNormal) {
        vc = [[NIMNormalTeamCardViewController alloc] initWithTeam:team];
    }else if(team.type == NIMTeamTypeAdvanced){
        vc = [[NIMAdvancedTeamCardViewController alloc] initWithTeam:team];
    }
    [self.navigationController pushViewController:vc animated:YES];
} 

#pragma mark - 菜单
- (NSArray *)menusItems:(NIMMessage *)message
{
    NSMutableArray *items = [NSMutableArray array];
    NSArray *defaultItems = [super menusItems:message];
    if (defaultItems) {
        [items addObjectsFromArray:defaultItems];
    }
    
    if (message.messageType == NIMMessageTypeAudio) {
        [items addObject:[[UIMenuItem alloc] initWithTitle:@"转文字" action:@selector(audio2Text:)]];
    }
    
    return items;
    
}

- (void)audio2Text:(id)sender
{
    NIMMessage *message = [self messageForMenu];
    __weak typeof(self) wself = self;
    NTESAudio2TextViewController *vc = [[NTESAudio2TextViewController alloc] initWithMessage:message];
    vc.completeHandler = ^(void){
        [wself uiUpdateMessage:message];
    };
    [self presentViewController:vc
                       animated:YES
                     completion:nil];
}

#pragma mark - ContactSelectDelegate

- (void)didFinishedSelect:(NSArray *)selectedContacts{
    if (!selectedContacts.count) {
        return;
    }
    NSString *uid = [[NIMSDK sharedSDK].loginManager currentAccount];
    NSArray *users = [@[uid] arrayByAddingObjectsFromArray:selectedContacts];
    NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
    option.name = @"讨论组";
    option.type = NIMTeamTypeNormal;
    option.clientCustomInfo = @"讨论组";
    __weak typeof(self) wself = self;
    [SVProgressHUD show];
    [[NIMSDK sharedSDK].teamManager createTeam:option
                                         users:users
                                    completion:^(NSError *error, NSString *teamId) {
                                        [SVProgressHUD dismiss];
                                        if (!error) {
                                            NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
                                            UINavigationController *nav = wself.navigationController;
                                            [nav popToRootViewControllerAnimated:NO];
                                            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
                                            [nav pushViewController:vc animated:YES];
                                        }else{
                                            [wself.view makeToast:@"创建讨论组失败" duration:2.0 position:CSToastPositionCenter];
                                        }
                                    }];
}


#pragma mark - 辅助方法
- (BOOL)checkCondition
{
    BOOL result = YES;
    
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        [self.view makeToast:@"请检查网络" duration:2.0 position:CSToastPositionCenter];
        result = NO;
    }
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    if ([currentAccount isEqualToString:self.session.sessionId]) {
        [self.view makeToast:@"不能和自己通话哦" duration:2.0 position:CSToastPositionCenter];
        result = NO;
    }
    return result;
}


- (NSDictionary *)inputActions
{
    static NSDictionary *actions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actions = @{@(NTESMediaButtonPicture)   : @"mediaPicturePressed",
                    @(NTESMediaButtonShoot)     : @"mediaShootPressed",
                    @(NTESMediaButtonLocation)  : @"mediaLocationPressed",
                    @(NTESMediaButtonJanKenPon) : @"mediaJankenponPressed",
                    @(NTESMediaButtonVideoChat) : @"mediaVideoChatPressed",
                    @(NTESMediaButtonAudioChat) : @"mediaAudioChatPressed",
                    @(NTESMediaButtonFileTrans) : @"mediaFileTransPressed",
                   // @(NTESMediaButtonSnapchat)  : @"mediaSnapchatPressed",
                    @(NTESMediaButtonWhiteBoard): @"mediaWhiteBoardPressed"};
        
    });
    return actions;
}

- (NSDictionary *)cellActions
{
    static NSDictionary *actions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actions = @{@(NIMMessageTypeImage) :    @"showImage:",
                    @(NIMMessageTypeAudio) :    @"playAudio:",
                    @(NIMMessageTypeVideo) :    @"showVideo:",
                    @(NIMMessageTypeLocation) : @"showLocation:",
                    @(NIMMessageTypeFile)  :    @"showFile:",
                    @(NIMMessageTypeCustom):    @"showCustom:"};
    });
    return actions;
}



- (void)setUpNav{
    UIButton *enterTeamCard = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterTeamCard addTarget:self action:@selector(enterTeamCard:) forControlEvents:UIControlEventTouchUpInside];
    [enterTeamCard setImage:[UIImage imageNamed:@"icon_session_info_normal"] forState:UIControlStateNormal];
    [enterTeamCard setImage:[UIImage imageNamed:@"icon_session_info_pressed"] forState:UIControlStateHighlighted];
    [enterTeamCard sizeToFit];
    UIBarButtonItem *enterTeamCardItem = [[UIBarButtonItem alloc] initWithCustomView:enterTeamCard];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn addTarget:self action:@selector(onTouchUpInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [infoBtn setImage:[UIImage imageNamed:@"icon_session_info_normal"] forState:UIControlStateNormal];
    [infoBtn setImage:[UIImage imageNamed:@"icon_session_info_pressed"] forState:UIControlStateHighlighted];
    [infoBtn sizeToFit];
    UIBarButtonItem *enterUInfoItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    
    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtn addTarget:self action:@selector(enterHistory:) forControlEvents:UIControlEventTouchUpInside];
    [historyBtn setImage:[UIImage imageNamed:@"icon_history_normal"] forState:UIControlStateNormal];
    [historyBtn setImage:[UIImage imageNamed:@"icon_history_pressed"] forState:UIControlStateHighlighted];
    [historyBtn sizeToFit];
    UIBarButtonItem *historyButtonItem = [[UIBarButtonItem alloc] initWithCustomView:historyBtn];
    
    
    
    if (self.session.sessionType == NIMSessionTypeTeam) {
        self.navigationItem.rightBarButtonItems  = @[enterTeamCardItem,historyButtonItem];
    }else if(self.session.sessionType == NIMSessionTypeP2P){
        self.navigationItem.rightBarButtonItems = @[enterUInfoItem,historyButtonItem];
    }
}


@end
