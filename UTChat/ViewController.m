//
//  ViewController.m
//  UTChat
//
//  Created by dcj on 15/11/6.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "ViewController.h"

#define ratio      [UIScreen mainScreen].bounds.size.width/320

@interface ViewController ()

@property (nonatomic,strong) UIImageView * logoImage;
@property (nonatomic,strong) UIImageView * textImage;
@property (nonatomic,strong) UILabel * logoLabel;



@end

@implementation ViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
//    
//    // Do any additional setup after loading the view, typically from a nib.
//}
//
//-(void)initSubViews{
//    self.logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90*ratio, 90*ratio)];
//    self.logoImage.image = [UIImage imageNamed:@"Imported Layers Copy"];
//    [self.view addSubview:self.logoImage];
//    self.logoImage.centerX = self.view.centerX;
//    self.logoImage.top = 100*ratio;
//    
//    UILabel * uChatText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 21*ratio)];
//    uChatText.text = @"U聊";
//    uChatText.textColor = [UIColor colorWithHexString:@"#343534"];
//    uChatText.textAlignment = NSTextAlignmentCenter;
//    uChatText.font = [UIFont boldSystemFontOfSize:20];
//    uChatText.top = self.logoImage.bottom + 18*ratio;
//    [self.view addSubview:uChatText];
//    
//    UIImageView * textImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Text_copy"]];
//    textImage.contentMode = UIViewContentModeScaleAspectFit;
//    textImage.centerX = self.view.centerX;
//    textImage.bottom = self.view.height - 20*3*ratio;
//    [self.view addSubview:textImage];
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end
