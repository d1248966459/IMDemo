//
//  KVPO.m
//  UTOUU
//
//  Created by 魏鹏 on 15/5/12.
//  Copyright (c) 2015年 utouu. All rights reserved.
//

#import "KVPO.h"
//NSString *key;
//NSString *value;
@implementation KVPO
NSString *key;
NSString *value;

+(void)setKey:(NSString*)key1;{
    key = key1;
}
+(NSString*)getKey;{
    return key;
}
+(void)setValue:(NSString*)value1;{
    value = value1;
}
+(NSString*)getValue;{
    return value;
}
//-(void)KVPO:(NSString*)strkey value:(NSString*)strvalue;{
//    key = strkey;
//    value = strvalue;
//}

@end
