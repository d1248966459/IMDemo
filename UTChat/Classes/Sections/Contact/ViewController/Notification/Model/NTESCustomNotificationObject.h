//
//  NTESCustomNotificationObject.h
//  NIM
//
//  Created by chris on 15/5/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMSystemNotification.h"

@interface NTESCustomNotificationObject : NSObject


/**
 *  存储用的标识
 */
@property (nonatomic,assign,readwrite)       NSInteger serial;

/**
 *  时间戳
 */
@property (nonatomic,assign,readwrite)       NSTimeInterval timestamp;

/**
 *  通知发起者id
 */
@property (nonatomic,copy,readwrite)         NSString *sender;

/**
 *  通知接受者id
 */
@property (nonatomic,copy,readwrite)         NSString *receiver;

/**
 *  透传的消息体内容
 */
@property (nonatomic,copy,readwrite)         NSString    *content;


- (instancetype)initWithNotification:(NIMCustomSystemNotification *)notification;


@end
