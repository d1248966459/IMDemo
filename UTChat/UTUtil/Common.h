//
//  Common.h
//  UTChat
//
//  Created by dcj on 15/11/9.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import <Foundation/Foundation.h>


#define IMAGEMESSAGE_PREFIX @"#hg$ahh{"
#define IMAGEMESSAGE_SUFFIX @"}fsf#df$d"

//#define HostStr @"srv.im.dev.utouu.com"
//#define IMAGE_DOWNLOADURL @"http://srv.im.dev.utouu.com/api/cut-picture/download"
//#define IMAGE_UPLOADURL   @"http://srv.im.dev.utouu.com/api/cut-picture/upload-stream"
//#define LOGINURL @"http://srv.im.dev.utouu.com/api/login-dispatcher"
//#define USERINFOURL @"http://srv.im.dev.utouu.com/page/user/{userid}?mobile=true"
//#define GROUPINFOURL @"http://srv.im.dev.utouu.com/page/group/{groupid}?mobile=true&type={grouptype}"

//#define HostStr @"srv.im.test.utouu.com"
//#define IMAGE_DOWNLOADURL @"http://srv.im.test.utouu.com/api/cut-picture/download"
//#define IMAGE_UPLOADURL   @"http://srv.im.test.utouu.com/api/cut-picture/upload-stream"
//#define LOGINURL @"http://srv.im.dev.test.utouu.com/api/login-dispatcher"
//#define USERINFOURL @"http://srv.im.test.utouu.com/page/user/{userid}?mobile=true"
//#define GROUPINFOURL @"http://srv.im.test.utouu.com/page/group/{groupid}?mobile=true&type={grouptype}"

#define HostStr @"srv.im.utouu.com"
#define IMAGE_DOWNLOADURL @"http://srv.im.utouu.com/api/cut-picture/download"
#define IMAGE_UPLOADURL   @"http://srv.im.utouu.com/api/cut-picture/upload-stream"
#define LOGINURL @"http://srv.im.utouu.com/api/login-dispatcher"
#define USERINFOURL @"http://srv.im.utouu.com/page/user/{userid}?mobile=true"
#define GROUPINFOURL @"http://srv.im.utouu.com/page/group/{groupid}?mobile=true&type={grouptype}"


#define COLOR_01 [UIColor fromHexValue:0xE5E5E5] // 白色
#define COLOR_02 [UIColor fromHexValue:0x333333] // 黑色
#define COLOR_03 [UIColor fromHexValue:0x666666] // 灰色
#define COLOR_06 [UIColor fromHexValue:0xE4E4E4] // 浅灰
#define COLOR_04 [UIColor fromHexValue:0x990033] // 紫红色
#define COLOR_05 [UIColor fromHexValue:0xFF3366] // 浅红色
#define COLOR_07 [UIColor fromHexValue:0x009966] // 绿色
#define COLOR_08 [UIColor fromHexValue:0x999999] // 中灰
#define COLOR_09 [UIColor fromHexValue:0xcccccc]

#define COLOR_10 [UIColor fromHexValue:0xFF9800];
#define COLOR_11 [UIColor fromHexValue:0x9833FF];
#define COLOR_12 [UIColor fromHexValue:0x66CBCB];
#define COLOR_13 [UIColor fromHexValue:0xCC0099];

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

#define AUTOSIZE UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth


#define KEY_USERNAME_PASSWORD @"com.company.app.usernamepassword"
#define KEY_USERNAME @"com.company.app.username"
#define KEY_PASSWORD @"com.company.app.password"

#define NOTIFICATION_NETWORKSTATUS @"networkStatus"
#define NOTIFICATION_REFRESHCHATLIST @"refreshChatListViewCtr"
#define NOTIFICATION_REFRESHCONTACTS @"refreshContactsViewCtr"



@interface Common : NSObject

+(NSString *)URLEncodedString:(NSString*)str;
+(NSString *)longToDateString:(NSString *)longString;
+(void)SetSubViewExternNone:(UIViewController *)viewController;
+(void)AlertViewTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)canceltitle otherButtonTitles:(NSString*)othertitle;
+(void)saveUserImage:(NSString*)strlogo;
+ (void)setTabbarItem:(UIViewController *)viewCtr title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName index:(NSInteger)index;


+ (UITabBarItem *)instantiatesTabbarItemWithTitle:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName index:(NSInteger)index;


//is image message
+ (BOOL)isImageMessage:(NSString *)content;
//creat image path
+ (NSString *)creatImagePath;
//scale image to given size
+ (UIImage *)scaleToSize:(UIImage *)image Size:(CGSize)size;
//get gray image
//+ (UIImage *)getGrayImage:(UIImage *)sourceImage;

+ (UIImage *)getGroupHeadImageByType:(NSString *)type;

+ (UIImage *)getGrayImage:(UIImage *)sourceImage;
+ (void)showAlertViewWith:(NSString *)title message:(NSString *)message;

+ (NSString*)md5HexDigest:(NSString*)str;

+ (NSString *)createUDID;//uuid

+(void)LoginController;

//+(NSString *)urlEncode:(NSString *)unencodeString;//图片string转换成url

+ (NSString*)getAppVersion;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

+ (NSDictionary*)JsonTodictionary:(NSString *)jsonstr;

+(BOOL)checkNetWorkStatus;

+(BOOL)checkIsPhoneNo:(NSString *)phone;


@end
