//
//  LoginViewController.m
//  UChat
//
//  Created by dcj on 15/11/11.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "LoginViewController.h"
#import "UTRegisterViewController.h"
#import "FindPasswordVerifyPhone.h"
#import "SVProgressHUD.h"
#import "NTESLoginManager.h"
#import "UIView+Toast.h"
#import "NTESService.h"
#import "NTESMainTabController.h"
#import "UserInfoManager.h"
#import "UIImageView+WebCache.h"
#define ratio      [UIScreen mainScreen].bounds.size.width/320

@interface LoginViewController ()

@property (nonatomic,strong) AccountInfo * account;
@property (nonatomic,strong) UIImageView * logoImage;
@property (nonatomic,strong) UIButton * loginButton;
@property (nonatomic,strong) NSMutableArray * historyList;
@property (nonatomic,strong) NSMutableArray * recordList;
@property (nonatomic,strong) UILabel * rightLable;


@property (nonatomic,assign) BOOL isHiddenList;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenList = YES;
    self.recordList = [UserInfoManager getUserNameList];
    self.account = [[AccountInfo alloc] init];
    self.historyList = [[NSMutableArray alloc] init];
    [self layoutHeaderView];
    [self layoutFooterView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.account.account = [UserInfoManager getUserName];
    if (self.account.account) {
        [self.historyList addObject:self.account.account];
    }
    [self checkButtonCanUse];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)layoutHeaderView{

    UIView * headrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 140*ratio)];
    self.findTableView.tableHeaderView = headrView;
    
    UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80*ratio, 80*ratio)];
    logoImageView.image = [UIImage imageNamed:@"Imported_Layers_Copy"];
    logoImageView.clipsToBounds = YES;
    logoImageView.layer.cornerRadius = logoImageView.width/2;
    [headrView addSubview:logoImageView];
    logoImageView.centerX = headrView.centerX;
    logoImageView.top = 13.6*3*ratio;
    self.logoImage = logoImageView;

}
//-(void)setAccountTextWithText:(NSString *)name{
//    self.account.account = name;
//    [self.logoImage sd_setImageWithURL:<#(NSURL *)#> placeholderImage:<#(UIImage *)#>]
//}
-(void)layoutFooterView{
    
    [self.nextButton setTitle:@"登 录" forState:UIControlStateNormal];
    
    UILabel * registerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    registerLabel.text = @"手机快速注册";
    registerLabel.font = [UIFont systemFontOfSize:14];
    registerLabel.textColor = [UIColor colorWithHexString:@"#999999"];

    [self.tableViewFooterView addSubview:registerLabel];
    [registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nextButton.mas_left);
        make.top.equalTo(self.nextButton.mas_bottom).mas_offset(10);
    }];

    UILabel * findPassWord = [[UILabel alloc] initWithFrame:CGRectZero];
    findPassWord.text = @"找回密码";
    findPassWord.font = [UIFont systemFontOfSize:14];
    findPassWord.textColor = [UIColor colorWithHexString:@"#999999"];

    [self.tableViewFooterView addSubview:findPassWord];
    [findPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextButton.mas_right);
        make.top.equalTo(registerLabel.mas_top);
    }];

    UITapGestureRecognizer * registertap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registertap)];
    [registerLabel addGestureRecognizer:registertap];
    
    UITapGestureRecognizer * findPassTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findPassWordtap)];
    [findPassWord addGestureRecognizer:findPassTap];
    
    registerLabel.userInteractionEnabled = YES;
    findPassWord.userInteractionEnabled = YES;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        if(self.historyList.count == 0){
            return 1;
        }else{
            return self.historyList.count;

        }
    }else{
        return 1;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(void)registertap{

    
    UTRegisterViewController *registerVC = [[UTRegisterViewController alloc] init];
    [registerVC setRegisterCompeletion:^(AccountInfo *account) {
    }];
    
    [self.navigationController pushViewController:registerVC animated:YES];

    
}

-(void)findPassWordtap{
    FindPasswordVerifyPhone *fVC = [[FindPasswordVerifyPhone alloc]init];
    
    [self.navigationController pushViewController:fVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UTRegisterCell * cell = (UTRegisterCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section== 1) {
        cell.cellType = RegisterCellTypePassWord;
        cell.textField.placeholder = @"请输入密码";
        [cell hideLineView];
    }else if (indexPath.section == 0){
        cell.cellType = RegisterCellTypeLoginAccount;
        cell.textField.placeholder = @"请输入账号";
        if (self.historyList.count>0) {
            cell.textField.text = [self.historyList objectAtIndex:indexPath.row];
        }else{
            cell.textField.text = self.account.account;

        }
        if (indexPath.row != 0) {
            cell.canEditing = NO;
            cell.leftLogoLabel.text = nil;

            [cell hideRightView];
        }else{
            cell.textField.text = self.account.account;
            cell.canEditing = YES;
            [cell showRightView];
            self.rightLable = (UILabel *)[cell.rightView viewWithTag:12345];
        }
    }
    
    return cell;
}


-(void)nextButtonClick:(UIButton *)button{

    if ([self checkLoginParamas]) {
        [self LoginAccount:self.account.account password:self.account.passWord];
    }
    
}
#pragma mark -- registerCellDeletae
-(void)regsterCell:(UTRegisterCell *)cell textField:(UITextField *)textField{
    if (cell.cellType == RegisterCellTypeLoginAccount) {
        self.account.account = textField.text;
    }else if (cell.cellType == RegisterCellTypePassWord){
        self.account.passWord = textField.text;
    }    
    [self checkButtonCanUse];
}

-(void)regsterCell:(UTRegisterCell *)cell otherAccountShow:(BOOL)show{
    if(self.recordList.count>1){
        if (self.isHiddenList) {
            [self showOtherAccount];
            self.rightLable.text = @"\U0000e621";
        }else{
            [self hideOtherAccount];
            
        }
    }
}
-(void)regsterCell:(UTRegisterCell *)cell textFieldClick:(UITextField *)textField{

    NSInteger index = 0;
    for (int i = 0; i<self.recordList.count; i++) {
        NSString * tepmhistory = [self.recordList objectAtIndex:i];
        if ([tepmhistory isEqualToString:textField.text]) {
            index = i;
            break;
        }
    }
    if (index != 0) {
        [self.recordList exchangeObjectAtIndex:index withObjectAtIndex:0];
    }
    
    self.account.account = textField.text;
    [self checkButtonCanUse];
}



-(void)showOtherAccount{
    self.isHiddenList = NO;
    NSMutableArray * historyList = [[NSMutableArray alloc] initWithArray:self.recordList];
    NSMutableArray * indexPathArr = [[NSMutableArray alloc] init];
    for (int i = 1; i<historyList.count; i++) {
        [self.historyList addObject:[historyList objectAtIndex:i]];
        NSIndexPath * tempPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArr addObject:tempPath];
    }
    [self insertTableViewCellAtRows:indexPathArr];
}

-(void)hideOtherAccount{
    self.isHiddenList = YES;
    NSMutableArray * indexPathArr = [[NSMutableArray alloc] init];
    for (int i = 1; i<self.recordList.count; i++) {
        NSIndexPath * tempPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArr addObject:tempPath];
    }
    [self.historyList removeAllObjects];
    [self.historyList addObject:self.account.account];
    [self deleteCellAtIndexs:indexPathArr];
}

