//
//  NTESMutiClientsCell.m
//  NIM
//
//  Created by chris on 15/7/22.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESMutiClientsCell.h"
#import "NTESClientUtil.h"
#import "UIView+NTES.h"
#import "NTESGlobalMacro.h"

@implementation NTESMutiClientsCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.textLabel.font = [UIFont systemFontOfSize:17.f];
    self.textLabel.textColor = UIColorFromRGB(0x333333);
}

- (void)refreshWidthCilent:(NIMLoginClient *)client{
    self.textLabel.text = [self nameWithClient:client];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect hitRect = self.kickBtn.frame;
    return CGRectContainsPoint(hitRect, point) ? self : nil;
}

- (NSString *)nameWithClient:(NIMLoginClient *)client{
    NSString *name = [NTESClientUtil clientName:client.type];
    return name.length? [NSString stringWithFormat:@"正在使用有糖%@版",name] : @"正在使用有糖未知版本";
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.textLabel sizeToFit];
    self.textLabel.centerY = self.height * .5f;
}
@end
