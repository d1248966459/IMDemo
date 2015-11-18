//
//  FindPasswordViewController.m
//  UChat
//
//  Created by dcj on 15/11/11.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "UTRegisterCell.h"


@interface FindPasswordViewController ()


@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";

    self.findTableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.findTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.findTableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    self.findTableView.delegate = self;
    self.findTableView.dataSource = self;
    self.findTableView.scrollEnabled = NO;
    [self.findTableView registerNib:[UINib nibWithNibName:@"UTRegisterCell" bundle:nil] forCellReuseIdentifier:@"UTRegisterCell"];
    [self.view addSubview:self.findTableView];
    [self layoutTableViewFooterView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UTRegisterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UTRegisterCell"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
-(void)layoutTableViewFooterView{
    self.tableViewFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    self.tableViewFooterView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    self.findTableView.tableFooterView = self.tableViewFooterView;
    
    UIButton * registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"下一步" forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"button_no_canuse"] forState:UIControlStateDisabled];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"button_default"] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"button_canuse"] forState:UIControlStateHighlighted];

    [registerButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton = registerButton;
    self.buttonCanUse = NO;
    [self.tableViewFooterView addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableViewFooterView.mas_left).mas_offset(20);
        make.right.equalTo(self.tableViewFooterView.mas_right).mas_offset(-20);
        make.top.equalTo(self.tableViewFooterView.mas_top).mas_offset(10);
        make.height.equalTo(@(45));
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)nextButtonClick:(UIButton *)button{


}



-(void)setButtonCanUse:(BOOL)buttonCanUse{
    _buttonCanUse = buttonCanUse;
//    if (buttonCanUse) {
//        [self.nextButton setBackgroundColor:[UIColor colorWithHexString:@"#fd4876"]];
//    }else{
//        [self.nextButton setBackgroundColor:[UIColor colorWithHexString:@"#ffc2d1"]];
//        
//    }
    [self.nextButton setEnabled:buttonCanUse];
}

@end
