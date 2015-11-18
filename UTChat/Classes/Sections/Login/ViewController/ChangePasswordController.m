//
//  ChangePasswordController.m
//  UChat
//
//  Created by dcj on 15/11/11.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "ChangePasswordController.h"

@interface ChangePasswordController ()

@end

@implementation ChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.account = [[AccountInfo alloc] init];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UTRegisterCell * cell = (UTRegisterCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.cellType = RegisterCellTypeNewPassword;
    }else if (indexPath.row == 1){
        cell.cellType = RegisterCellTypeNewPasswordAgain;
    }
    return cell;
}

-(void)regsterCell:(UTRegisterCell *)cell textField:(UITextField *)textField{
    if (cell.cellType == RegisterCellTypeNewPassword) {
        self.account.oldPassword = textField.text;
    }else if (cell.cellType == RegisterCellTypeNewPasswordAgain){
        self.account.willChagePassword = textField.text;
    }
    [self chekButtonCanUse];
}

-(void)chekButtonCanUse{
    if (self.account.oldPassword.length>0||self.account.willChagePassword.length>0) {
        [self setButtonCanUse:YES];
    }else{
        [self setButtonCanUse:NO];
    }
}

-(void)nextButtonClick:(UIButton *)button{
    if ([self checkPassWord]) {
        [PassportService changePasswordSendSMS:self.account compeletion:^(id result, NSError *error) {
            if (error) {
                
            }else{
                if ([[result objectForKey:@"sucess"] boolValue]) {
                    [ShowMessage showMessage:@"修改成功" withCenter:self.view.center];
                }else{
                    [ShowMessage showMessage:@"请求错误" withCenter:self.view.center];
                }
                
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}
-(BOOL)checkPassWord{
    if (self.account.oldPassword.length == 0 || !self.account.oldPassword) {
        [Common AlertViewTitle:@"提示"
                       message:@"请输入密码"
                      delegate:nil
             cancelButtonTitle:@"确定"
             otherButtonTitles:nil];
        return NO;
    }else{
        if (self.account.oldPassword.length < 6) {
            [Common AlertViewTitle:@"提示"
                           message:@"密码长度不能小于6个字符"
                          delegate:nil
                 cancelButtonTitle:@"确定"
                 otherButtonTitles:nil];
            return NO;
        }else if (self.account.oldPassword.length>18){
            [Common AlertViewTitle:@"提示"
                           message:@"密码长度不能大于18个字符"
                          delegate:nil
                 cancelButtonTitle:@"确定"
                 otherButtonTitles:nil];
            return NO;
        }
    }
    if (self.account.willChagePassword.length == 0 || !self.account.willChagePassword) {
        [Common AlertViewTitle:@"提示"
                       message:@"请输入密码"
                      delegate:nil
             cancelButtonTitle:@"确定"
             otherButtonTitles:nil];
        return NO;
    }else{
        if (self.account.willChagePassword.length < 6) {
            [Common AlertViewTitle:@"提示"
                           message:@"密码长度不能小于6个字符"
                          delegate:nil
                 cancelButtonTitle:@"确定"
                 otherButtonTitles:nil];
            return NO;
        }else if (self.account.willChagePassword.length>18){
            [Common AlertViewTitle:@"提示"
                           message:@"密码长度不能大于18个字符"
                          delegate:nil
                 cancelButtonTitle:@"确定"
                 otherButtonTitles:nil];
            return NO;
        }
    }
    if ([self.account.oldPassword isEqualToString:self.account.willChagePassword]) {
        return YES;
    }else{
        [Common AlertViewTitle:@"提示"
                       message:@"两次输入密码不一样"
                      delegate:nil
             cancelButtonTitle:@"确定"
             otherButtonTitles:nil];
        return NO;
    }
    
}

@end