-(void)insertTableViewCellAtRows:(NSArray*)addIndexs
{
    if (!addIndexs.count) {
        return;
    }
    [self.findTableView beginUpdates];
    [self.findTableView insertRowsAtIndexPaths:addIndexs withRowAnimation:UITableViewRowAnimationNone];
    [self.findTableView endUpdates];
}

-(void)deleteCellAtIndexs:(NSArray*)delIndexs
{

    [self.findTableView beginUpdates];
    [self.findTableView deleteRowsAtIndexPaths:delIndexs withRowAnimation:UITableViewRowAnimationFade];
    [self.findTableView endUpdates];
    [self.findTableView reloadData];
}

-(void)checkButtonCanUse{

    if (self.account.account.length>0||self.account.passWord.length>0) {
        [self setButtonCanUse:YES];
        if (self.account.account.length == 11) {
            NSURL * imageUrl = [NSURL URLWithString:[UserInfoManager getUserImageWithAccount:self.account.account]];
            [self.logoImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"Imported_Layers_Copy"]];

        }else{
            self.logoImage.image = [UIImage imageNamed:@"Imported_Layers_Copy"];
        }
        
    }else{
        [self setButtonCanUse:NO];
    }

}

-(void)LoginAccount:(NSString*)account
           password:(NSString*)password{
    [self getIMAccount:account password:password];
}
#pragma mark 获取token和account
-(void)getIMAccount:(NSString*)account password:(NSString*)password{
    NSString *app_Version = [Common getAppVersion];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor] andAlpha:0.6];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
    __weak typeof(self)wSelf = self;
    [PassportService userIMLoginAccount:account password:password type:@"UTOUU-M-IOS" version:app_Version view:nil callback:^(id result, NSError *error) {
        
        NSDictionary *result_dic = result;
        if (result_dic) {
            BOOL success = [[result_dic objectForKey:@"success"] boolValue];
            if (success) {
                NSString *accid = [result_dic objectForKey:@"accid"];
                NSString *token = [result_dic objectForKey:@"token"];
                [wSelf LoginIM:[accid lowercaseString] token:token username:account password:password];
            }else{
                [SVProgressHUD dismiss];
                [wSelf.view makeToast:[result_dic objectForKey:@"msg"] duration:2.0 position:CSToastPositionCenter];
            }
        }
    }];
    
}
-(void)LoginIM:(NSString*)account token:(NSString*)token username:(NSString*)username password:(NSString*)password{
    __weak typeof(self)wSelf = self;
    [[[NIMSDK sharedSDK] loginManager] login:account
                                       token:token
                                  completion:^(NSError *error) {
                                      [SVProgressHUD dismiss];
                                      if (error == nil)
                                      {
                                          LoginData *sdkData = [[LoginData alloc] init];
                                          sdkData.account   = account;
                                          sdkData.token     = token;
                                          [[NTESLoginManager sdkManager] setCurrentLoginData:sdkData];
                                          
                                          
                                          LoginData *appData = [[LoginData alloc] init];
                                          appData.account    = username;
                                          appData.token      = password;
                                          [[NTESLoginManager appManager] setCurrentLoginData:appData];
                                          [[NTESServiceManager sharedManager] start];
                                          NTESMainTabController * mainTab = [[NTESMainTabController alloc] initWithNibName:nil bundle:nil];
                                          [UIApplication sharedApplication].keyWindow.rootViewController = mainTab;
                                          [UserInfoManager saveToUserListWithName:username];
                                          [wSelf checkOtherLogin];
                                      }
                                      else
                                      {
                                          if (error.code == 302) {
                                              [self.view makeToast:@"密码错误" duration:2.0 position:CSToastPositionCenter];
                                          }else{
                                              [self.view makeToast:@"登录失败" duration:2.0 position:CSToastPositionCenter];
                                          }
                                      }
                                  }];
}

