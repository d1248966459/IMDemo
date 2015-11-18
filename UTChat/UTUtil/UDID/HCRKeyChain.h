//
//  HCRKeyChain.h
//  keyChain
//
//  Created by hanyazhou on 14-5-25.
//  Copyright (c) 2014年 胡趁蕊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface HCRKeyChain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
