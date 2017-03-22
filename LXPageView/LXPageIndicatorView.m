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
static const CGFloat kAnimationDuration = 1.f;
#define degreesToRadians(x) (M_PI*(x)/180.0)

@interface LXPageIndicatorView ()

@property (nonatomic, assign) PageIndicatorViewStyle style;
@property (nonatomic, strong) CAShapeLayer *outerShapeLayer;
@property (nonatomic, strong) CAShapeLayer *innerShapeLayer;

@end

@implementation LXPageIndicatorView

- (instancetype)initWithFrame:(CGRect)frame indicatorStyle:(PageIndicatorViewStyle)style {
    
    return [self initWithFrame:frame
                indicatorStyle:style
               unSelectedColor:[UIColor colorWithHex:0xffffff alpha:0.4]
                 selectedColor:[UIColor colorWithHex:0xffffff alpha:1.f]];
}

- (instancetype)initWithFrame:(CGRect)frame
               indicatorStyle:(PageIndicatorViewStyle)style
              unSelectedColor:(UIColor *)unSelectedColor
                selectedColor:(UIColor *)selectedColor {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.style = style;
        self.hollowCircleWidth = 0.5f;
        self.selectedColor = selectedColor;
        self.unSelectedColor = unSelectedColor;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    if (self.style == PageIndicatorViewStyleLine) {
        [self drawLine];
    } else {
        [self drawCircle];
    }
}

- (void)drawLine {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(1.f, (self.height - kLineHeight) / 2, self.width - 2, kLineHeight)];
    self.outerShapeLayer = [CAShapeLayer layer];
    self.outerShapeLayer.frame = self.bounds;
    self.outerShapeLayer.path = path.CGPath;
    if (self.isSelected) {
        self.outerShapeLayer.fillColor = self.selectedColor.CGColor;
    } else {
        self.outerShapeLayer.fillColor = self.unSelectedColor.CGColor;
    }
    [self.layer addSublayer:self.outerShapeLayer];
}

- (void)drawCircle {
    
    if (self.isSelected) {
        self.outerShapeLayer.fillColor = self.selectedColor.CGColor;
    } else {
        self.outerShapeLayer.fillColor = self.unSelectedColor.CGColor;
    }
    self.outerShapeLayer.path = [self getCirclePathWithRadius:self.width / 2].CGPath;
    [self.layer addSublayer:self.outerShapeLayer];
    
    self.innerShapeLayer.fillColor = [[UIColor clearColor] CGColor];
    self.innerShapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
    if (self.style == PageIndicatorViewStyleCircle) {
        [self.innerShapeLayer setLineWidth:self.width - 2];
    } else if (self.style == PageIndicatorViewStyleHollowCircle){
        [self.innerShapeLayer setLineWidth:1];
    }
    self.innerShapeLayer.path = [self getCirclePathWithRadius:self.width / 2 - 1].CGPath;
    [self.outerShapeLayer setMask:self.innerShapeLayer];
}

- (UIBezierPath *)getCirclePathWithRadius:(CGFloat)radius {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(self.width / 2, self.height / 2)
                    radius:radius
                startAngle:degreesToRadians(0)
                  endAngle:degreesToRadians(360)
                 clockwise:NO];
    return path;
}

#pragma mark - Public method

- (void)hollowToCircleAnimation {
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:kAnimationDuration];
    self.innerShapeLayer.lineWidth = self.width - 2;
    [CATransaction commit];
}

- (void)circelToHollowAnimation {
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:kAnimationDuration];
    [self.innerShapeLayer setLineWidth: 1];
    [CATransaction commit];
}

// ------------以下代码暂时不使用 ----------------------------------------------

- (void)drawRect:(CGRect)rect {
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    if (self.style == PageIndicatorViewStyleLine) {
//        [self drawLine:context rect:rect];
//    } else if (self.style == PageIndicatorViewStyleCircle) {
//        [self drawCircle:context rect:rect];
//    } else if (self.style == PageIndicatorViewStyleHollowCircle) {
//        [self drawHollowCircle:context rect:rect];
//    }
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

// ----------------------------------------------------------------------------------

#pragma mark - Setters

- (void)setUnSelectedColor:(UIColor *)unSelectedColor {
    
    if (unSelectedColor) {
        _unSelectedColor = unSelectedColor;
        if (!self.isSelected) {
            self.outerShapeLayer.fillColor = unSelectedColor.CGColor;
        }
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    
    if (selectedColor) {
        _selectedColor = selectedColor;
        if (self.isSelected) {
            self.innerShapeLayer.fillColor = selectedColor.CGColor;
        }
    }
}

- (void)setHollowCircleWidth:(CGFloat)hollowCircleWidth {
    
    if (hollowCircleWidth > 0) {
        _hollowCircleWidth = hollowCircleWidth;
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    
    _isSelected = isSelected;
    if (isSelected) {
        self.outerShapeLayer.fillColor = [UIColor whiteColor].CGColor;
        if (self.innerShapeLayer) {
            [self.innerShapeLayer setLineWidth:self.width - 2];
        }
    } else {
        self.outerShapeLayer.fillColor = [UIColor colorWithHex:0xffffff alpha:0.5].CGColor;
    }
}

#pragma mark - Getters

- (CAShapeLayer *)outerShapeLayer {
    
    if (!_outerShapeLayer) {
        _outerShapeLayer = [CAShapeLayer layer];
        _outerShapeLayer.frame = self.bounds;
    }
    return _outerShapeLayer;
}

- (CAShapeLayer *)innerShapeLayer {
    
    if (!_innerShapeLayer) {
        _innerShapeLayer = [CAShapeLayer layer];
        _innerShapeLayer.frame = self.bounds;
    }
    return _innerShapeLayer;
}

@end
