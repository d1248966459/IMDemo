//
//  UpdateManager.m
//  UChat
//
//  Created by dcj on 15/11/13.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "UpdateManager.h"
#import "Result.h"
@implementation UpdateManager

+(instancetype)shareInstance{
    static UpdateManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UpdateManager alloc] init];
    });

    return manager;
}

-(void)checkVersion{

    
    NSString *app_Version = [Common getAppVersion];
    NSDictionary *param_dic = [NSDictionary dictionaryWithObjectsAndKeys:app_Version,@"version", nil];
    
    [PassportService checkOutVersionnext:param_dic :^(id obj,NSError* error) {
        
        Result * version_result  = [[Result alloc]init];
        
        version_result = (Result *)obj;
        
        if (version_result.success) {
            
            NSMutableDictionary *result_dic = (NSMutableDictionary *)version_result.data;
            
            NSString *isupdate = [[result_dic objectForKey:@"upgrade"] stringValue];
            [ManagerSetting setversionUrl:[result_dic objectForKey:@"url"]];
            if ([isupdate isEqualToString:@"1"]) {
                BOOL isforce = [[result_dic objectForKey:@"force"] boolValue];
                NSString *message = [result_dic objectForKey:@"upgrade_msg"];
                if (isforce) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    
                    alertView.delegate = self;
                    alertView.tag = 100;
                    [alertView show];
                }
                else{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    
                    alertView.tag = 200;
                    alertView.delegate = self;
                    [alertView show];
                }
            }else{
                [Common AlertViewTitle:@"提示" message:@"您当前已经是最新版本了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            }
            
        }
        
    }];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 100) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[ManagerSetting getversionUrl]]];
        
        exit(0);
    }else if(alertView.tag == 200){
        
        switch (buttonIndex) {
            case 0:
                //   [[NSNotificationCenter defaultCenter]removeObserver:self];
                return;
                break;
            case 1:{
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[ManagerSetting getversionUrl]]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[ManagerSetting getversionUrl]]];
                    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
                    exit(0);
                }
                break;
            default:
                break;
            }
        }
    }
}
-(NSString *)cruuentVersion{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    NSString *version = [NSString stringWithFormat:@"%@.%@",[infoDict objectForKey:@"CFBundleShortVersionString"],versionNum];
    return version;
}

@end
