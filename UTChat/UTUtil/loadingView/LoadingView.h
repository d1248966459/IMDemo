//
//  LoadingView.h
//  BESTKEEP
//
//  Created by dcj on 15/10/17.
//  Copyright © 2015年 YISHANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoadingView : MBProgressHUD

+ (LoadingView *)showLoadViewToView:(UIView *)view animated:(BOOL)animated;

+ (LoadingView *)showLoadViewToView:(UIView *)view;
+ (BOOL)hideLoadViewToView:(UIView *)view;


+ (BOOL)hideLoadViewToView:(UIView *)view animated:(BOOL)animated;
+ (NSUInteger)hideAllLoadViewForView:(UIView *)view animated:(BOOL)animated;

+ (LoadingView *)loadViewForView:(UIView *)view;
+ (NSArray *)allLoadViewForView:(UIView *)view;

@end

@interface LoadingAnimationVIew : UIView

@property (nonatomic, assign) CGFloat strokeThickness;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIColor *strokeColor;

@end
