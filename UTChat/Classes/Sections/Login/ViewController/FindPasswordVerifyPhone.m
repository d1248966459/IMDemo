//
//  FindPasswordVerifyPhone.m
//  UChat
//
//  Created by dcj on 15/11/11.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "FindPasswordVerifyPhone.h"
#import "AccountInfo.h"
#import "VerifyPhoneController.h"

@interface FindPasswordVerifyPhone ()

@property (nonatomic,strong) AccountInfo * account;


@end

@implementation FindPasswordVerifyPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    self.account = [[AccountInfo alloc] init];
    [self setButtonCanUse:NO];
    
    // Do any additional setup after loading the view.
}

-(void)regsterCell:(UTRegisterCell *)cell textField:(UITextField *)textField{
    if (cell.cellType == RegisterCellTypeAccount) {
        self.account.account = textField.text;
    }else if (cell.cellType == RegisterCellTypeVerifyCode){
        self.account.verfiyCode = textField.text;
    }
    [self checkNextbuttonCanUse];
}

-(void)checkNextbuttonCanUse{
    if (self.account.account.length>0||self.account.verfiyCode.length>0) {
        [self setButtonCanUse:YES];
    }else{
        [self setButtonCanUse:NO];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UTRegisterCell * cell = (UTRegisterCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.cellType = RegisterCellTypeAccount;
    }else if (indexPath.row == 1){
        cell.cellType = RegisterCellTypeVerifyCode;
    }
    return cell;
}

-(void)nextButtonClick:(UIButton *)button{

    __weak typeof(self)wSelf = self;
    [PassportService getPhoneVerifyCode:self.account compeletion:^(id result, NSError *error) {
        if (error||result == nil) {
            [ShowMessage showMessage:@"请求错误" withCenter:self.view.center];
        }else{
            VerifyPhoneController * verVC = [[VerifyPhoneController alloc] init];
            verVC.account = wSelf.account;
            [wSelf.navigationController pushViewController:verVC animated:YES];
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
