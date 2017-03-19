//
//  LXPageView.m
//  LXPageView
//
//  Created by Leexin on 17/3/17.
//  Copyright © 2017年 Garden.Lee. All rights reserved.
//

#import "LXPageView.h"
#import "UIView+Extensions.h"
#import "LXPageIndicatorView.h"

static const CGFloat kIndicatorViewSize = 6.f;
static const CGFloat kIndicatorViewSpace = 5.f;
static const CGFloat kAnimationDuration = 0.6;
static const NSInteger kTag = 555;
#define degreesToRadians(x) (M_PI*(x)/180.0)

@interface LXPageView () <CAAnimationDelegate>

@property (nonatomic, assign) LXPageViewStyle style;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) LXPageIndicatorView *currentIndicatorView;
@property (nonatomic, assign) BOOL needOneMore;

@property (nonatomic, assign) NSInteger prePage; // 之前位置坐标

@end

@implementation LXPageView

- (instancetype)initWithFrame:(CGRect)frame style:(LXPageViewStyle)style pageCount:(NSInteger)pageCount {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        self.pageCount = pageCount;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    [self addPageIndicatorView];
}

- (void)addPageIndicatorView {
    
    PageIndicatorViewStyle indicatorStyle;
    PageIndicatorViewStyle currentStyle = PageIndicatorViewStyleLine;
    switch (self.style) {
        case LXPageViewStyleLineMove: {
            indicatorStyle = PageIndicatorViewStyleLine;
            currentStyle = PageIndicatorViewStyleLine;
            self.needOneMore = YES;
        }
            break;
        case LXPageViewStyleCircleMove: {
            indicatorStyle = PageIndicatorViewStyleCircle;
            currentStyle = PageIndicatorViewStyleCircle;
            self.needOneMore = YES;
        }
            break;
        case LXPageViewStyleHollowCircleMove: {
            indicatorStyle = PageIndicatorViewStyleHollowCircle;
            currentStyle = PageIndicatorViewStyleCircle;
            self.needOneMore = YES;
        }
        case LXPageViewStyleHollowCircleToDisc: {
            indicatorStyle = PageIndicatorViewStyleHollowCircle;
        }
            break;
        case LXPageViewStyleCircleExchange: {
            indicatorStyle = PageIndicatorViewStyleCircle;
        }
            break;
        case LXPageViewStyleCircleRotate: {
            indicatorStyle = PageIndicatorViewStyleCircle;
        }
            break;
        case LXPageViewStyleHollowCircleRotate: {
            indicatorStyle = PageIndicatorViewStyleHollowCircle;
        }
            break;
        case LXPageViewStyleCircleDrag: {
            indicatorStyle = PageIndicatorViewStyleCircle;
            currentStyle = PageIndicatorViewStyleCircle;
            self.needOneMore = YES;
        }
            break;
        case LXPageViewStyleCircleDragTail: {
            indicatorStyle = PageIndicatorViewStyleCircle;
            currentStyle = PageIndicatorViewStyleCircle;
            self.needOneMore = YES;
        }
            break;
        default:
            break;
    }
    
    CGFloat kPageIndicatorTop = (self.height - kIndicatorViewSize) / 2;
    for (int i = 0; i < self.pageCount; i++) {
        CGFloat currentLeft = [self currentLeftPoint:i];
        LXPageIndicatorView *indicator = [[LXPageIndicatorView alloc] initWithFrame:CGRectMake(currentLeft, kPageIndicatorTop, kIndicatorViewSize, kIndicatorViewSize)
                                                                     indicatorStyle:indicatorStyle];
        indicator.tag = kTag + i;
        [self addSubview:indicator];
        if (!self.needOneMore && i == 0) {
            indicator.isSelected = YES;
        }
    }
    
    if (!self.currentIndicatorView && self.needOneMore) {
        self.currentIndicatorView = [[LXPageIndicatorView alloc] initWithFrame:CGRectMake([self currentLeftPoint:0], kPageIndicatorTop, kIndicatorViewSize, kIndicatorViewSize)
                                                                indicatorStyle:currentStyle];
        self.currentIndicatorView.isSelected = YES;
        [self addSubview:self.currentIndicatorView];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    
    if (currentPage < 0) currentPage = 0;
    if (currentPage >= self.pageCount) currentPage = self.pageCount - 1;
    self.prePage = _currentPage;
    _currentPage = currentPage;
//    NSLog(@"之前：%ld, 当前：%ld",(long)self.prePage,(long)_currentPage);
//    [self changePageSelectStatus];
    [self changePageAnimation];
}

- (void)changePageSelectStatus {
    
    for (int i = 0; i < self.pageCount; i++) {
        LXPageIndicatorView *indicatorView = (LXPageIndicatorView *)[self viewWithTag:(i + kTag)];
        if (i == self.currentPage) {
            indicatorView.isSelected = YES;
        } else {
            indicatorView.isSelected = NO;
        }
    }
}

- (void)changePageAnimation {
    
    switch (self.style) {
        case LXPageViewStyleLineMove:
        case LXPageViewStyleCircleMove:
        case LXPageViewStyleHollowCircleMove:
            [self removeIndicatorViewAnimation];
            break;
        case LXPageViewStyleHollowCircleToDisc: {
            [self hollowChangeCircelAnimation];
        }
            break;
        case LXPageViewStyleCircleExchange: {
            [self circleExchangeAnimation];
        }
            break;
        case LXPageViewStyleCircleRotate: {
            [self rotateAnimation];
        }
        case LXPageViewStyleHollowCircleRotate: {

        }
            break;
        case LXPageViewStyleCircleDrag: {

        }
            break;
        case LXPageViewStyleCircleDragTail: {

        }
        default:
            break;
    }

}

#pragma mark - Animation method

- (void)removeIndicatorViewAnimation {
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.currentIndicatorView.left = [self currentLeftPoint:self.currentPage];
    }];
}

