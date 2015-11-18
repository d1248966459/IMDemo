//
//  NTESJanKenPonAttachment.m
//  NIM
//
//  Created by amao on 7/2/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESJanKenPonAttachment.h"
#import "NTESSessionUtil.h"

@implementation NTESJanKenPonAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{CMType : @(CustomMessageTypeJanKenPon),
                           CMData : @{CMValue:@(self.value)}};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return content;
}


- (NSString *)cellContent:(NIMMessage *)message{
    return @"NTESSessionJankenponContentView";
}

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width{
    if (!self.showCoverImage)
    {
        UIImage *image;
        switch (self.value) {
            case CustomJanKenPonValueJan:
                image    = [UIImage imageNamed:@"custom_msg_jan"];
                break;
            case CustomJanKenPonValueKen:
                image    = [UIImage imageNamed:@"custom_msg_ken"];
                break;
            case CustomJanKenPonValuePon:
                image    = [UIImage imageNamed:@"custom_msg_pon"];
                break;
            default:
                break;
        }
        self.showCoverImage = image;
    }
    return self.showCoverImage.size;
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
{
    CGFloat bubblePaddingForImage    = 3.f;
    CGFloat bubbleArrowWidthForImage = 5.f;
    if ([NTESSessionUtil messageIsFromMe:message]) {
        return  UIEdgeInsetsMake(bubblePaddingForImage,bubblePaddingForImage,bubblePaddingForImage,bubblePaddingForImage + bubbleArrowWidthForImage);
    }else{
        return  UIEdgeInsetsMake(bubblePaddingForImage,bubblePaddingForImage + bubbleArrowWidthForImage, bubblePaddingForImage,bubblePaddingForImage);
    }
}


@end
