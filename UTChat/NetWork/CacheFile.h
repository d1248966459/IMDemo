//
//  CacheFile.h
//  MobileUU
//
//  Created by 王義傑 on 14-5-31.
//  Copyright (c) 2014年 Shanghai Pecker Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CacheFile : NSObject

@property (nonatomic ,assign) int updatetime;

+(void) WriteToFile;




+(void)loadLocalUserFile;





@end
