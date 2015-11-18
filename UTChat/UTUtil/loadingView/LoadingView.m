//
//  LoadingView.m
//  BESTKEEP
//
//  Created by dcj on 15/10/17.
//  Copyright © 2015年 YISHANG. All rights reserved.
//

#import "LoadingView.h"
#define IS_IPHONE_4_INCH (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)568 ) < DBL_EPSILON )

@interface LoadingView ()

@end


@implementation LoadingView

+ (LoadingView *)showLoadViewToView:(UIView *)view animated:(BOOL)animated{
    LoadingView *hud = [[LoadingView alloc] initWithView:view];
    [view addSubview:hud];
    [hud show:animated];
    return hud;
}
+(LoadingView *)showLoadViewToView:(UIView *)view{
    return [self showLoadViewToView:view animated:YES];
}

+ (BOOL)hideLoadViewToView:(UIView *)view animated:(BOOL)animated{
    LoadingView *hud = [LoadingView loadViewForView:view];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:animated];
        return YES;
    }
    return NO;

}
+(BOOL)hideLoadViewToView:(UIView *)view{
    return [self hideLoadViewToView:view animated:YES];
}

+ (NSUInteger)hideAllLoadViewForView:(UIView *)view animated:(BOOL)animated{
    NSArray *huds = [self allLoadViewForView:view];
    for (LoadingView *hud in huds) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:animated];
    }
    return [huds count];

}

+ (LoadingView *)loadViewForView:(UIView *)view{
    LoadingView *hud = nil;
    NSArray *subviews = view.subviews;
    Class hudClass = [LoadingView class];
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (LoadingView *)aView;
        }
    }
    return hud;

}
+ (NSArray *)allLoadViewForView:(UIView *)view{
    NSMutableArray *huds = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    Class hudClass = [LoadingView class];
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:hudClass]) {
            [huds addObject:aView];
        }
    }
    return [NSArray arrayWithArray:huds];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_03;
        self.dimBackground = NO;
        self.mode = MBProgressHUDModeCustomView;
        self.labelText = [NSString stringWithFormat:@"正在加载..."];
        self.labelFont = [UIFont systemFontOfSize:13.0f];
        self.labelColor = COLOR_04;
        
        LoadingAnimationVIew * animationView = [[LoadingAnimationVIew alloc] initWithFrame:CGRectZero];
        animationView.strokeThickness = 2;
        animationView.strokeColor = COLOR_04;
        animationView.radius = 15;
        [animationView sizeToFit];
        
        self.customView = animationView;
        
//        self.yOffset = IS_IPHONE_4_INCH?-60:-30;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.dimBackground) {
        //Gradient colours
        size_t gradLocationsNum = 2;
        CGFloat gradLocations[2] = {0.0f, 1.0f};
        CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        CGColorSpaceRelease(colorSpace);
        //Gradient center
        CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        //Gradient radius
        float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
        //Gradient draw
        CGContextDrawRadialGradient (context, gradient, gradCenter,
                                     0, gradCenter, gradRadius,
                                     kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient);
    }
    
    // Set background rect color
    if(self.color){
        CGContextSetFillColorWithColor(context, self.color.CGColor);
    } else {
        CGContextSetGrayFillColor(context, 0.0f, self.opacity);
    }
}


@end

@interface LoadingAnimationVIew ()

@property (nonatomic, strong) CAShapeLayer *indefiniteAnimatedLayer;


@end

@implementation LoadingAnimationVIew

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self layoutAnimatedLayer];
    } else {
        [_indefiniteAnimatedLayer removeFromSuperlayer];
        _indefiniteAnimatedLayer = nil;
    }
}

- (void)layoutAnimatedLayer {
    CALayer *layer = self.indefiniteAnimatedLayer;
    [self.layer addSublayer:layer];
    layer.position = CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(layer.bounds) / 2, CGRectGetHeight(self.bounds) - CGRectGetHeight(layer.bounds) / 2);
}

- (CAShapeLayer*)indefiniteAnimatedLayer {
    if(!_indefiniteAnimatedLayer) {
        CGPoint arcCenter = CGPointMake(self.radius+self.strokeThickness/2+5, self.radius+self.strokeThickness/2+5);
        CGRect rect = CGRectMake(0.0f, 0.0f, arcCenter.x*2, arcCenter.y*2);
        
        UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                                    radius:self.radius
                                                                startAngle:M_PI*3/2
                                                                  endAngle:M_PI/2+M_PI*5
                                                                 clockwise:YES];
        
        _indefiniteAnimatedLayer = [CAShapeLayer layer];
        _indefiniteAnimatedLayer.contentsScale = [[UIScreen mainScreen] scale];
        _indefiniteAnimatedLayer.frame = rect;
        _indefiniteAnimatedLayer.fillColor = [UIColor clearColor].CGColor;
        _indefiniteAnimatedLayer.strokeColor = self.strokeColor.CGColor;
        _indefiniteAnimatedLayer.lineWidth = self.strokeThickness;
        _indefiniteAnimatedLayer.lineCap = kCALineCapRound;
        _indefiniteAnimatedLayer.lineJoin = kCALineJoinBevel;
        _indefiniteAnimatedLayer.path = smoothedPath.CGPath;
        
        CALayer *maskLayer = [CALayer layer];
        
        maskLayer.contents = (id)[[UIImage imageNamed:@"angle-mask"] CGImage];;
        maskLayer.frame = _indefiniteAnimatedLayer.bounds;
        _indefiniteAnimatedLayer.mask = maskLayer;
        
        NSTimeInterval animationDuration = 1;
        CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.fromValue = 0;
        animation.toValue = @(M_PI*2);
        animation.duration = animationDuration;
        animation.timingFunction = linearCurve;
        animation.removedOnCompletion = NO;
        animation.repeatCount = INFINITY;
        animation.fillMode = kCAFillModeForwards;
        animation.autoreverses = NO;
        [_indefiniteAnimatedLayer.mask addAnimation:animation forKey:@"rotate"];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = INFINITY;
        animationGroup.removedOnCompletion = NO;
        animationGroup.timingFunction = linearCurve;
        
        CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.fromValue = @0.015;
        strokeStartAnimation.toValue = @0.515;
        
        CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeEndAnimation.fromValue = @0.485;
        strokeEndAnimation.toValue = @0.985;
        
        animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
        [_indefiniteAnimatedLayer addAnimation:animationGroup forKey:@"progress"];
        
    }
    return _indefiniteAnimatedLayer;
}

- (void)setFrame:(CGRect)frame {
    if(!CGRectEqualToRect(frame, super.frame)){
        [super setFrame:frame];
        
        if (self.superview) {
            [self layoutAnimatedLayer];
        }
    }
    
}

- (void)setRadius:(CGFloat)radius {
    if(radius != _radius){
        _radius = radius;
        
        [_indefiniteAnimatedLayer removeFromSuperlayer];
        _indefiniteAnimatedLayer = nil;
        
        if (self.superview) {
            [self layoutAnimatedLayer];
        }
    }
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    _indefiniteAnimatedLayer.strokeColor = strokeColor.CGColor;
}

- (void)setStrokeThickness:(CGFloat)strokeThickness {
    _strokeThickness = strokeThickness;
    _indefiniteAnimatedLayer.lineWidth = _strokeThickness;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake((self.radius+self.strokeThickness/2+5)*2, (self.radius+self.strokeThickness/2+5)*2);
}

@end




