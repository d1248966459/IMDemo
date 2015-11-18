//
//  BaseDAOCondition.h
//  DAOTest
//
//  Created by dcj on 15/10/14.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BaseDBPair : NSObject

@property (nonatomic, strong) NSArray* conditionArray;
@property (nonatomic, strong) NSDictionary* equlPair;
@property (nonatomic, strong) NSDictionary* likePair;

@end


@interface BaseDAOCondition : NSObject

@property (nonatomic, strong) BaseDBPair* andPairs;
@property (nonatomic, strong) BaseDBPair* orPairs;

- (NSString*)conditionStringAddValues:(NSMutableArray*)values;

@end


@interface BaseDAOSerchCondition : BaseDAOCondition

@property (nonatomic, strong) NSArray* columnList;
@property (nonatomic, strong) NSArray* groupByList;
@property (nonatomic, strong) NSArray* orderByList;
@property (nonatomic, assign) BOOL ascSort;

@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;

- (NSString*)cloumString;


@end