//
//  KVPO.h
//  UTOUU
//
//  Created by 魏鹏 on 15/5/12.
//  Copyright (c) 2015年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVPO : NSObject
//@property(nonatomic,copy) NSString *key;
//@property(nonatomic,copy) NSString *value;
+(void)setKey:(NSString*)key1;
+(NSString*)getKey;
+(void)setValue:(NSString*)value1;
+(NSString*)getValue;
//+(void)KVPO:(NSString*)strkey value:(NSString*)strvalue;
@end
