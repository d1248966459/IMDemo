//
//  NTESContactAddFriendViewController.m
//  NIM
//
//  Created by chris on 15/8/18.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESContactAddFriendViewController.h"
#import "NTESCommonTableDelegate.h"
#import "NTESCommonTableData.h"
#import "UIView+Toast.h"
#import "SVProgressHUD.h"
#import "NTESPersonalCardViewController.h"
#import "IMService.h"
#import "UIView+NIM.h"
#import "UIImage+NIM.h"
#import "NTESTextSettingCell.h"
@interface NTESContactAddFriendViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NTESCommonTableDelegate *delegator;

@property (nonatomic,copy  ) NSArray                 *data;

@property (nonatomic,assign) NSInteger               inputLimit;


@end

@implementation NTESContactAddFriendViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加悠客";
    __weak typeof(self) wself = self;
    //[self buildData];
    self.delegator = [[NTESCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xe3e6ea);
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    
    [_searchButton setBackgroundImage:[UIImage nim_imageInKit:@"icon_input_send_btn_normal"] forState:UIControlStateNormal];
    [_searchButton setBackgroundImage:[UIImage nim_imageInKit:@"icon_input_send_btn_pressed"] forState:UIControlStateHighlighted];
    
    _searchButton.nim_height = 25;
    _searchButton.nim_width = 50;
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:_searchButton];
    self.navigationItem.rightBarButtonItem = menuButton;
    SEL search = @selector(clickButtonEnent);
    [_searchButton addTarget:self action:search forControlEvents:UIControlEventTouchUpInside];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *textcell = @"textCell";
    NTESTextSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:textcell];
    if (cell == nil) {
        cell = [[NTESTextSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textcell];
    }
    cell.textField.placeholder = @"请输入好友昵称";
    cell.tag = 10086;
    return cell;
    
}


//- (void)buildData{
//    NSArray *data = @[
//                      @{
//                          HeaderTitle:@"",
//                          RowContent :@[
//                                  @{
//                                      Title         : @"请输入好友昵称",
//                                      CellClass     : @"NTESTextSettingCell",
//                                      RowHeight     : @(50),
//                                      },
//                                  ],
//                          FooterTitle:@""
//                          },
//                      ];
//    self.data = [NTESCommonTableSection sectionsWithData:data];
//}

-(void)clickButtonEnent{
    NTESTextSettingCell *cell = (NTESTextSettingCell*)[self.view viewWithTag:10086];
    [IMService getUserIMAccount:nil nickname:cell.textField.text callback:^(id obj1, id obj2) {
        NSDictionary *back_dic = obj1;
        BOOL success = [[back_dic objectForKey:@"success"] boolValue];
        if (success) {
            NSDictionary *data_dic = [back_dic objectForKey:@"data"];
            NSString *nim_acc_id = [[data_dic objectForKey:@"nim_acc_id"] lowercaseString];
            NSString *userId = [nim_acc_id stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (userId.length) {
                [self addFriend:userId];
            }
        }
        else
        {
            NSString *msg = [back_dic objectForKey:@"msg"];
            [ShowMessage showMessage:msg withCenter:self.view.center];
        }
        
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [IMService getUserIMAccount:nil nickname:textField.text callback:^(id obj1, id obj2) {
        NSDictionary *back_dic = obj1;
        BOOL success = [[back_dic objectForKey:@"success"] boolValue];
        if (success) {
            NSDictionary *data_dic = [back_dic objectForKey:@"data"];
            NSString *nim_acc_id = [[data_dic objectForKey:@"nim_acc_id"] lowercaseString];
            NSString *userId = [nim_acc_id stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (userId.length) {
                [self addFriend:userId];
            }
        }
        else
        {
            NSString *msg = [back_dic objectForKey:@"msg"];
            [ShowMessage showMessage:msg withCenter:self.view.center];
        }
        
    }];
       return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}


#pragma mark - Private
- (void)addFriend:(NSString *)userId{
    __weak typeof(self) wself = self;
    [SVProgressHUD show];
    [[NIMSDK sharedSDK].userManager fetchUserInfos:@[userId] completion:^(NSArray *users, NSError *error) {
        [SVProgressHUD dismiss];
        if (users.count) {
            NTESPersonalCardViewController *vc = [[NTESPersonalCardViewController alloc] initWithUserId:userId];
            [wself.navigationController pushViewController:vc animated:YES];
        }else{
            if (wself) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该用户不存在" message:@"请检查你输入的帐号是否正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }];
}


@end
