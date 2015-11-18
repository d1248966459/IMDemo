//
//  NTESDemoConfig.m
//  NIM
//
//  Created by amao on 4/21/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESDemoConfig.h"

@interface NTESDemoConfig ()
@property (nonatomic,copy)  NSString    *appKey;
@property (nonatomic,copy)  NSString    *apiURL;
@property (nonatomic,copy)  NSString    *cerName;
@end

@implementation NTESDemoConfig
+ (instancetype)sharedConfig
{
    static NTESDemoConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESDemoConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _appKey = @"2c1c0bd1fa0d09f43e05a16f9e95c58b";
        _apiURL = @"http://srv.utouu.com/web/main";
        _cerName= @"IOSUCHATLIVE";
    }
    return self;
}

- (NSString *)appKey
{
    return _appKey;
}

- (NSString *)apiURL
{
    return _apiURL;
}

- (NSString *)cerName
{
    return _cerName;
}


@end
