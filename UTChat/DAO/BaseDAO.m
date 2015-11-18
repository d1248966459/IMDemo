//
//  BaseDAO.m
//  BESTKEEP
//
//  Created by dcj on 15/9/29.
//  Copyright © 2015年 YISHANG. All rights reserved.
//

#import "BaseDAO.h"
#import "FMDB.h"
#import "BaseDAOManager.h"
#import "BaseDaoProperty.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//#import "UserInfoModel.h"

static NSSet *foundationClasses_;

typedef BOOL (^DJClassesEnumeration)(Class c, BOOL *stop);

@implementation BaseDAO

+(BOOL)createTable{
    
    BaseDAOManager * manager = [BaseDAOManager cruuentManager];
    return [manager createTableWithDao:[self class]];
}

-(BOOL)deleteTable{

    return NO;
}

-(void)searchModelWithCompeletion:(CompeletionId)commpeletion andCondition:(BaseDAOSerchCondition *)condition{
    [[BaseDAOManager cruuentManager] searchModelWihtDao:self condition:condition];

}

-(void)insertModelWithCompeletion:(CompeletionBool)compeletion{
    [[BaseDAOManager cruuentManager] insertModelWithDao:self andCompeletion:compeletion];
}
-(void)deleteModelWithCompeletion:(CompeletionBool)compeletion{
    [[BaseDAOManager cruuentManager] deleteModelWithDao:self andCompeletion:compeletion];
}



#pragma mark -- private method
-(id)valueForProperty:(BaseDaoProperty *)property{
    id value = [self valueForKey:property.columnName];
    id returnValue = value;
    if (value == nil) {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        returnValue = value;
    }else if ([value isKindOfClass:[NSNumber class]]){
        returnValue = [value stringValue];
    }else if ([value isKindOfClass:[NSValue class]]){
        NSString * columnType = property.columnType;
        if ([columnType isEqualToString:@"CGRect"]) {
            
        }
    
    }
    
    return value;
}


+(NSMutableDictionary *)getPropertyDict{
    NSMutableDictionary * resultDict = [[NSMutableDictionary alloc] init];
    [self enumerateClasses:^BOOL(__unsafe_unretained Class c, BOOL *stop) {
        unsigned int outCount, i;
        
        objc_property_t * properties = class_copyPropertyList([c class], &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property =properties[i];
            BaseDaoProperty * daoProperty = [[BaseDaoProperty alloc] initWithPorety:&property];
            if (daoProperty) {
                [resultDict setObject:daoProperty forKey:daoProperty.columnName];
            }
        }
        free(properties);
        return NO;

    }];

    return resultDict;
}

+(NSMutableArray *)getPropertyArray{
    NSMutableArray * propertyarr = [[NSMutableArray alloc] init];
    
    [self enumerateClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        unsigned int outCount, i;
        
        objc_property_t * properties = class_copyPropertyList([c class], &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property =properties[i];
            BaseDaoProperty * daoProperty = [[BaseDaoProperty alloc] initWithPorety:&property];
            if (daoProperty) {
                [propertyarr addObject:daoProperty];
            }
        }
        free(properties);
        return NO;
    }];
    
    
    return propertyarr;
}
+(BOOL)enumerateClasses:(DJClassesEnumeration)enumeration{
    if (enumeration == nil) return NO;
    BOOL stop = NO;
    
//    NSString * str = @"";
    Class c = [self class];
    while (c && !stop) {
        BOOL exit = enumeration(c, &stop);
        if (exit) {
            return YES;
        }
        c = class_getSuperclass(c);
        if ([self isClassFromFoundation:c]) {
            stop = YES;
            break;
        };
    }
    return NO;
}

+ (NSSet *)foundationClasses
{
    if (foundationClasses_ == nil) {
        foundationClasses_ = [NSSet setWithObjects:
                              [NSURL class],
                              [NSDate class],
                              [NSValue class],
                              [NSData class],
                              [NSError class],
                              [NSArray class],
                              [NSDictionary class],
                              [NSString class],
                              [NSAttributedString class],
                              [NSObject class],nil];
    }
    return foundationClasses_;
}

+ (BOOL)isClassFromFoundation:(Class)c
{
    if (c == [NSObject class] || c == [NSManagedObject class]) return YES;
    
    __block BOOL result = NO;
    [[self foundationClasses] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if (c == foundationClass || [c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

+(NSString *)tableName{
return @"BaseDao";
}

- (void)modelWithProperty:(BaseDaoProperty*)property value:(id)value
{
    ///参试获取属性的Class
    Class columnClass = NSClassFromString(property.propertyType);
    
    id modelValue = nil;
    NSString* columnType = property.columnType;
    if(columnClass == nil)
    {
        ///当找不到 class 时，就是 基础类型 int,float CGRect 之类的
        if([columnType isEqualToString:DB_Type_Double])
        {
            double number = [value doubleValue];
            modelValue = [NSNumber numberWithDouble:number];
        }
        else if([columnType isEqualToString:DB_Type_Int])
        {
            if([property.propertyType isEqualToString:@"long"])
            {
                long long number = [value longLongValue];
                modelValue = [NSNumber numberWithLongLong:number];
            }
            else
            {
                NSInteger number = [value integerValue];
                modelValue = [NSNumber numberWithInteger:number];
            }
        }
        else if([columnType isEqualToString:@"CGRect"])
        {
            CGRect rect = CGRectFromString(value);
            modelValue = [NSValue valueWithCGRect:rect];
        }
        else if([columnType isEqualToString:@"CGPoint"])
        {
            CGPoint point = CGPointFromString(value);
            modelValue = [NSValue valueWithCGPoint:point];
        }
        else if([columnType isEqualToString:@"CGSize"])
        {
            CGSize size = CGSizeFromString(value);
            modelValue = [NSValue valueWithCGSize:size];
        }
        else if([columnType isEqualToString:@"_NSRange"])
        {
            NSRange range = NSRangeFromString(value);
            modelValue = [NSValue valueWithRange:range];
        }
        
        ///如果都没有值 默认给个0
        if(modelValue == nil)
        {
            modelValue = [NSNumber numberWithInt:0];
        }
    }
    else if([columnType isEqualToString:DB_Type_Blob])
    {
        if([columnClass isSubclassOfClass:[NSObject class]])
        {
            modelValue = [NSKeyedUnarchiver unarchiveObjectWithData:value];
        }
    }
    else if([value length] == 0)
    {
        //为了不继续遍历
    }
    else if([columnClass isSubclassOfClass:[NSString class]])
    {
        modelValue = value;
    }
    else if([columnClass isSubclassOfClass:[NSNumber class]])
    {
        modelValue = [NSNumber numberWithDouble:[value doubleValue]];
    }
    else if([columnClass isSubclassOfClass:[UIImage class]])
    {
        //TODO 存在本地，存本地文件url，防止数据库过大
        modelValue = [UIImage imageWithContentsOfFile:value];
    }
    else
    {
        if([columnClass isKindOfClass:[NSArray class]])
        {
            //            modelValue = [value objectFromJSONString];
        }
        else if([columnClass isKindOfClass:[NSDictionary class]])
        {
            //            modelValue = [value objectFromJSONString];
        }
    }
    
    [self setValue:modelValue forKey:property.columnName];
}



@end
