//
//  UIColor+UChat.h
//  UTChat
//
//  Created by dcj on 15/11/9.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UChat)

+ (UIColor *)fromHexValue:(NSUInteger)hex;
+ (UIColor *)fromHexValue:(NSUInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)fromShortHexValue:(NSUInteger)hex;
+ (UIColor *)fromShortHexValue:(NSUInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert ;


@end
