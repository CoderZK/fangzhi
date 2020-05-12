//
//  zkShowVIew.m
//  FangZhiAPP
//
//  Created by kunzhang on 2019/6/19.
//  Copyright © 2019年 张坤. All rights reserved.
//

#import "zkShowVIew.h"
#import <MJRefresh.h>
#define ssHH [UIApplication sharedApplication].statusBarFrame.size.width
#define HHHHHH [UIScreen mainScreen].bounds.size.height
#define WWWWW [UIScreen mainScreen].bounds.size.width
@interface zkShowVIew()

/**  */
@property(nonatomic , strong)UIView *blackView;


@end

@implementation zkShowVIew

- (instancetype)initWithFrame:(CGRect)frame {
    
    self =[super initWithFrame:frame];

    if (self) {
        
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        self.blackView = [[UIView alloc] init];
        self.blackView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.9];
        self.blackView.mj_w = frame.size.width;
        self.blackView.mj_h = 170;
        self.blackView.mj_x = 0;
        self.blackView.mj_y = HHHHHH;
        [self addSubview:self.blackView];
        
        UIButton * button =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, WWWWW, HHHHHH - 200)];
        [button addTarget:self action:@selector(diss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        
        [self addViews];
    }
    
    return self;
}


- (void)addViews {
    
    CGFloat ww = 80;
    CGFloat space = (WWWWW - 240)/6;
    
    NSArray * arr =@[@"清缓存",@"扫一扫",@"关于",@"分享",@"刷新",@"退出"];
    for (int i = 0 ; i < arr.count ; i++) {
        
        UIButton * button =[[UIButton alloc] initWithFrame:CGRectMake(space + (2*space + ww) * (i % 3), ww * (i /3), ww, ww)];
        button.tag = i;
        [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView * imgV =[[UIImageView alloc] initWithFrame:CGRectMake((ww - 30)/2, 15, 30, 30)];
        imgV.image =[UIImage imageNamed: [NSString stringWithFormat:@"show%d",i]];
        [button addSubview:imgV];
        UILabel * lb =[[UILabel alloc] initWithFrame:CGRectMake(0, 55, ww, 20)];
        lb.text = arr[i];
//        lb.textColor = [UIColor colorWithRed:100/225.0 green:100/225.0 blue:100/225.0 alpha:1.0];
        lb.font =[UIFont systemFontOfSize:14];
        lb.textColor = [UIColor whiteColor];
        lb.textAlignment = NSTextAlignmentCenter;
        [button addSubview:lb];
        
        [self.blackView addSubview:button];
        
    }
    
}

- (void)action:(UIButton *)button {
    [self diss];
    if (self.deleate != nil && [self.deleate respondsToSelector:@selector(didClickIndex:)]){
        [self.deleate didClickIndex:button.tag];
    }
    
}

- (void)show {
    
    self.isShow = YES;
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        
        if ( ssHH > 20) {
            self.blackView.mj_y = HHHHHH - 170 - 45 - 34 + 44;
        }else {
            self.blackView.mj_y = HHHHHH - 170 - 45 + 44;
            
        }

    }];
    
    
    
    
}

- (void)diss{
    self.isShow = NO;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.blackView.mj_y = self.frame.size.height;
        
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
    
    
}



@end
