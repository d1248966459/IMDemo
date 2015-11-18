//
//  NTESRegisterManager.h
//  NIM
//
//  Created by amao on 8/7/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTESRegisterData : NSObject
@property (nonatomic,copy)      NSString    *account;

@property (nonatomic,copy)      NSString    *token;

@property (nonatomic,copy)      NSString    *nickname;
@end

typedef void(^NTESRegisterHandler)(NSError *error);

@interface NTESRegisterManager : NSObject
+ (instancetype)sharedManager;

- (void)registerUser:(NTESRegisterData *)data
          completion:(NTESRegisterHandler)completion;
@end
