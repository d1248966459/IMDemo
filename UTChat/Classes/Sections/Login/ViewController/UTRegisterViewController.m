//
//  UTRegisterViewController.m
//  UTChat
//
//  Created by dcj on 15/11/10.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "UTRegisterViewController.h"

#import "PassportService.h"
#import "InterfaceURLs.h"
#import "CacheFile.h"
#import "UTTextField.h"
#import "Result.h"
#import "AppDelegate.h"
#import "AccountInfo.h"
#import "UTRegisterCell.h"
#import <WebKit/WebKit.h>

#define  IMAGE_AUTORESIZINGMASK  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
#define IMAGE_CONTENTMODE UIViewContentModeScaleAspectFill
#define DEVICE_IS_IPHONR5 [[UIScreen mainScreen] bounds].size.height
#define RGB(__r, __g, __b)  [UIColor colorWithRed:(1.0*(__r)/255)\
green:(1.0*(__g)/255)\
blue:(1.0*(__b)/255)\
alpha:1.0]
#define TEXTCOLOR RGB(202, 202, 207)
#define ratio      [UIScreen mainScreen].bounds.size.width/320

#define FONT(_f)     [UIFont systemFontOfSize:(_f)]

#define Version_8_later     [[[UIDevice currentDevice] systemVersion] floatValue]>=8.0;



@interface UTRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,UTRegisterDelegate,WKNavigationDelegate,WKUIDelegate>{
    BOOL click_state;
    UIImageView *leftView;
    
    
}

@property (nonatomic,strong) UITableView * registerTableView;
@property (nonatomic,strong) AccountInfo * account;
@property (nonatomic,strong) UIButton * registerButton;

@property (nonatomic,strong) UIView * tableViewFooterView;
@property (nonatomic,assign) BOOL buttonCanUse;


@end

@implementation UTRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机快速注册";
    self.account = [[AccountInfo alloc] init];
    self.registerTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.registerTableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    self.registerTableView.delegate = self;
    self.registerTableView.dataSource = self;
    self.registerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.registerTableView];
    [self.registerTableView registerNib:[UINib nibWithNibName:@"UTRegisterCell" bundle:nil] forCellReuseIdentifier:@"UTRegisterCell"];
    
    [Common SetSubViewExternNone:self];
    
    [self layoutTableViewFooterView];
}

-(void)layoutTableViewFooterView{
    self.tableViewFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    self.tableViewFooterView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    self.registerTableView.tableFooterView = self.tableViewFooterView;
    
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    textLabel.text = @"如果你已是UTOUU用户，请直接登录";
    textLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    textLabel.font = [UIFont systemFontOfSize:12];
    [self.tableViewFooterView addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableViewFooterView.mas_left).mas_offset(20);
        make.top.equalTo(self.tableViewFooterView.mas_top).mas_offset(10);
    }];
    
    UIButton * registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"button_no_canuse"] forState:UIControlStateDisabled];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"button_default"] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"button_canuse"] forState:UIControlStateHighlighted];

    [registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.registerButton = registerButton;
    self.buttonCanUse = NO;
    [self.tableViewFooterView addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableViewFooterView.mas_left).mas_offset(20);
        make.right.equalTo(self.tableViewFooterView.mas_right).mas_offset(-20);
        make.top.equalTo(self.tableViewFooterView.mas_top).mas_offset(33*ratio);
        make.height.equalTo(@(45*ratio));
    }];
    
    UILabel * agreeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    agreeLabel.numberOfLines = 0;
    agreeLabel.textAlignment = NSTextAlignmentCenter;
    agreeLabel.text = @"轻触上面的 “注册” 按钮,即表示你同意";
    agreeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    agreeLabel.font = [UIFont systemFontOfSize:10];
    
    [self.tableViewFooterView addSubview:agreeLabel];
    [agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registerButton.mas_left);
        make.right.equalTo(registerButton.mas_right);
        make.top.equalTo(registerButton.mas_bottom).mas_offset(5);
    }];
    
    UILabel * registerUserProtocol = [[UILabel alloc] initWithFrame:CGRectZero];
    registerUserProtocol.numberOfLines = 0;
    registerUserProtocol.textAlignment = NSTextAlignmentCenter;
    registerUserProtocol.text = @"UTOUU服务协议";
    registerUserProtocol.textColor = [UIColor colorWithHexString:@"#4c9bff"];
    registerUserProtocol.font = [UIFont systemFontOfSize:10];
   
    [self.tableViewFooterView addSubview:registerUserProtocol];
    
    [registerUserProtocol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agreeLabel.mas_left);
        make.right.equalTo(agreeLabel.mas_right);
        make.top.equalTo(agreeLabel.mas_bottom).mas_offset(3);
    }];
    /**
     *  用来扩大注册协议的点击 范围
     */
    UIButton * tempbuttom = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tableViewFooterView addSubview:tempbuttom];
    tempbuttom.backgroundColor = [UIColor clearColor];
    [tempbuttom addTarget:self action:@selector(registerUserProtocol:) forControlEvents:UIControlEventTouchUpInside];
    [tempbuttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerUserProtocol.mas_top);
        make.left.equalTo(registerUserProtocol.mas_left);
        make.right.equalTo(registerUserProtocol.mas_right);
        make.height.equalTo(@(40));
    }];
    
}

-(void)registerUserProtocol:(UIButton *)tap{

    [self ReadDelegatetext];
}

