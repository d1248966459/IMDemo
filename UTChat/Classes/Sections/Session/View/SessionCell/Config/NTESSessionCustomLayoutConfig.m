//
//  NTESSessionCustomConfig.m
//  NIM
//
//  Created by chris on 15/7/24.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESSessionCustomLayoutConfig.h"
#import "NTESCustomAttachmentDefines.h"
#import "NTESSessionUtil.h"

@implementation NTESSessionCustomLayoutConfig

- (CGSize)contentSize:(NIMMessageModel *)model cellWidth:(CGFloat)width{
    NIMCustomObject *object = (NIMCustomObject *)model.message.messageObject;
    id<NTESCustomAttachmentInfo> attachment = (id<NTESCustomAttachmentInfo>)object.attachment;
    if ([attachment respondsToSelector:@selector(contentSize:cellWidth:)]) {
        return [attachment contentSize:model.message cellWidth:width];
    }else{
        return CGSizeZero;
    }
}

+ (BOOL)supportMessage:(NIMMessage *)message{
    NSArray *supportType = [NTESSessionCustomLayoutConfig supportAttachmentType];
    NIMCustomObject *object = message.messageObject;
    return [supportType indexOfObject:NSStringFromClass([object.attachment class])] != NSNotFound;
}

- (NSString *)cellContent:(NIMMessageModel *)model{
    NIMMessage *message = model.message;
    NIMCustomObject *customObject = message.messageObject;
    NSString *contentClassStr     = nil;
    id<NTESCustomAttachmentInfo> attachment = (id<NTESCustomAttachmentInfo>)customObject.attachment;
    if ([attachment respondsToSelector:@selector(cellContent:)]) {
        contentClassStr = [attachment cellContent:message];
    }
    return contentClassStr;
}

- (UIEdgeInsets)contentViewInsets:(NIMMessageModel *)model
{
    NIMCustomObject *object = (NIMCustomObject *)model.message.messageObject;
    id<NTESCustomAttachmentInfo> attachment = (id<NTESCustomAttachmentInfo>)object.attachment;
    if ([attachment respondsToSelector:@selector(contentViewInsets:)]) {
        return [attachment contentViewInsets:model.message];
    }else{
        return UIEdgeInsetsZero;
    }
}


+ (NSArray *)supportAttachmentType
{
    static NSArray *types = nil;
    static dispatch_once_t onceTypeToken;
    //所对应的contentView只适用于cellClass为NTESSessionChatCell的情况，其他cellClass则需要自己实现布局
    dispatch_once(&onceTypeToken, ^{
        types =  @[
                   @"NTESJanKenPonAttachment",
                   @"NTESSnapchatAttachment",
                   @"NTESChartletAttachment",
                   @"NTESWhiteboardAttachment"
                   ];
    });
    return types;
}


- (NSString *)formatedMessage:(NIMMessageModel *)model{
    NIMCustomObject *object = (NIMCustomObject *)model.message.messageObject;
    id<NTESCustomAttachmentInfo> attachment = (id<NTESCustomAttachmentInfo>)object.attachment;
    if ([attachment respondsToSelector:@selector(formatedMessage)]) {
        return [attachment formatedMessage];
    }else{
        return @"";
    }
}



@end
