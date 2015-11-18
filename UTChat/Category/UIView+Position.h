//
//  UIView+Position.h
//  MobileUU
//
//  Created by dcj on 15/7/22.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  用来修改uiview的frame以及获得frame 的某一个值
 */

@interface UIView (Position)

- (void)setTlPos:(CGPoint)tlPoint;
- (void)setBrPos:(CGPoint)tlPoint;

- (void)setPosx:(float)x;
- (void)setPosy:(float)y;
- (CGPoint)brPos;
- (CGPoint)centerPos;

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;
@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;


@end
