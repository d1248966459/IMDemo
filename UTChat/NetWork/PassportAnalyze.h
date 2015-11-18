//
//  PassportAnalyze.h
//  MobileUU
//
//  Created by 魏鹏 on 15/7/1.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassportAnalyze : NSObject
typedef void (^MyCallback)(id obj);

+(id)getUserBasicInfo:(NSDictionary*)jsonstr;
+(id)getuserDetailInfo:(NSDictionary*)result_dic;
+(id)getMenuList:(NSDictionary*)result_dic;

@end
