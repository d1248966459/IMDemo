//
//  NTESAboutViewController.m
//  NIM
//
//  Created by chris on 15/7/30.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESAboutViewController.h"
#import "NIMKit.h"
@interface NTESAboutViewController ()

@end

@implementation NTESAboutViewController

- (void)viewDidLoad {
   [super viewDidLoad];
    self.navigationItem.title = @"关于";
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    NSString *version = [NSString stringWithFormat:@"%@.%@",[infoDict objectForKey:@"CFBundleShortVersionString"],versionNum];
   self.versionLabel.text = [NSString stringWithFormat:@"版本号：%@",version];
    self.versionLabel.font = [UIFont systemFontOfSize:13];
}


@end
