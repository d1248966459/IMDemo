//
//  Result.h
//  MobileUU
//
//  Created by 王义杰 on 15/5/13.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Result : NSObject

//成功或者失败
@property (nonatomic) BOOL success;

//失败信息
@property (nonatomic, strong) NSString *msg;

//失败码
@property (nonatomic, strong) NSString *code;

//数据包
@property (nonatomic, strong) NSObject *data;

@property (nonatomic,copy) NSString *total;

@end
