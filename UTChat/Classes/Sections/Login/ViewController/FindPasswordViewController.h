//
//  FindPasswordViewController.h
//  UChat
//
//  Created by dcj on 15/11/11.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UTRegisterCell.h"

@interface FindPasswordViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UTRegisterDelegate>

@property (nonatomic,strong) UIButton * nextButton;
@property (nonatomic,assign) BOOL buttonCanUse;
@property (nonatomic,strong) UIView * tableViewFooterView;
@property (nonatomic,strong) UITableView * findTableView;


/**
 *  子类 重写
 *
 *  @param button <#button description#>
 */
-(void)nextButtonClick:(UIButton *)button;

@end
