//
//  LXPageIndicatorView.h
//  LXPageView
//
//  Created by Leexin on 17/3/17.
//  Copyright © 2017年 Garden.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PageIndicatorViewStyle) {
    
    PageIndicatorViewStyleLine,
    PageIndicatorViewStyleCircle,
    PageIndicatorViewStyleHollowCircle,
};

@interface LXPageIndicatorView : UIView

@property (nonatomic, assign) BOOL isSelected; // 是否选中状态
@property (nonatomic, strong) UIColor *selectedColor; // 选中颜色
@property (nonatomic, strong) UIColor *unSelectedColor; // 未选中颜色
@property (nonatomic, assign) CGFloat hollowCircleWidth; // 空心圆的线宽

- (instancetype)initWithFrame:(CGRect)frame indicatorStyle:(PageIndicatorViewStyle)style;


@end
