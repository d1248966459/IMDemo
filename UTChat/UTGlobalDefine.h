//
//  UTGlobalDefine.h
//  UTChat
//
//  Created by dcj on 15/11/9.
//  Copyright © 2015年 dcj. All rights reserved.
//

#ifndef UTGlobalDefine_h
#define UTGlobalDefine_h

#ifdef DEBUG
#define D_Log(...) NSLog(__VA_ARGS__)
#else
#define D_Log(...)
#endif

#define RGB(__r, __g, __b)  [UIColor colorWithRed:(1.0*(__r)/255)\
green:(1.0*(__g)/255)\
blue:(1.0*(__b)/255)\
alpha:1.0]



#endif /* UTGlobalDefine_h */
