//
//  UTRegisterViewController.h
//  UTChat
//
//  Created by dcj on 15/11/10.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccountInfo;

@interface UTRegisterViewController : UIViewController

@property (nonatomic,copy) void (^RegisterCompeletion)(AccountInfo * account);

@end
