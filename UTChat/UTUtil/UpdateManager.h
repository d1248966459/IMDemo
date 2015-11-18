//
//  UpdateManager.h
//  UChat
//
//  Created by dcj on 15/11/13.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateManager : NSObject

+(instancetype)shareInstance;

-(void)checkVersion;

-(NSString *)cruuentVersion;

@end
