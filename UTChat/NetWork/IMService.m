//
//  IMService.m
//  
//
//  Created by 魏鹏 on 15/10/29.
//
//

#import "IMService.h"


@implementation IMService
+(void)checkGroupnumisJoin:(UIView*)view groupnum:(NSString*)num callback:(CompletionCallback)callback
{
    NSString *strURL = [[strIMAPI stringByAppendingString:str_check_join_group] stringByAppendingString:num];
    [RequestFromServer requestWithURL:strURL type:@"POST" requsetHeadDictionary:nil requestBodyDictionary:nil showHUDView:view showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject)
        {
            callback(responseObject,nil);
        }
        else
        {
            [ShowMessage showMessage:@"请求数据出错"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //callback(nil,error);
    }];
}
+(void)getUserIMAccount:(UIView*)view nickname:(NSString*)nickname callback:(CompletionCallback)callback
{
    NSString *str = [strIMAPI stringByAppendingString:str_serach_im_account]; //stringByAppendingString:nickname];//%E5%B0%8F%E7%B3%96%E5%9D%97
    NSDictionary *body_dic = [NSDictionary dictionaryWithObjectsAndKeys:nickname, @"nickname",nil];
    NSDictionary *head_dic = [AppControlManager getSTHeadDictionary:body_dic];
    

    
    NSString *strURL = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [RequestFromServer requestWithURL:str type:@"POST" requsetHeadDictionary:head_dic requestBodyDictionary:body_dic showHUDView:view showErrorAlertView:YES success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject)
        {
            callback(responseObject,nil);
        }
        else
        {
            [ShowMessage showMessage:@"请求数据出错"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil,error);
    }];
 
}
@end