- (void)hollowChangeCircelAnimation {
    
    LXPageIndicatorView *preIndicatorView = (LXPageIndicatorView *)[self viewWithTag:(self.prePage + kTag)];
    LXPageIndicatorView *nowIndicatorView = (LXPageIndicatorView *)[self viewWithTag:(self.currentPage + kTag)];
    preIndicatorView.hollowCircleWidth = 0.5f;
    nowIndicatorView.hollowCircleWidth = 2;
}

- (void)circleExchangeAnimation {
    
    LXPageIndicatorView *preIndicatorView = (LXPageIndicatorView *)[self viewWithTag:(self.prePage + kTag)];
    LXPageIndicatorView *nowIndicatorView = (LXPageIndicatorView *)[self viewWithTag:(self.currentPage + kTag)];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        CGFloat tempPoint = preIndicatorView.left;
        preIndicatorView.left = nowIndicatorView.left;
        nowIndicatorView.left = tempPoint;
    }];
    NSInteger tempTag = preIndicatorView.tag;
    preIndicatorView.tag = nowIndicatorView.tag;
    nowIndicatorView.tag = tempTag;
}

- (void)rotateAnimation {
    
    
    LXPageIndicatorView *preIndicatorView = (LXPageIndicatorView *)[self viewWithTag:(self.prePage + kTag)];
    LXPageIndicatorView *nowIndicatorView = (LXPageIndicatorView *)[self viewWithTag:(self.currentPage + kTag)];
    CGPoint currentCenter = CGPointMake(nowIndicatorView.center.x /2 + preIndicatorView.center.x / 2,preIndicatorView.center.y);
    CGFloat radius = nowIndicatorView.left - preIndicatorView.right;
//    CGFloat radius = 5;
    [self upCircleAnimation:preIndicatorView path:currentCenter radius:radius];
    [self downCircleAnimation:nowIndicatorView path:currentCenter radius:radius];
    NSInteger tempTag = preIndicatorView.tag;
    preIndicatorView.tag = nowIndicatorView.tag;
    nowIndicatorView.tag = tempTag;
}

- (void)upCircleAnimation:(LXPageIndicatorView *)indicatoer path:(CGPoint)point radius:(CGFloat)radius {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point
                                                        radius:radius
                                                    startAngle:degreesToRadians(180)
                                                      endAngle:degreesToRadians(0)
                                                     clockwise:NO];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.calculationMode = kCAAnimationPaced;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 2 * kAnimationDuration;
    animation.path = path.CGPath;
    NSString *animationName = [NSString stringWithFormat:@"upAn+%ld",(long)indicatoer.tag];
    [indicatoer.layer addAnimation:animation forKey:animationName];
    
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    indicatoer.layer.position = CGPointMake(point.x + radius, point.y);
    [CATransaction commit];
}

- (void)downCircleAnimation:(LXPageIndicatorView *)indicatoer path:(CGPoint)point radius:(CGFloat)radius {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point
                                                        radius:radius
                                                    startAngle:degreesToRadians(0)
                                                      endAngle:degreesToRadians(180)
                                                     clockwise:NO];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.calculationMode = kCAAnimationPaced;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 2 * kAnimationDuration;
    animation.path = path.CGPath;
    NSString *animationName = [NSString stringWithFormat:@"downAn+%ld",(long)indicatoer.tag];
    [indicatoer.layer addAnimation:animation forKey:animationName];
    
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    indicatoer.layer.position = point;
    [CATransaction commit];
}

#pragma mark - Other Method

- (CGFloat)currentLeftPoint:(NSInteger)index {
    
    if (index < 0 || index > self.pageCount - 1) return 0;
    CGFloat kPageIndicatorLeft = (self.width - self.pageCount * (kIndicatorViewSize + kIndicatorViewSpace) - kIndicatorViewSpace) / 2;
    CGFloat leftPoint = kPageIndicatorLeft + index * (kIndicatorViewSize + kIndicatorViewSpace);;
    
    return leftPoint;
}

@end
