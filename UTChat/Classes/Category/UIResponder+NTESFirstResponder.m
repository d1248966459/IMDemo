//
//  UIResponder+NTESFirstResponder.m
//  NIM
//
//  Created by chris on 15/9/26.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "UIResponder+NTESFirstResponder.h"
static __weak id currentFirstResponder;

@implementation UIResponder (NTESFirstResponder)

+ (instancetype)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}
- (void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}

@end
