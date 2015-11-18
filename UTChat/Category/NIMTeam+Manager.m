//
//  NIMTeam+Manager.m
//  UChat
//
//  Created by dcj on 15/11/13.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "NIMTeam+Manager.h"

@implementation NIMTeam (Manager)

-(BOOL)isSystemGroup{
    NSDictionary *dic = [self.serverCustomInfo JSONValue];
    BOOL sys = [[dic objectForKey:@"sys"] boolValue];
    return sys;
}

@end
