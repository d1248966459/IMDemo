//
//  LoadView.m
//  MobileUU
//
//  Created by 魏鹏 on 15/7/7.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import "LoadView.h"

@implementation LoadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        isTransform = YES;
        [self initloadingView];
        [self initloadfailView];
        [self initloadNetworkView];
        [self tagAction];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//加载失败试图
-(void)initloadfailView{
    loadfail_View = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    loadfail_View.hidden = YES;
    loadfail_View.backgroundColor = [[UIColor  whiteColor] colorWithAlphaComponent:0.3] ;
    UILabel *label = [[UILabel alloc] init];
    UIFont *iconfont =[UIFont fontWithName:@"iconfont" size:60];
    
    label.font=iconfont;
    label.text =@"\U0000e610";
    CGSize titleLabelsize = [label.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 20) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:iconfont} context:nil].size;
    label.frame = CGRectMake(SCREEN_WIDTH/2-titleLabelsize.width/2, loadfail_View.frame.size.height/2-100, SCREEN_WIDTH, titleLabelsize.height);
    
    [loadfail_View addSubview:label];
    
    textLabel = [UILabel new];
    textLabel.font = [UIFont systemFontOfSize:18];
    [textLabel setFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, SCREEN_WIDTH, 50)];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"加载失败";
    textLabel.textColor = COLOR_08;
    
    
    textLabel1 = [UILabel new];
    [textLabel1 setFrame:CGRectMake(0,textLabel.frame.origin.y+5+textLabel.frame.size.height-(textLabel.frame.size.height/1.5), SCREEN_WIDTH, 50)];
    textLabel1.textAlignment = NSTextAlignmentCenter;
    textLabel1.text = @"请点击屏幕重试";
    textLabel1.font =[UIFont systemFontOfSize:18];
    textLabel1.textColor = COLOR_08;
    [loadfail_View addSubview:textLabel1];
    
    
    [loadfail_View addSubview:textLabel];
    
    [self addSubview:loadfail_View];

}
//网络不好
-(void)initloadNetworkView{
    loadNetwork_View = [[UIView alloc] initWithFrame:self.bounds];
    loadNetwork_View.hidden = YES;
    loadNetwork_View.backgroundColor = [[UIColor  whiteColor] colorWithAlphaComponent:0.3];
    //UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2-20, SCREEN_WIDTH, )];
    UILabel *label = [[UILabel alloc] init];
    UIFont *iconfont =[UIFont fontWithName:@"iconfont" size:60];
    
    label.font=iconfont;
    label.text =@"\U0000e610";
    CGSize titleLabelsize = [label.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 20) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:iconfont} context:nil].size;
    label.frame = CGRectMake(SCREEN_WIDTH/2-titleLabelsize.width/2, loadNetwork_View.frame.size.height/2-100, SCREEN_WIDTH, titleLabelsize.height);
    
    
    [loadNetwork_View addSubview:label];
    
    
    textLabel = [UILabel new];
    textLabel.font =[UIFont systemFontOfSize:18];
    [textLabel setFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, SCREEN_WIDTH, 50)];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"加载失败";
    textLabel.textColor = COLOR_08;
    
    
    textLabel1 = [UILabel new];
    [textLabel1 setFrame:CGRectMake(0,textLabel.frame.origin.y+5+textLabel.frame.size.height-(textLabel.frame.size.height/1.5), SCREEN_WIDTH, 50)];
    textLabel1.textAlignment = NSTextAlignmentCenter;
    textLabel1.text = @"请点击屏幕重试";
    textLabel1.font = [UIFont systemFontOfSize:18];
    textLabel1.textColor = COLOR_08;
    [loadNetwork_View addSubview:textLabel1];
    
    [loadNetwork_View addSubview:textLabel];
    
    [self addSubview:loadNetwork_View];
}
//加载中试图
-(void)initloadingView{
    
    loading_View = [[UIView alloc] initWithFrame:self.bounds];
    loading_View.hidden=NO;
    loading_View.backgroundColor =[UIColor whiteColor];
    
    UILabel *label =[[UILabel alloc]init];
    UIFont *iconfont =[UIFont fontWithName:@"iconfont" size:46];
    label.font=iconfont;
    label.text =@"\U0000e617";
    label.textColor = COLOR_08;
    
    CGSize titleLabelsize = [label.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 20) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:iconfont} context:nil].size;
    
    label.frame = CGRectMake(SCREEN_WIDTH/2-titleLabelsize.width/2-2, loading_View.frame.size.height/2-100, SCREEN_WIDTH, titleLabelsize.height);
    [loading_View addSubview:label];
    
    self.logo_image = [UIImageView new];
    self.logo_image.layer.cornerRadius=label.frame.size.height/2;
    self.logo_image.image = [UIImage imageNamed:@"加载@2x.png"];
    self.logo_image.frame=CGRectMake(label.frame.origin.x-10, label.frame.origin.y-8,label.frame.size.height+18,label.frame.size.height+18);
    //self.logo_image.center = label.center;
    
    [loading_View addSubview:self.logo_image];
    
    
    
    textLabel1 = [UILabel new];
    textLabel1.text = @"正在加载...";
    textLabel1.font = [UIFont systemFontOfSize:18];
    textLabel1.textColor = [UIColor blackColor];
    textLabel1.textAlignment = NSTextAlignmentCenter;
   [textLabel1 setFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, SCREEN_WIDTH, 50)];

    [loading_View addSubview:textLabel1];

    
    [self addSubview:loading_View];
    [self startAnimation];
}
-(void)startAnimation{
    @try {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.02];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(endAnimation)];
        self.logo_image.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
        [UIView commitAnimations];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
-(void)endAnimation
{
    if (isTransform) {
        angle += 5;
        [self startAnimation];
    }
    else{
        return;
    }
}
-(void)stopAnimation{
    isTransform = NO;
}
-(void)tagAction{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(reloadData)]) {
       reloadButton.hidden = YES;
        [self.delegate reloadData];
        [self removeFromSuperview];
     }
}
-(void)hiddenloadfailview:(BOOL)hidden{
    loadfail_View.hidden = hidden;
}
-(void)hiddenloadingview:(BOOL)hidden{
    loading_View.hidden = hidden;
}
-(void)hiddenloadNetworkview:(BOOL)hidden;{
    loadNetwork_View.hidden = hidden;
}
@end
