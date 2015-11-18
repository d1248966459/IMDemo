//
//  BaseDAO.h
//  BESTKEEP
//
//  Created by dcj on 15/9/29.
//  Copyright © 2015年 YISHANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseDaoProperty;
@class BaseDAOSerchCondition;
@class BaseDAOCondition;

/**
 *  返回成功与否的block
 *
 *  @param result 成功与否的结果
 */
typedef void(^CompeletionBool)(BOOL result);
/**
 *  返回一个id类型的result
 *
 *  @param result 查询结果 等
 *  @param error  是否错误
 */
typedef void(^CompeletionId)(id result);

/**
 *  非空
 */
@protocol DataBaseIsNotNull <NSObject>
@end
/**
 *  主键
 */
@protocol DatabaseIsPrimary <NSObject>
@end
/**
 *  无效
 */
@protocol DataBaseIsIgnore <NSObject>
@end
/**
 *  唯一
 */
@protocol DataBaseIsUnique <NSObject>
@end
/**
 *  添加
 */
@protocol DataBaseIsAddition <NSObject>
@end
/**
 *  移除
 */
@protocol DataBaseIsRemove <NSObject>
@end


@interface BaseDAO : NSObject

@property (nonatomic,assign) NSInteger rowID;



+(BOOL)createTable;

-(BOOL)deleteTable;

-(void)insertModelWithCompeletion:(CompeletionBool)compeletion;

-(void)searchModelWithCompeletion:(CompeletionId)commpeletion andCondition:(BaseDAOSerchCondition *)condition;

-(void)deleteModelWithCompeletion:(CompeletionBool)compeletion;


/**
 *  表名 子类需实现
 *
 *  @return 表名
 */
+(NSString *)tableName;

+(NSMutableArray *)getPropertyArray;
+(NSMutableDictionary *)getPropertyDict;



-(id)valueForProperty:(BaseDaoProperty *)property;
- (void)modelWithProperty:(BaseDaoProperty*)property value:(id)value;




@end
