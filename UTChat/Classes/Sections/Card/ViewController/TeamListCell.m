//
//  TeamListCell.m
//  MobileUU
//
//  Created by dcj on 15/10/29.
//  Copyright © 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "TeamListCell.h"
#import "UIView+Position.h"
@implementation TeamListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.imageView setFrame:CGRectMake(20, 0,40, 40)];
    self.imageView.centerY = self.contentView.centerY;
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}


@end
