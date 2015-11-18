//
//  NTESUserUtil.h
//  NIM
//
//  Created by chris on 15/9/17.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMKit.h"


@interface NTESUserUtil : NSObject

+ (BOOL)isMyFriend:(NSString *)userId;

+ (NSString *)genderString:(NIMUserGender)gender;

@end
