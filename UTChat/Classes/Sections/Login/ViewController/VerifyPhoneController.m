//
//  VerifyPhoneController.m
//  UChat
//
//  Created by dcj on 15/11/11.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "VerifyPhoneController.h"
#import "ChangePasswordController.h"

@interface VerifyPhoneController ()

@end

@implementation VerifyPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UTRegisterCell * cell = (UTRegisterCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.cellType = RegisterCellTypeVerifyPhone;
    
    return cell;
}

-(void)regsterCell:(UTRegisterCell *)cell textField:(UITextField *)textField{
    if (cell.cellType == RegisterCellTypeVerifyPhone) {
        self.account.smsVerfiyCode = textField.text;
    }
    [self chekButtonCanUse];
}

-(void)chekButtonCanUse{
    if (self.account.smsVerfiyCode.length >0) {
        [self setButtonCanUse:YES];
    }else{
        [self setButtonCanUse:NO];
    }
}

-(void)nextButtonClick:(UIButton *)button{
    __weak typeof(self)wSelf = self;
    [PassportService verifyPhoneCode:self.account compeletion:^(id result, NSError *error) {
        if (error||[result objectForKey:@"data"] == nil) {
            [ShowMessage showMessage:@"请求错误" withCenter:self.view.center];
        }else{
            wSelf.account.idenKey = [result objectForKey:@"data"];
            ChangePasswordController * changeVC = [[ChangePasswordController alloc] init];
            changeVC.account = wSelf.account;
            [self.navigationController pushViewController:changeVC animated:YES];
        }
    }];
}


@end
