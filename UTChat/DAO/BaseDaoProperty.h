//
//  BaseDaoProperty.h
//  BESTKEEP
//
//  Created by dcj on 15/10/8.
//  Copyright © 2015年 YISHANG. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

extern NSString* const DB_Type_Text;
extern NSString* const DB_Type_Int;
extern NSString* const DB_Type_Double;
extern NSString* const DB_Type_Blob;


typedef NS_ENUM(NSUInteger, DBColumaStatu) {
    DBColumaStatuAddition,
    DBColumaStatuRemove,
    DBColumaStatuNormal,
};

@interface BaseDaoProperty : NSObject
@property (nonatomic,copy) NSString * propertyType;
@property (nonatomic,copy) NSString * columnName;
@property (nonatomic,copy) NSString * columnType;

/**
 *  是否是主键字段
 */
@property (nonatomic, readonly) BOOL isPrimary;
/**
 *  是否无效字段
 */
@property (nonatomic, readonly) BOOL isIgnore;
/**
 *  是否唯一性字段
 */
@property (nonatomic, readonly) BOOL isUnique;
/**
 *  是否非空字段
 */
@property (nonatomic, readonly) BOOL isNotNull;
/**
 *  字段状态
 */
@property (nonatomic,assign) DBColumaStatu columnStatus;

//@property (nonatomic,strong) <#ClassName#> * <#class#>;



-(instancetype)initWithPorety:(objc_property_t *)property;

@end
