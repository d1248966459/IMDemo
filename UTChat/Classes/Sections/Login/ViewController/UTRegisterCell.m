//
//  UTRegisterCell.m
//  UChat
//
//  Created by dcj on 15/11/10.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "UTRegisterCell.h"

@interface UTRegisterCell ()<UITextFieldDelegate>

@property (nonatomic,assign) BOOL passWordSeleted;;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic,assign) NSInteger second;
@property (nonatomic,strong) NSTimer * readSecondTimer;

@property (nonatomic,assign) BOOL otherShow;



@end

@implementation UTRegisterCell

- (void)awakeFromNib {
    
    self.textField.layer.borderWidth = 0;
    self.textField.layer.borderColor = [UIColor whiteColor].CGColor;
    self.leftLogoLabel.font=[UIFont fontWithName:@"iconfont" size:17];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    self.textField.delegate = self;
    self.leftLogoLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


-(void)setRightView:(UIView *)rightView{
    
    _rightView = rightView;
    [self.contentView addSubview:rightView];
    rightView.right = [UIScreen mainScreen].bounds.size.width;
    rightView.centerY = self.contentView.height/2;
    
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLogoLabel.mas_right);
        make.right.equalTo(_rightView.mas_left);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@(30));
    }];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.cellType == RegisterCellTypeLoginAccount) {
        self.otherShow = YES;
        if ([self.delegate respondsToSelector:@selector(regsterCell:textFieldClick:)]) {
            [self.delegate regsterCell:self textFieldClick:textField];
        }
        if (self.otherShow) {
            [self otherTap:nil];
        }
        if (self.canEditing) {
            return YES;
        }else{
            return NO;
        }

    }else{
        return YES;
    }
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setCellType:(RegisterCellType)cellType{
    if (self.rightView) {
        
        [self.rightView removeFromSuperview];
    
    }
    _cellType = cellType;
    self.lineView.hidden = NO;
    if (cellType == RegisterCellTypeAccount) {
        [self setLeftLogoLabelText:@"\U0000e62c"];
        self.textField.placeholder = @"请输入你的手机号";
    }else if (cellType == RegisterCellTypePassWord){
        [self setLeftLogoLabelText:@"\U0000e625"];
        self.textField.placeholder = @"请输入6-18位密码";
        [self passWordRightView];
    }else if (cellType == RegisterCellTypeAnHao){
        [self setLeftLogoLabelText:@"\U0000e62e"];
        self.textField.placeholder = @"请输入暗号(选填)";
    }else if (cellType == RegisterCellTypeVerifyCode){
        [self setLeftLogoLabelText:@"\U0000e624"];
        self.textField.placeholder = @"请输入图片验证码";
        [self setVerfyCodeRightView];
        self.lineView.hidden = YES;
    }else if (cellType == RegisterCellTypeVerifyPhone){
        [self setLeftLogoLabelText:@"\U0000e62c"];
        self.textField.placeholder = @"请输入短信验证码";
        [self readSecondView];
        self.lineView.hidden = YES;
    }else if (cellType == RegisterCellTypeNewPassword){
        [self setLeftLogoLabelText:@"\U0000e625"];
        self.textField.placeholder = @"请输入6-18位新密码";
        [self passWordRightView];
    }else if (cellType == RegisterCellTypeNewPasswordAgain){
        [self setLeftLogoLabelText:@"\U0000e625"];
        self.textField.placeholder = @"请再次确认新密码";
        self.textField.secureTextEntry = YES;
    }else if (cellType == RegisterCellTypeLoginAccount){
        [self setLeftLogoLabelText:@"\U0000e62c"];
        [self loginAccountRightView];
    }
}

-(void)loginAccountRightView{
    self.otherShow = NO;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 56, 28)];
    UILabel * clearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    UILabel * oteherLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, 28, 28)];
    clearLabel.font = [UIFont fontWithName:@"iconfont" size:17];
    oteherLabel.font = [UIFont fontWithName:@"iconfont" size:17];
    [view addSubview: clearLabel];
    [view addSubview:oteherLabel];
    clearLabel.text = @"\U0000e605";
    clearLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    oteherLabel.text = @"\U0000e616";
    oteherLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    oteherLabel.tag = 12345;
    self.rightView = view;
    
    UITapGestureRecognizer * clearTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearTap)];
    [clearLabel addGestureRecognizer:clearTap];
    clearLabel.userInteractionEnabled = YES;
    oteherLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * otherTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherTap:)];
    [oteherLabel addGestureRecognizer:otherTap];
}
-(void)clearTap{
    self.textField.text = nil;
}

