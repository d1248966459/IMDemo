//
//  ContactPickedView.h
//  NIM
//
//  Created by ios on 10/23/13.
//  Copyright (c) 2013 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESContactDefines.h"

@protocol NTESContactPickedViewDelegate <NSObject>

- (void)removeUser:(NSString *)userId;

@end

@interface NTESContactPickedView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<NTESContactPickedViewDelegate> delegate;

- (void)removeUser:(NSString *)userId;
- (void)addUser:(id<NTESContactItem>)usr;
@end
