//
//  MD5.h
//  UTOUU
//
//  Created by 魏鹏 on 15/5/12.
//  Copyright (c) 2015年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5 : NSObject
+(NSString*)md5:(NSDictionary*)dicParamer time:(NSString*)time;
+(NSString*)getSystemTime;
@end
//@interface KVPO : NSObject
//@property(nonatomic,copy) NSString *key;
//@property(nonatomic,copy) NSString *value;
//-(void)setKey:(NSString*)key1;
//-(NSString*)getKey;
//-(void)setValue:(NSString*)value1;
//-(NSString*)getValue;
//
//-(void)KVPO:(NSString*)strkey value:(NSString*)strvalue;
//@end
//@implementation KVPO
//@synthesize key;
//@synthesize value;
//-(void)setKey:(NSString*)key1;{
//    key = key1;
//}
//-(NSString*)getKey;{
//    return key;
//}
//-(void)setValue:(NSString*)value1;{
//    value = value1;
//}
//-(NSString*)getValue;{
//    return value;
//}
//-(void)KVPO:(NSString*)strkey value:(NSString*)strvalue;{
//    key = strkey;
//    value = strvalue;
//}
//@end