-(void)checkOtherLogin{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray * loginArr = [NIMSDK sharedSDK].loginManager.currentLoginClients;
        [loginArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NIMLoginClient * client = obj;
            if (client.type == NIMLoginClientTypeAOS||client.type == NIMLoginClientTypeIOS) {
                __weak typeof(self) wself = self;
                [[NIMSDK sharedSDK].loginManager kickOtherClient:client completion:^(NSError *error) {
                    if (error) {
                        [wself.view.window makeToast:@"踢出失败"];
                    }
                }];
                
            }
        }];
    });
}

-(BOOL)checkLoginParamas{
    
    NSString *usr = self.account.account;
    
    NSString *pwd = self.account.passWord;
    if (usr.length ==0) {
        
        [Common AlertViewTitle:@"提示"
                       message:@"账号不能为空"
                      delegate:nil
             cancelButtonTitle:@"确定"
             otherButtonTitles:nil];
        
        return NO;
    }
    else if (usr.length !=11) {
        
        [Common AlertViewTitle:@"提示"
                       message:@"账号错误"
                      delegate:nil
             cancelButtonTitle:@"确定"
             otherButtonTitles:nil];
        return NO;
        
        
    }
    else if (pwd.length == 0){
        
        [Common AlertViewTitle:@"提示"
                       message:@"密码不能为空"
                      delegate:nil
             cancelButtonTitle:@"确定"
             otherButtonTitles:nil];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
