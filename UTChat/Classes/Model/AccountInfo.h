//
//  AccountInfo.h
//  UTChat
//
//  Created by dcj on 15/11/10.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "BaseObject.h"

@interface AccountInfo : BaseObject

@property (nonatomic,copy) NSString * account;
@property (nonatomic,copy) NSString * passWord;
@property (nonatomic,copy) NSString * anHao;
@property (nonatomic,copy) NSString * verfiyCode;

@property (nonatomic,copy) NSString * oldPassword;
@property (nonatomic,copy) NSString * willChagePassword;
@property (nonatomic,copy) NSString * smsVerfiyCode;
@property (nonatomic,copy) NSString * idenKey;

@end
