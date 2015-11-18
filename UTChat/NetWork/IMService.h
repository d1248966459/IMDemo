//
//  IMService.h
//  
//
//  Created by 魏鹏 on 15/10/29.
//
//

#import <Foundation/Foundation.h>
#import "InterfaceURLs.h"
#import "AppControlManager.h"
#import "RequestFromServer.h"

typedef void (^CompletionCallback)(id obj1,id obj2);
@interface IMService : NSObject

+(void)checkGroupnumisJoin:(UIView*)view groupnum:(NSString*)num callback:(CompletionCallback)callback;

+(void)getUserIMAccount:(UIView*)view nickname:(NSString*)nickname callback:(CompletionCallback)callback;
@end