-(void)setButtonCanUse:(BOOL)buttonCanUse{
    _buttonCanUse = buttonCanUse;
//    if (buttonCanUse) {
//        [self.registerButton setBackgroundColor:[UIColor colorWithHexString:@"#fd4876"]];
//    }else{
//        [self.registerButton setBackgroundColor:[UIColor colorWithHexString:@"#fec2d1"]];
//        
//    }
    [self.registerButton setEnabled:buttonCanUse];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 48;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UTRegisterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UTRegisterCell"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellType = indexPath.row;
    return cell;
}

-(void)registerButtonClick:(UIButton *)button{
    BOOL result = [self checkCanRegister];
    if (result) {
        [self registerAccount];
    }
}


-(void)regsterCell:(UTRegisterCell *)cell textField:(UITextField *)textField{
    switch (cell.cellType) {
        case RegisterCellTypeAccount:
            self.account.account = textField.text;
            break;
        case RegisterCellTypePassWord:
            self.account.passWord = textField.text;
            break;
        case RegisterCellTypeAnHao:
            self.account.anHao = textField.text;
            break;
        case RegisterCellTypeVerifyCode:
            self.account.verfiyCode = textField.text;
            break;
        default:
            break;
    }
    [self checkRegisterButtonCanUse];
}

-(void)checkRegisterButtonCanUse{
    if (self.account.account.length>0||self.account.passWord.length>0||self.account.anHao.length>0||self.account.verfiyCode.length>0) {
        self.buttonCanUse = YES;
    }else{
        self.buttonCanUse = NO;
    }

}

-(BOOL)checkCanRegister{
    /**
     *  手机号
     */
    if (!self.account.account || self.account.account.length == 0) {
        
        [Common AlertViewTitle:@"提示"
                        message:@"请输入手机号码"
                       delegate:nil
              cancelButtonTitle:@"确定"
              otherButtonTitles:nil];

        return NO;
    }
    BOOL result = [Common checkIsPhoneNo:self.account.account];
    if (!result) {
        [Common AlertViewTitle:@"提示"
                        message:@"请输入正确的手机号码"
                       delegate:nil
              cancelButtonTitle:@"确定"
              otherButtonTitles:nil];
        return NO;
    }
    /**
     *  密码
     */
    if (self.account.passWord.length == 0 || !self.account.passWord) {
        [Common AlertViewTitle:@"提示"
                       message:@"请输入密码"
                      delegate:nil
             cancelButtonTitle:@"确定"
             otherButtonTitles:nil];
        return NO;
    }else{
        if (self.account.passWord.length < 6) {
            [Common AlertViewTitle:@"提示"
                           message:@"密码长度不能小于6个字符"
                          delegate:nil
                 cancelButtonTitle:@"确定"
                 otherButtonTitles:nil];
            return NO;
        }else if (self.account.passWord.length>18){
            [Common AlertViewTitle:@"提示"
                           message:@"密码长度不能大于18个字符"
                          delegate:nil
                 cancelButtonTitle:@"确定"
                 otherButtonTitles:nil];
            return NO;
        }
    }
    /**
     *  验证码
     */
    if (self.account.verfiyCode.length == 0) {
        [Common AlertViewTitle:@"提示"
                       message:@"请输入验证码"
                      delegate:nil
             cancelButtonTitle:@"确定"
             otherButtonTitles:nil];
        return NO;
    }
    return YES;
}



-(void)ReadDelegatetext
{
    
    
#ifdef Version_8_later
    
    WKWebView *webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    webview.UIDelegate =self;
    webview.navigationDelegate =self;
#elif
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    
#endif
    [self.view addSubview:webview];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cdn1.utouu.com/ui/pc/agreement/im-agreement.html"]]];

}



#pragma mark 注册方法
-(void)registerAccount{
    
    NSString *cipher;
    if ([self.account.anHao isEqualToString:@""]||!self.account.anHao) {
        
        cipher = @"";
        
    }
    else{
        
        cipher = self.account.anHao;
        
    }
    
    NSString *time = [MD5 getSystemTime];
    
    NSString *uuid = [ManagerSetting getVerifyCodeUUID];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.account.account,@"account",
                          self.account.passWord,@"password",
                          @"6",@"source",
                          @"",@"visitor",
                          cipher,@"cipher",
                          @"",@"openId",
                          self.account.verfiyCode,@"imgVCode",
                          uuid,@"imgVCodeKey", nil];
    
    NSString *sign = [MD5 md5:dic1 time:time];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.account.account,@"account",
                         self.account.passWord,@"password",
                         @"6",@"source",
                         @"",@"visitor",
                         cipher,@"cipher",
                         @"",@"openId",
                         self.account.verfiyCode,@"imgVCode",
                         uuid,@"imgVCodeKey",
                         sign,@"sign",
                         time,@"time", nil];
    
    [PassportService registerUserAccount:self:dic :^(id obj) {
        
        Result *register_Result = [[Result alloc]init];
        
        register_Result = (Result *)obj;
        
        if (register_Result.success) {
            
            NSString *message = register_Result.msg;
            
            [Common AlertViewTitle:@"提示"
                           message:message
                          delegate:self
                 cancelButtonTitle:@"确定"
                 otherButtonTitles:nil];
            
        }else{
            
            NSString *message = register_Result.msg;
            
            [Common AlertViewTitle:@"提示"
                           message:message
                          delegate:nil
                 cancelButtonTitle:@"确定"
                 otherButtonTitles:nil];
            
        }
        
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end;