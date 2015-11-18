//
//  NTESEmailSettingViewController.m
//  NIM
//
//  Created by chris on 15/9/17.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESEmailSettingViewController.h"
#import "NTESCommonTableDelegate.h"
#import "NTESCommonTableData.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"

@interface NTESEmailSettingViewController ()

@property (nonatomic,strong) NTESCommonTableDelegate *delegator;

@property (nonatomic,copy  ) NSArray                 *data;

@property (nonatomic,copy  ) NSString                *email;

@property (nonatomic,assign) NSInteger               inputLimit;

@end

@implementation NTESEmailSettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _inputLimit = 30;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    self.navigationItem.title = @"设置邮箱";
    __weak typeof(self) wself = self;
    NSString *userId = [[NIMSDK sharedSDK].loginManager currentAccount];
    self.email = [[NIMSDK sharedSDK].userManager userInfo:userId].userInfo.email;
    [self buildData];
    self.delegator = [[NTESCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xe3e6ea);
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate   = self.delegator;
    self.tableView.dataSource = self.delegator;
    [self.tableView reloadData];
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        for (UIView *subView in cell.subviews) {
            if ([subView isKindOfClass:[UITextField class]]) {
                [subView becomeFirstResponder];
                break;
            }
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpNav{
    self.navigationItem.title = @"邮箱";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(onDone:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)onDone:(id)sender{
    if (self.email.length > self.inputLimit) {
        [self.view makeToast:@"邮箱过长" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    [SVProgressHUD show];
    __weak typeof(self) wself = self;
    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagEmail) : self.email} completion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            [wself.view.window makeToast:@"邮箱设置成功" duration:2.0 position:CSToastPositionCenter];
            [wself.navigationController popViewControllerAnimated:YES];
        }else{
            [wself.view.window makeToast:@"邮箱设置失败，请重试"];
        }
    }];
}

- (void)buildData{
    NSArray *data = @[
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      ExtraInfo     : self.email,
                                      CellClass     : @"NTESTextSettingCell",
                                      RowHeight     : @(50),
                                      },
                                  ],
                          },
                      ];
    self.data = [NTESCommonTableSection sectionsWithData:data];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string length] == 0 && range.length > 0)
    {
        return YES;
    }
    NSString *genString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.inputLimit && genString.length > self.inputLimit) {
        return NO;
    }
    return YES;
}

- (void)onTextFieldChanged:(NSNotification *)notification{
    UITextField *textField = notification.object;
    self.email = textField.text;
}



@end
