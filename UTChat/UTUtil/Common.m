//
//  Common.m
//  UTChat
//
//  Created by dcj on 15/11/9.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "Common.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CoreFoundation/CoreFoundation.h>
#import "HCRKeyChain.h"
#import "SBJson.h"
#import "Reachability.h"
@implementation Common
+(NSString *)longToDateString:(NSString *)longString{
    NSDateFormatter *dateFormatter;
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:[longString longLongValue]/1000.0];
    NSString *str = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:d]];
    return str ;
    
}

+(void)SetSubViewExternNone:(UIViewController *)viewController
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
        viewController.extendedLayoutIncludesOpaqueBars = NO;
        viewController.modalPresentationCapturesStatusBarAppearance = NO;
        viewController.navigationController.navigationBar.translucent = NO;
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
}

//保存用户头像文件
+(void)saveUserImage:(NSString*)strlogo{
    NSURL* url = [NSURL URLWithString:[strlogo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
    NSData* data = [NSData dataWithContentsOfURL:url];//获取网络图片数据
    UIImage *user_image = [UIImage imageWithData:data];
    NSData *imageData = UIImagePNGRepresentation(user_image); //PNG格式
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"userImage"];
    
}



//弹出提示框
+(void)AlertViewTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)canceltitle otherButtonTitles:(NSString*)othertitle{
    @autoreleasepool {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:delegate
                                               cancelButtonTitle:canceltitle
                                               otherButtonTitles:othertitle,nil];
        [alert show];
        
    }
}

+ (void)setTabbarItem:(UIViewController *)viewCtr title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName index:(NSInteger)index {
    UIImage *image = [UIImage imageNamed:imageName];
//    if (SysVer >= 7.0) {
        UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewCtr.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
        viewCtr.tabBarItem.tag = index;
        
//    } else {
//        viewCtr.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:index];
//    }
//    if (SysVer >= 5.0) {
        [viewCtr.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor fromHexValue:0xFF3366], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
//    }
}


+ (UITabBarItem *)instantiatesTabbarItemWithTitle:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName index:(NSInteger)index {
    UITabBarItem *tabBarItem;
    UIImage *image = [UIImage imageNamed:imageName];
//    if (SysVer >= 7.0) {
        UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
//    } else {
//        tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:index];
//    }
//    if (SysVer >= 5.0) {
        [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor fromHexValue:0xFF3366], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
//    }
    return tabBarItem;
}


+ (BOOL)isImageMessage:(NSString *)content {
    if ([content hasPrefix:IMAGEMESSAGE_PREFIX] && [content hasSuffix:IMAGEMESSAGE_SUFFIX]) {
        return YES;
    }
    return NO;
}

+ (NSString *)creatImagePath {
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc] init];
    [dateformat setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *strDate = [[dateformat stringFromDate:[NSDate date]] stringByAppendingString:[NSString stringWithFormat:@"%d", arc4random()%90000 + 10000]];
    NSString *filename = [NSString stringWithFormat:@"picture_%@.jpg", strDate];
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    ////    NSString *filepath = [NSTemporaryDirectory() stringByAppendingFormat:@"%@", filename];
    //    NSString *filepath = [[paths firstObject] stringByAppendingPathComponent:filename];
    NSString * documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString * filepath = [documents stringByAppendingPathComponent:@"Pictures"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filepath]) {
        [fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        
    }
    filepath = [filepath stringByAppendingPathComponent:filename];
    return filepath;
}

+ (UIImage *)scaleToSize:(UIImage *)image Size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

//+ (UIImage *)getGrayImage:(UIImage *)sourceImage {
//    int width = sourceImage.size.width;
//    int height = sourceImage.size.height;
//
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
//    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
//    CGColorSpaceRelease(colorSpace);
//
//    if (context == NULL) {
//        return nil;
//    }
//
//    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
//    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
//    CGContextRelease(context);
//
//    return grayImage;
//}


