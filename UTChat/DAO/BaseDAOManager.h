//
//  BaseDAOManager.h
//  BESTKEEP
//
//  Created by dcj on 15/9/29.
//  Copyright © 2015年 YISHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "BaseDAO.h"
#import "BaseDAOCondition.h"


@interface BaseDAOManager : NSObject


+(instancetype)cruuentManager;

-(void)openDataBase;

-(void)closeDataBase;

-(void)releaseManager;

-(BOOL)createTableWithDao:(Class)dao;

-(BOOL)insertModelWithDao:(BaseDAO *)dao;

-(void)insertModelWithDao:(BaseDAO *)dao andCompeletion:(CompeletionBool) compeletion;

-(id)searchModelWihtDao:(BaseDAO *)dao condition:(BaseDAOSerchCondition *)condition;

-(void)searchModelWithDao:(BaseDAO *)dao condition:(BaseDAOSerchCondition *)condition andCompeletion:(CompeletionId)compeletion;

-(BOOL)deleteModelWithDao:(BaseDAO *)dao;

-(void)deleteModelWithDao:(BaseDAO *)dao andCompeletion:(CompeletionBool)compeletion;

-(BOOL)updateModelWithDao:(BaseDAO *)dao;

-(void)updateModelWithDao:(BaseDAO *)dao andCompeletion:(CompeletionBool)compeletion;

@end
