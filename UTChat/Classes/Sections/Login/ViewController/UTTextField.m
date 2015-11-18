//
//  UTTextField.m
//  UTChat
//
//  Created by dcj on 15/11/10.
//  Copyright © 2015年 dcj. All rights reserved.
//

#import "UTTextField.h"

@implementation UTTextField

-(id)initWithFrame:(CGRect)frame Icon:(UIImageView*)icon;{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftView = icon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}
-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 5;// 右偏5
    return iconRect;
}


@end
