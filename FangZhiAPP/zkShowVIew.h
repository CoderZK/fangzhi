//
//  zkShowVIew.h
//  FangZhiAPP
//
//  Created by kunzhang on 2019/6/19.
//  Copyright © 2019年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol zkShowVIewDelegate <NSObject>

- (void)didClickIndex:(NSInteger)index;

@end

@interface zkShowVIew : UIView

/**  */
@property(nonatomic , assign)id<zkShowVIewDelegate>deleate;

- (void)show;
- (void)diss;
/**  */
@property(nonatomic , assign)BOOL isShow;

@end

NS_ASSUME_NONNULL_END
