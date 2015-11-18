//
//  UTRegisterCell.h
//  UChat
//
//  Created by dcj on 15/11/10.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, RegisterCellType) {
    RegisterCellTypeAccount = 0,
    RegisterCellTypePassWord,
    RegisterCellTypeAnHao,
    RegisterCellTypeVerifyCode,
    RegisterCellTypeVerifyPhone = 100,
    RegisterCellTypeNewPassword,
    RegisterCellTypeNewPasswordAgain,
    RegisterCellTypeLoginAccount,
};

@class UTRegisterCell;
@protocol UTRegisterDelegate <NSObject>
@optional
-(void)regsterCell:(UTRegisterCell *)cell textField:(UITextField *)textField;
-(void)regsterCell:(UTRegisterCell *)cell otherAccountShow:(BOOL)show;
-(void)regsterCell:(UTRegisterCell *)cell textFieldClick:(UITextField *)textField;
-(void)regsterCell:(UTRegisterCell *)cell setButtonCanUseWithTextField:(UITextField *)textField;
@end


@interface UTRegisterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLogoLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,strong) UIView * rightView;

@property (nonatomic,weak)id<UTRegisterDelegate>delegate;

@property (nonatomic,assign) RegisterCellType cellType;

@property (nonatomic,assign) BOOL canEditing;


-(void)hideLineView;
-(void)setFullLine;
-(void)hideRightView;
-(void)showRightView;
@end
