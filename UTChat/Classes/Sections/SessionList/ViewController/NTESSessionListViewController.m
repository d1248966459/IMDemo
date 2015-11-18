//
//  NTESSessionListViewController.m
//  NIMDemo
//
//  Created by chris on 15/2/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESSessionListViewController.h"
#import "NTESSessionViewController.h"
#import "UIView+NTES.h"
#import "NTESBundleSetting.h"
#import "NTESListHeader.h"
#import "NTESClientsTableViewController.h"
#import "NTESSnapchatAttachment.h"
#import "NTESJanKenPonAttachment.h"
#import "NTESChartletAttachment.h"
#import "NTESWhiteboardAttachment.h"
#import "NTESSessionUtil.h"
#import "NTESPersonalCardViewController.h"

#define SessionListTitle @"会话"

@interface NTESSessionListViewController ()<NIMLoginManagerDelegate,NTESListHeaderDelegate>

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NTESListHeader *header;
@end

@implementation NTESSessionListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.autoRemoveRemoteSession = [[NTESBundleSetting sharedConfig] autoRemoveRemoteSession];
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    self.header = [[NTESListHeader alloc] init];
    self.header.delegate = self;
    [self.view addSubview:self.header];

    self.emptyTipLabel = [[UILabel alloc] init];
    self.emptyTipLabel.width = self.view.width/2;
    self.emptyTipLabel.height = 40;
    self.emptyTipLabel.numberOfLines = 0;
    self.emptyTipLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyTipLabel.text = @"还没有会话，在联系人中找个人聊聊吧";
    self.emptyTipLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.emptyTipLabel.font = [UIFont systemFontOfSize:14];
//    [self.emptyTipLabel sizeToFit];
    self.emptyTipLabel.hidden = self.recentSessions.count;
    [self.view addSubview:self.emptyTipLabel];
    
    self.emptyTipImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.emptyTipImage.image = [UIImage imageNamed:@"Imported_Layers_Copy"];
//    [self.emptyTipImage sizeToFit];
    self.emptyTipImage.hidden = self.recentSessions.count;
    [self.view addSubview:self.emptyTipImage];

    
    
    //NSString *userID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    //self.navigationItem.titleView  = [self titleView:userID];
    self.navigationItem.title = SessionListTitle;
    
//    [self addNavRightLeftItem];
}

-(void)addNavRightLeftItem{
    
    //    self.navigationItem.hidesBackButton = YES;
    
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(0, 0, 25, 25);
//    [leftButton setImage:[UIImage imageNamed:@"leftmenu_image.png"] forState:UIControlStateNormal];
//    //[leftButton setImage:[UIImage imageNamed:@"leftMenu_down.png"] forState:UIControlStateHighlighted];
//    leftButton.contentMode = UIViewContentModeScaleAspectFill;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    [leftButton addTarget:self action:@selector(showLeft:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(0, 0, 25, 25);
//    [rightButton setImage:[UIImage imageNamed:@"right_menu_image.png"] forState:UIControlStateNormal];
//    //[rightButton setImage:[UIImage imageNamed:@"rightMenu_down.png"] forState:UIControlStateHighlighted];
//    rightButton.contentMode = UIViewContentModeScaleAspectFill;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    [rightButton addTarget:self action:@selector(showRight:) forControlEvents:UIControlEventTouchUpInside];
    
}
//-(void)showLeft:(UIButton *)button{
//    DDMenuController *menuController=(DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
//    [menuController showLeftController:YES];
//}
//
//-(void)showRight:(UIButton *)button{
//    DDMenuController *menuController=(DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
//    [menuController showRightController:YES];
//    
//}
- (void)reload{
    [super reload];
    self.emptyTipLabel.hidden = self.recentSessions.count;
    self.emptyTipImage.hidden = self.recentSessions.count;
}

- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:recent.session];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onSelectedAvatar:(NIMRecentSession *)recent
             atIndexPath:(NSIndexPath *)indexPath{
    if (recent.session.sessionType == NIMSessionTypeP2P) {
       NTESPersonalCardViewController *vc = [[NTESPersonalCardViewController alloc] initWithUserId:recent.session.sessionId];
      [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)onDeleteRecentAtIndexPath:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    [super onDeleteRecentAtIndexPath:recent atIndexPath:indexPath];
    self.emptyTipLabel.hidden = self.recentSessions.count;
    self.emptyTipImage.hidden = self.recentSessions.count;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
    self.header.top    = self.navigationController.navigationBar.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    self.tableView.top = self.header.height;
    self.tableView.height = self.view.height - self.tableView.top;
    
    self.emptyTipLabel.centerX = self.view.width * .5f;
    self.emptyTipLabel.centerY = self.tableView.height * .5f + 15;
    
    self.emptyTipImage.centerX = self.view.width * .5f;
    self.emptyTipImage.centerY = self.tableView.height * .5f - self.emptyTipImage.frame.size.height/3*2;
}


#pragma mark - SessionListHeaderDelegate

- (void)didSelectRowType:(NTESListHeaderType)type{
    //多人登录
    switch (type) {
        case ListHeaderTypeLoginClients:{
            NTESClientsTableViewController *vc = [[NTESClientsTableViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}


#pragma mark - NIMLoginManagerDelegate
- (void)onLogin:(NIMLoginStep)step{
    [super onLogin:step];
    switch (step) {
        case NIMLoginStepLinkFailed:
            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(未连接)"];
            break;
        case NIMLoginStepLinking:
            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(连接中)"];
            break;
        case NIMLoginStepLinkOK:
        case NIMLoginStepSyncOK:
            self.titleLabel.text = SessionListTitle;
            break;
        case NIMLoginStepSyncing:
            self.titleLabel.text = [SessionListTitle stringByAppendingString:@"(同步数据)"];
            break;
        default:
            break;
    }
    //[self.titleLabel sizeToFit];
    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
    [self.header refreshWithType:ListHeaderTypeNetStauts value:@(step)];
    [self.view setNeedsLayout];
}

- (void)onMultiLoginClientsChanged
{
    [self.header refreshWithType:ListHeaderTypeLoginClients value:[NIMSDK sharedSDK].loginManager.currentLoginClients];
    [self.view setNeedsLayout];
}

#pragma mark - Private 
- (UIView*)titleView:(NSString*)userID{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.text =  SessionListTitle;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [self.titleLabel sizeToFit];
    UILabel *subLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    subLabel.textColor = [UIColor grayColor];
    subLabel.font = [UIFont systemFontOfSize:12.f];
    subLabel.text = userID;
    subLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [subLabel sizeToFit];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.width  = subLabel.width;
    titleView.height = self.titleLabel.height; //+ subLabel.height;
    
    subLabel.bottom = titleView.height;
    [titleView addSubview:self.titleLabel];
    //[titleView addSubview:subLabel];
    return titleView;
}


- (NSString *)contentForRecentSession:(NIMRecentSession *)recent{
    if (recent.lastMessage.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *object = recent.lastMessage.messageObject;
        NSString *text = @"";
        if ([object.attachment isKindOfClass:[NTESSnapchatAttachment class]]) {
            text = @"[阅后即焚]";
        }
        if ([object.attachment isKindOfClass:[NTESJanKenPonAttachment class]]) {
            text = @"[猜拳]";
        }
        else if ([object.attachment isKindOfClass:[NTESChartletAttachment class]]) {
            text = @"[贴图]";
        }
        else if ([object.attachment isKindOfClass:[NTESWhiteboardAttachment class]]) {
            text = @"[白板]";
        }else{
            text = @"[未知消息]";
        }
        if (recent.session.sessionType == NIMSessionTypeP2P) {
            return text;
        }else{
            NSString *nickName = [NTESSessionUtil showNick:recent.lastMessage.from inSession:recent.lastMessage.session];
            return nickName.length ? [nickName stringByAppendingFormat:@" : %@",text] : @"";
        }
    }
    return [super contentForRecentSession:recent];
}

@end
