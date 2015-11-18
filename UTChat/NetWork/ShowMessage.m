//
//  ShowMessage.m
//  MobileUU
//
//  Created by 魏鹏 on 15/6/27.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "ShowMessage.h"

@implementation ShowMessage
+(void)showMessage:(NSString*)message;{
    
#pragma mark -创建提示框
    
    [UIView animateWithDuration:2.0 delay:1.0f options:2 animations:^{
    
    } completion:^(BOOL finished) {
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UIView *showView = [[UIView alloc] init];
        showView.backgroundColor = [UIColor blackColor];
        showView.alpha = 1.0f;
        showView.layer.cornerRadius = 5.0f;
        showView.layer.masksToBounds = YES;
        [window addSubview:showView];
        
#pragma mark -文字显示
        UILabel *textLabel = [[UILabel alloc] init];
        CGSize Labelsize = [message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} context:nil].size;
        textLabel.text = message;
        textLabel.frame = CGRectMake(10, 5, Labelsize.width, Labelsize.height);
        textLabel.textColor = [UIColor whiteColor];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont boldSystemFontOfSize:12];
        [showView addSubview:textLabel];
        
#pragma mark -提示框的位置
        showView.frame = CGRectMake((SCREEN_WIDTH-Labelsize.width-20)/2, SCREEN_HEIGHT-60, Labelsize.width+20, Labelsize.height+10);
        
        //设置动画隐藏提示框
        [UIView animateWithDuration:2 animations:^{
            showView.alpha = 0;
        } completion:^(BOOL finished) {
            [showView removeFromSuperview];
        }];

        
    }];
}
+(void)showMessage:(NSString *)message withCenter:(CGPoint)center{
    
#pragma mark -创建提示框
    
    [UIView animateWithDuration:2.0 delay:1.0f options:2 animations:^{
        
    } completion:^(BOOL finished) {
        
        UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
        UIView *showView = [[UIView alloc] init];
        showView.backgroundColor = [UIColor blackColor];
        showView.alpha = 1.0f;
        showView.layer.cornerRadius = 5.0f;
        showView.layer.masksToBounds = YES;
        [window addSubview:showView];
        
#pragma mark -文字显示
        UILabel *textLabel = [[UILabel alloc] init];
        CGSize Labelsize = [message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} context:nil].size;
        textLabel.text = message;
        textLabel.frame = CGRectMake(10, 5, Labelsize.width, Labelsize.height);
        textLabel.textColor = [UIColor whiteColor];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont boldSystemFontOfSize:12];
        [showView addSubview:textLabel];
        
#pragma mark -提示框的位置
        showView.frame = CGRectMake((SCREEN_WIDTH-Labelsize.width-20)/2, SCREEN_HEIGHT-60, Labelsize.width+20, Labelsize.height+10);
        showView.center = center;
        //设置动画隐藏提示框
        [UIView animateWithDuration:2 animations:^{
            showView.alpha = 0;
        } completion:^(BOOL finished) {
            [showView removeFromSuperview];
        }];
        
        
    }];
}

@end
