//
//  NTESRegisterViewController.h
//  NIM
//
//  Created by amao on 8/10/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTESRegisterViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *accountTextfield;

@property (nonatomic, weak) IBOutlet UITextField *nicknameTextfield;

@property (nonatomic, weak) IBOutlet UITextField *passwordTextfield;

@property (nonatomic, weak) IBOutlet UIView *containView;

@property (nonatomic, weak) IBOutlet UIButton *existedButton;

@property (nonatomic, weak) IBOutlet UIImageView *logo;

@end
