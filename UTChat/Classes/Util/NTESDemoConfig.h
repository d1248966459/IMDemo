//
//  NTESDemoConfig.h
//  NIM
//
//  Created by amao on 4/21/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTESDemoConfig : NSObject
+ (instancetype)sharedConfig;

- (NSString *)appKey;
- (NSString *)apiURL;//此处为网易云信Demo应用服务器地址，更换appkey后，请更新为应用自己的服务器接口地址，并提供相关接口服务。
- (NSString *)cerName;

@end
