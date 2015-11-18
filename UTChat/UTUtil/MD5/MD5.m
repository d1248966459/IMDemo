//
//  MD5.m
//  UTOUU
//
//  Created by 魏鹏 on 15/5/12.
//  Copyright (c) 2015年 utouu. All rights reserved.
//

#import "MD5.h"
#import "KVPO.h"
#import <stdio.h>
#import "Common.h"

@implementation MD5

+(NSString*)md5:(NSDictionary*)dicParamer time:(NSString *)time{
    NSString *sign;
    sign = [self generateCommonSign:time Paramer:dicParamer ];
    return sign;
}
//返回签名
+(NSString*)generateCommonSign:(NSString*)time Paramer:(NSDictionary*)paramer{
    NSString *md5Sign = [self getMd5SignFromMap:paramer];
    [self getDynamicValues:time md5Sign:md5Sign];
    if ([KVPO getKey].length <=7 && [KVPO getValue].length <=7) {
        return [Common md5HexDigest:[[KVPO getKey] stringByAppendingString:[KVPO getValue]]];
    }
    return NULL;
}
+(NSString*)getMd5SignFromMap:(NSDictionary*)dicParamer{
    NSArray *keyArray = [dicParamer allKeys];
    //key值按升序排列
    NSArray *sortedArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    NSString *md5Sign = @"";
    for (int i = 0; i<[sortedArray count]; i++) {
        NSString *key = [sortedArray objectAtIndex:i];
        NSString *value = [dicParamer objectForKey:key];
        if (![key isEqualToString:@""]&&![key isEqualToString:@"sign"]&&![key isEqualToString:@"time"]) {
            md5Sign = [md5Sign stringByAppendingString:value];
        }
    }
    return md5Sign;
}
//获取动态字典
+(KVPO*) getDynamicValues:(NSString*)time md5Sign:(NSString*)md5Sign{
    NSInteger dyNamicIndex = [self getDynamicIndex:[self timeFormat:time] timeStamp:time];
    NSString *str = [NSString stringWithFormat:@"%@%@",md5Sign,time];
    md5Sign = [Common md5HexDigest:str];
    NSString *stringValue = [md5Sign substringFromIndex:dyNamicIndex];
    NSString *md5Time = [Common md5HexDigest:time];
    NSString *stringKey = [md5Time substringFromIndex:dyNamicIndex];
    KVPO *kv = [KVPO new];
    //[kv KVPO:stringKey value:stringValue];
    [KVPO setValue:stringValue];
    [KVPO setKey:stringKey];
    return kv;
}
//获取索引值
+(NSInteger)getDynamicIndex:(NSString*)time timeStamp:(NSString*)timestamp{
    NSInteger index;
    NSInteger week;
    //获取当前星期
    week = (double)[self getWeekOfDate] ;
   
    long long d = [timestamp doubleValue];
      index = d%week;
    if (index == 0) {
        index =7;
    }
    [self getSystemTime];
    index =(32-index);
    return index;
}
+(NSInteger)getWeekOfDate{
    NSInteger week;
    int weekOfDays[7] = {7,1,2,3,4,5,6};
     NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
     NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:dat];
    week = [theComponents weekday]-1;
    if (week<0) {
        week = 0;
      }

    return weekOfDays[week];
}

//获得系统时间
+(NSString*)getSystemTime{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    long long a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%lld", a];
    return timeString;
}
//系统时间格式化
+(NSString*)timeFormat:(NSString*)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:[time longLongValue]/1000.0];
    return [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
}

@end