+ (UIImage *)getGroupHeadImageByType:(NSString *)type {
    NSString *imageName = @"groupPublicHeader.png";
    if ([type isEqualToStringLgnoreCase:@"YA"]) { // 邀请组
        imageName = @"group_ya.png";
    }
    else if ([type isEqualToStringLgnoreCase:@"TU"]) { // 推广组
        imageName = @"group_tu.png";
    }
    else if ([type isEqualToStringLgnoreCase:@"FU"]) { // 府
        imageName = @"group_fu.png";
    }
    else if ([type isEqualToStringLgnoreCase:@"BF"]) { // 百夫长
        imageName = @"group_bf.png";
    }
    return [UIImage imageNamed:imageName];
}

+ (NSString*)md5HexDigest:(NSString*)str{
    const char* cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    return ret;
}
#pragma mark - 获取UDID

+ (NSString *)createUDID{
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[HCRKeyChain load:KEY_USERNAME_PASSWORD];
    NSString *UniqueId = [usernamepasswordKVPairs objectForKey:KEY_USERNAME];
    NSString *sUDID;
    if ([UniqueId length] <= 0)
    { //写入
        UIDevice *ud = [UIDevice currentDevice];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0){
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
            NSString *uuidString = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidStr));
            CFRelease(uuidStr);
            CFRelease(uuid);
            UniqueId = uuidString;
        }
        else{
            UniqueId = [[ud identifierForVendor] UUIDString];
        }
        NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
        [usernamepasswordKVPairs setObject:UniqueId forKey:KEY_USERNAME];
        [HCRKeyChain save:KEY_USERNAME_PASSWORD data:usernamepasswordKVPairs];
        return UniqueId;
    }
    else{
        sUDID = UniqueId;
    }
    return UniqueId;
}

+(void)LoginController{
//    [Userinfo setLoginSatuts:@"0"];
//    [Userinfo setST:@"UTOUU-ST-INVALID"];
//    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
//    LoginController *loginController = [[LoginController alloc] init];
//    [Common DDMenuController:menuController UIViewController:loginController];
    
}

+ (UIImage *)getGrayImage:(UIImage *)sourceImage {
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return grayImage;
}
+ (void)showAlertViewWith:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
+ (NSString*)getAppVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [NSString stringWithFormat:@"%@.%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[infoDictionary objectForKey:@"CFBundleVersion"]];
    return app_Version;
    
}
#pragma mark -  字典转json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = nil;
    if (dic == nil) {
        return nil;
    }
    else{
        jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return str;
    }
}
#pragma mark -  json转字典
+ (NSDictionary*)JsonTodictionary:(NSString *)jsonstr;{
    
    if (jsonstr == nil) {
        return nil;
    }
    else{
        NSDictionary *dic = [jsonstr JSONValue];
        return dic;
    }
}
+(BOOL)checkNetWorkStatus;{
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable) {
        
        return YES;
    }
    else if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
        
        return YES;
    }
    else{
        return NO;
    }
    
}
+(NSString *)URLEncodedString:(NSString*)str
{
//    NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                            (CFStringRef)str,
//                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
//                                            NULL,
//                                            kCFStringEncodingUTF8);
    NSString *encoderString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    (CFStringRef)str,
                                                                                                    (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                                                    NULL,
                                                                                                    kCFStringEncodingUTF8));
    
    return encoderString;
}


+(BOOL)checkIsPhoneNo:(NSString *)phone{

    NSString *usr = phone;
    
    NSString *patternCellphone =  @"^((13[0-9])|(14[0-9])|(15[0-9])|(18[0-9]))\\d{8}$";
    
    NSRegularExpression *regexCellphone = [NSRegularExpression regularExpressionWithPattern:patternCellphone options:0 error:nil];
    
    NSTextCheckingResult *isMatchCellphone = [regexCellphone firstMatchInString:usr
                                                                        options:0
                                                                          range:NSMakeRange(0, [usr length])];
    if (!isMatchCellphone) {
        return NO;
    }
    return YES;
}

@end
