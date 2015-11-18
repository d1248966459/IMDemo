//
//  ShowMessage.h
//  MobileUU
//
//  Created by 魏鹏 on 15/6/27.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowMessage : NSObject

+(void)showMessage:(NSString*)message;
+(void)showMessage:(NSString *)message withCenter:(CGPoint)center;
@end
