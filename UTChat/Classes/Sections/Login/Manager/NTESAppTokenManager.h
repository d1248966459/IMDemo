//
//  NTESAppTokenManager.h
//  NIM
//
//  Created by amao on 6/11/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NTESAppToken : NSObject
@property (nonatomic,copy)  NSString *accessToken;
@property (nonatomic,copy)  NSString *sdkToken;
@end

typedef void(^NTESFetchTokenBlock)(NTESAppToken *token);

@interface NTESAppTokenManager : NSObject
+ (instancetype)sharedManager;

- (NTESAppToken *)appToken;

- (void)fetchToken:(NTESFetchTokenBlock)completion;
- (void)fetchTokenBy:(NSString *)username
            password:(NSString *)password
          completion:(NTESFetchTokenBlock)completion;

- (void)cleanAppToken;

@end
