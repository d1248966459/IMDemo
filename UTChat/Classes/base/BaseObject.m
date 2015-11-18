//
//  BaseObject.m
//  BESTKEEP
//
//  Created by dcj on 15/8/27.
//  Copyright (c) 2015年 YISHANG. All rights reserved.
//

#import "BaseObject.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#ifdef DEBUG
#define D_Log(...) NSLog(__VA_ARGS__)
#else
#define D_Log(...)
#endif

@interface BaseObject ()

@property (nonatomic,strong) NSMutableDictionary * unKonwnDict;
@property (nonatomic,weak) BaseObject <SetUknownValueKey> *child;

@end




@implementation BaseObject

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    self.child = self;
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        obj =[self getNewValueWithNoStringValue:obj key:key];
        if ([obj isKindOfClass:[NSString class]]) {
            [self setValue:obj forKey:key];
        }else{
            [self setValue:obj forUndefinedKey:key];
        }
    }];
    if ([self.child respondsToSelector:@selector(setUnKonwnValueKeyWithDict:)]) {
        [self.child setUnKonwnValueKeyWithDict:self.unKonwnDict];
    }
    return self;
}

-(void)objectForKeyValue:(NSDictionary *)dict{
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        obj =[self getNewValueWithNoStringValue:obj key:key];
        if ([obj isKindOfClass:[NSString class]]) {
            [self setValue:obj forKey:key];
        }else{
            [self setValue:obj forUndefinedKey:key];
        }
    }];
    if ([self.child respondsToSelector:@selector(setUnKonwnValueKeyWithDict:)]) {
        [self.child setUnKonwnValueKeyWithDict:self.unKonwnDict];
    }

}


-(void)setValue:(id)value forKey:(NSString *)key{
    
    if ([self checkIsExistPropertyWithSender:self verifyPropertyName:key]) {
        [super setValue:value forKey:key];
    }else{
        D_Log(@"%@属性不存在\n value: %@",key,value);
        [self.unKonwnDict setObject:value forKey:key];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    [self.unKonwnDict setValue:value forKey:key];
    
}

-(NSMutableDictionary *)unKonwnDict{
    if (_unKonwnDict == nil) {
        _unKonwnDict = [[NSMutableDictionary alloc] init];
    }
    return _unKonwnDict;
}


@end


@implementation BaseObject (ParseValue)

-(id)getNewValueWithNoStringValue:(id)value key:(NSString *)key{
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }else{
        if ([self canTransformToStringWithValue:value key:key]) {
            value = [value stringValue];
        }else{
            return value;
        }
    }
    return value;
}

-(BOOL)canTransformToStringWithValue:(id)value key:(NSString *)key{
    NSString * className = [NSString stringWithUTF8String:object_getClassName(value)];
    if ([className isEqualToString:@"__NSCFBoolean"]) {}
    else if ([className isEqualToString:@"NSDecimalNumber"]){}
    else if ([className isEqualToString:@"__NSCFNumber"]){}
    else {
        D_Log(@"key:%@ \n无法转换为string\n value:%@",key,value);
        return NO;
    }
    return YES;
}

@end

typedef BOOL (^DJClassesEnumeration)(Class c, BOOL *stop);

static NSSet *foundationClasses_;


@implementation BaseObject (CheckIsExistProperty)

- (BOOL)checkIsExistPropertyWithSender:(BaseObject *)sender verifyPropertyName:(NSString *)verifyPropertyName
{
    BOOL exict = [sender enumerateClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        unsigned int outCount, i;
        
        objc_property_t * properties = class_copyPropertyList([c class], &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property =properties[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            if ([propertyName isEqualToString:verifyPropertyName]) {
                free(properties);
                return YES;
            }
        }
        free(properties);
        return NO;
    }];

    return exict;
}

-(BOOL)enumerateClasses:(DJClassesEnumeration)enumeration{
    if (enumeration == nil) return NO;
    BOOL stop = NO;
    Class c = [self class];
    while (c && !stop) {
       BOOL exit = enumeration(c, &stop);
        if (exit) {
            return YES;
        }
        c = class_getSuperclass(c);
        if ([self isClassFromFoundation:c]) {
            break;
        };
    }
    return NO;
}

- (NSSet *)foundationClasses
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
                              [NSAttributedString class], nil];
    }
    return foundationClasses_;
}

- (BOOL)isClassFromFoundation:(Class)c
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

@end

@implementation BaseObject (PropertyDcitionary)

-(NSDictionary *)getPropertyDictionary{
    NSMutableDictionary * propertyDcit = [[NSMutableDictionary alloc] init];
    unsigned int outCount;
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString * propertyName = [NSString stringWithUTF8String:property_getName(property)];
        id value = [self valueForKey:propertyName];
        [propertyDcit setObject:value forKey:propertyName];
    }
    return propertyDcit;
}

@end

