//
//  LXPageIndicatorView.m
//  LXPageView
//
//  Created by Leexin on 17/3/17.
//  Copyright © 2017年 Garden.Lee. All rights reserved.
//

#import "LXPageIndicatorView.h"
#import "UIView+Extensions.h"
#import "UIColor+Extensions.h"

static const CGFloat kLineWidth = 1.f;
static const CGFloat kLineHeight = 2.f;
#define degreesToRadians(x) (M_PI*(x)/180.0)

@interface LXPageIndicatorView ()

@property (nonatomic, assign) PageIndicatorViewStyle style;

@end

@implementation LXPageIndicatorView

- (instancetype)initWithFrame:(CGRect)frame indicatorStyle:(PageIndicatorViewStyle)style {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.style = style;
        self.hollowCircleWidth = 0.5f;
        self.selectedColor = [UIColor colorWithHex:0xffffff alpha:1.f];
        self.unSelectedColor = [UIColor colorWithHex:0xffffff alpha:0.4];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.style == PageIndicatorViewStyleLine) {
        [self drawLine:context rect:rect];
    } else if (self.style == PageIndicatorViewStyleCircle) {
        [self drawCircle:context rect:rect];
    } else if (self.style == PageIndicatorViewStyleHollowCircle) {
        [self drawHollowCircle:context rect:rect];
    }
}

- (void)drawLine:(CGContextRef)context rect:(CGRect)rect { // 直线
    
    CGContextMoveToPoint(context, 0, (self.height - kLineHeight) / 2);
    CGContextAddLineToPoint(context, self.width, (self.height - kLineHeight) / 2);
    CGContextAddLineToPoint(context, self.width, (self.height - kLineHeight) / 2 + kLineHeight);
    CGContextAddLineToPoint(context, 0, (self.height - kLineHeight) / 2 + kLineHeight);
    CGContextSetLineWidth(context, kLineWidth);
    CGColorRef currentColor = self.isSelected ? self.selectedColor.CGColor : self.unSelectedColor.CGColor;
    CGContextSetStrokeColorWithColor(context, currentColor);
    CGContextSetFillColorWithColor(context, currentColor);
    CGContextFillPath(context);
}

- (void)drawCircle:(CGContextRef)context rect:(CGRect)rect { // 实心圆
    
    CGContextMoveToPoint(context, self.width, self.height / 2);
    CGContextAddArc(context, self.width / 2, self.height / 2, self.width / 2, degreesToRadians(0), degreesToRadians(360), NO);
    CGContextSetLineWidth(context, kLineWidth);
    CGColorRef currentColor = self.isSelected ? self.selectedColor.CGColor : self.unSelectedColor.CGColor;
    CGContextSetStrokeColorWithColor(context, currentColor);
    CGContextSetFillColorWithColor(context, currentColor);
    CGContextFillPath(context);
}

- (void)drawHollowCircle:(CGContextRef)context rect:(CGRect)rect { // 空心圆
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextAddEllipseInRect(context, CGRectMake(self.hollowCircleWidth, self.hollowCircleWidth, self.width - 2 * self.hollowCircleWidth, self.height - 2 * self.hollowCircleWidth));
    CGColorRef currentColor = self.isSelected ? self.selectedColor.CGColor : self.unSelectedColor.CGColor;
    CGContextSetStrokeColorWithColor(context, currentColor);
    CGContextSetLineWidth(context, self.hollowCircleWidth);
    CGContextStrokePath(context);
}

#pragma mark - Setters

- (void)setUnSelectedColor:(UIColor *)unSelectedColor {
    
    if (unSelectedColor) {
        _unSelectedColor = unSelectedColor;
        [self setNeedsDisplay];
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    
    if (selectedColor) {
        _selectedColor = selectedColor;
        [self setNeedsDisplay];
    }
}

- (void)setHollowCircleWidth:(CGFloat)hollowCircleWidth {
    
    if (hollowCircleWidth > 0) {
        _hollowCircleWidth = hollowCircleWidth;
        [UIView animateWithDuration:1. animations:^{
            [self setNeedsDisplay];
        }];
    }
}

@end
