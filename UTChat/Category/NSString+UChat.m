//
//  NSString+UChat.m
//  UTChat
//
//  Created by dcj on 15/11/9.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "NSString+UChat.h"

@implementation NSString (UChat)
- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isEqualToStringLgnoreCase:(NSString *)string {
    return [[self lowercaseString] isEqualToString:[string lowercaseString]];
}

- (BOOL)isEmpty {
    return [self length] > 0 ? NO : YES;
}

@end