-(void)otherTap:(UITapGestureRecognizer *)tap{
    self.otherShow = !self.otherShow;
    UILabel * otherLabel = (UILabel *)[self.rightView viewWithTag:12345];
    if (self.otherShow) {
        otherLabel.text = @"\U0000e621";
    }else{
        otherLabel.text = @"\U0000e616";
    }
    if ([self.delegate respondsToSelector:@selector(regsterCell:otherAccountShow:)]) {
        [self.delegate regsterCell:self otherAccountShow:self.otherShow];
    }
}


-(void)passWordbtnClick:(UITapGestureRecognizer *)tap{
    self.passWordSeleted = !self.passWordSeleted;
}

-(void)setPassWordSeleted:(BOOL)passWordSeleted{
    _passWordSeleted = passWordSeleted;
    UILabel * tempLabel = (UILabel *)self.rightView;
    if (passWordSeleted) {
        tempLabel.text = @"\U0000e61c";
        tempLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
    }else{
        tempLabel.text = @"\U0000e61b";
        tempLabel.textColor = [UIColor colorWithHexString:@"#fd4876"];
    }
    self.textField.secureTextEntry = passWordSeleted;
}

-(void)setLeftLogoLabelText:(NSString *)text{

    self.leftLogoLabel.text = text;

}

-(void)readSecondView{
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(readSecond) userInfo:nil repeats:YES];
    [timer setFireDate:[NSDate distantPast]];
    self.readSecondTimer = timer;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    label.textColor = [UIColor colorWithHexString:@"#cccccc"];
    self.rightView = label;
    label.textAlignment = NSTextAlignmentLeft;
    self.second = 60;
    label.text = [NSString stringWithFormat:@"%lu秒",self.second];
}

-(void)readSecond{
    UILabel * label = (UILabel *)self.rightView;
    self.second = self.second - 1;
    
    label.text = [NSString stringWithFormat:@"%lu秒",self.second];
    if (self.second == 0) {
        [self.readSecondTimer setFireDate:[NSDate distantFuture]];
    }
}

-(void)passWordRightView{
    UILabel * passwordRightView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 38, 28)];
    passwordRightView.font = [UIFont fontWithName:@"iconfont" size:17];
    passwordRightView.textAlignment = NSTextAlignmentCenter;
    passwordRightView.textColor = [UIColor colorWithHexString:@"#cccccc"];
    passwordRightView.text = @"\U0000e61c";
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passWordbtnClick:)];
    [passwordRightView addGestureRecognizer:tap];
    passwordRightView.userInteractionEnabled = YES;
    self.rightView = passwordRightView;
    self.passWordSeleted = YES;
}

-(void)setVerfyCodeRightView{
    UIImageView * verifyCodeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    verifyCodeView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(applyforVerifyCode)];
    [verifyCodeView addGestureRecognizer:tap];
    self.rightView = verifyCodeView;
    [self applyforVerifyCode];
}

-(void)applyforVerifyCode{
    __weak typeof(self)wSelf = self;
    [PassportService applyforVerifyCode:^(id obj) {
        UIImageView * tempImageView = (UIImageView *)wSelf.rightView;
        if (obj == nil) {
            tempImageView.image = [UIImage imageNamed:@"default_img_vify.png"];
        }
        else{
            tempImageView.image = [UIImage imageWithData:obj];
        }
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self.textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidChange:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(regsterCell:textField:)]) {
        [self.delegate regsterCell:self textField:textField];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

-(void)hideLineView{

    self.lineView.hidden = YES;
}

-(void)setFullLine{
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@(1));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];

}

-(void)hideRightView{
    self.rightView.hidden = YES;
}
-(void)showRightView{
    self.rightView.hidden = NO;
}

@end
