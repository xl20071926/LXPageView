//
//  LXPageView.h
//  LXPageView
//
//  Created by Leexin on 17/3/17.
//  Copyright © 2017年 Garden.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LXPageViewStyle){
    
    LXPageViewStyleLineMove, // 下划线位移
    LXPageViewStyleCircleMove, // 实心圆位移
    LXPageViewStyleHollowCircleMove, // 空心圆位移
    LXPageViewStyleHollowCircleToDisc, // 空心变实心
    LXPageViewStyleCircleExchange, // 实心圆换位
    LXPageViewStyleCircleRotate, // 实心圆旋转
    LXPageViewStyleHollowCircleRotate, // 空心圆旋转
    LXPageViewStyleCircleDrag, // 实心圆拉长
    LXPageViewStyleCircleDragTail // 实心圆拉尖
};

typedef NS_ENUM(NSInteger,LXPageDirection) {
    
    LXPageDirectionForward, // 向前
    LXPageDirectionReverse, // 向后
};

@protocol LXPageViewDelegate <NSObject>

@end

@interface LXPageView : UIView

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) LXPageDirection dicrection;
@property (nonatomic, weak) id<LXPageViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame style:(LXPageViewStyle)style pageCount:(NSInteger)pageCount;

@end
