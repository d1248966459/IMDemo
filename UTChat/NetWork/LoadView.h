//
//  LoadView.h
//  MobileUU
//
//  Created by 魏鹏 on 15/7/7.
//  Copyright (c) 2015年 Shanghai Pecker Network Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol reloadDataDelegate <NSObject>

-(void)reloadData;

@end
@interface LoadView : UIView{
    UILabel *textLabel;
    UILabel *textLabel1;
    UIView *loading_View;
    UIView *loadfail_View;
    UIButton *reloadButton;
    UIView *loadNetwork_View;
    double angle;
    BOOL isTransform;
}
@property(nonatomic,assign)id<reloadDataDelegate> delegate;
@property(nonatomic,strong) UIImageView *logo_image;
//@property(nonatomic,strong) UIView *loading_View;
//@property(nonatomic,strong) UIView *loadfail_View;

-(void)hiddenloadfailview:(BOOL)hidden;
-(void)hiddenloadingview:(BOOL)hidden;
-(void)hiddenloadNetworkview:(BOOL)hidden;
-(void)stopAnimation;
-(void)tagAction;


@end
