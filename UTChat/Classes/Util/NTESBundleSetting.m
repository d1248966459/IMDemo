//
//  NTESBundleSetting.m
//  NIM
//
//  Created by chris on 15/7/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESBundleSetting.h"

@implementation NTESBundleSetting

+ (instancetype)sharedConfig
{
    static NTESBundleSetting *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESBundleSetting alloc] init];
    });
    return instance;
}


- (BOOL)removeSessionWheDeleteMessages{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled_remove_recent_session"] boolValue];
}

- (BOOL)localSearchOrderByTimeDesc{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"local_search_time_order_desc"] boolValue];
}


- (BOOL)autoRemoveRemoteSession{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"auto_remove_remote_session"] boolValue];
}

- (BOOL)autoRemoveSnapMessage{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"auto_remove_snap_message"] boolValue];
}

- (BOOL)needVerifyForFriend
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"add_friend_need_verify"] boolValue];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"\nenabled_remove_recent_session %d\nlocal_search_time_order_desc %d\n\
auto_remove_remote_session %d\nauto_remove_snap_message %d\nadd_friend_need_verify %d\n",
                                        [self removeSessionWheDeleteMessages],
                                        [self localSearchOrderByTimeDesc],
                                        [self autoRemoveRemoteSession],
                                        [self autoRemoveSnapMessage],
                                        [self needVerifyForFriend]];
}
@end
