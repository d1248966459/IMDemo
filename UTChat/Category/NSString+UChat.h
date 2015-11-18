//
//  NSString+UChat.h
//  UTChat
//
//  Created by dcj on 15/11/9.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UChat)
- (NSString *)trim;

- (BOOL)isEqualToStringLgnoreCase:(NSString *)string;

- (BOOL)isEmpty;

@end
