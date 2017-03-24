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

@property (nonatomic, strong) NSTimer *headTimer;
@property (nonatomic, strong) NSTimer *tailTiemr;

@property (nonatomic, assign) CGFloat headFloat;
@property (nonatomic, assign) CGFloat tailFloat;

@property (nonatomic, assign) CGFloat ovalCircleMoveDistance;
@property (nonatomic, copy) void(^ovalCircelMoveFinishBlock)();

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
    } else if (self.style == PageIndicatorViewStyleAnimationCircle) {
        [self drawCircel];
    } else if (self.style == PageIndicatorViewStyleAnimationRainDrop) {
        [self drawCircel];
    } else {
        [self drawCircleWithMask];
    }
}

- (void)drawLine {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(1.f, (self.height - kLineHeight) / 2, self.height - 2, kLineHeight)];
    self.outerShapeLayer = [CAShapeLayer layer];
    self.outerShapeLayer.frame = CGRectMake(0, 0, self.height, self.height);//self.bounds;
    self.outerShapeLayer.path = path.CGPath;
    if (self.isSelected) {
        self.outerShapeLayer.fillColor = self.selectedColor.CGColor;
    } else {
        self.outerShapeLayer.fillColor = self.unSelectedColor.CGColor;
    }
    [self.layer addSublayer:self.outerShapeLayer];
}

- (void)drawCircleWithMask {
    
    if (self.isSelected) {
        self.outerShapeLayer.fillColor = self.selectedColor.CGColor;
    } else {
        self.outerShapeLayer.fillColor = self.unSelectedColor.CGColor;
    }
    self.outerShapeLayer.path = [self getCirclePathWithRadius:self.height / 2].CGPath;
    [self.layer addSublayer:self.outerShapeLayer];
    
    self.innerShapeLayer.fillColor = [[UIColor clearColor] CGColor];
    self.innerShapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
    if (self.style == PageIndicatorViewStyleCircle) {
        [self.innerShapeLayer setLineWidth:self.height - 2];
    } else if (self.style == PageIndicatorViewStyleHollowCircle){
        [self.innerShapeLayer setLineWidth:1];
    }
    self.innerShapeLayer.path = [self getCirclePathWithRadius:self.height / 2 - 1].CGPath;
    [self.outerShapeLayer setMask:self.innerShapeLayer];
}

- (void)drawCircel {
    
    if (self.isSelected) {
        self.outerShapeLayer.fillColor = self.selectedColor.CGColor;
    } else {
        self.outerShapeLayer.fillColor = self.unSelectedColor.CGColor;
    }
    self.outerShapeLayer.path = [self getCirclePathWithRadius:self.height / 2].CGPath;
    [self.layer addSublayer:self.outerShapeLayer];
}

- (UIBezierPath *)getCirclePathWithRadius:(CGFloat)radius {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(self.height / 2, self.height / 2)
                    radius:radius
                startAngle:degreesToRadians(0)
                  endAngle:degreesToRadians(360)
                 clockwise:NO];
    return path;
}

- (UIBezierPath *)getOvalCirclePathWithTailDis:(CGFloat)tailDis headDis:(CGFloat)headDis {
    
    CGFloat size = self.width;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(size / 2 + tailDis, 0)];
    [path addCurveToPoint:CGPointMake(size / 2 + tailDis, size)
            controlPoint1:CGPointMake(size / 2 + tailDis - 4 / 3.0 * size / 2, 0)
            controlPoint2:CGPointMake(size / 2 + tailDis - 4 / 3.0 * size / 2, size)];
    [path addLineToPoint:CGPointMake(size / 2 + headDis, size)];
    [path addCurveToPoint:CGPointMake(size / 2 + headDis, 0)
            controlPoint1:CGPointMake(size / 2 + headDis + 4 / 3.0 * size / 2, size)
            controlPoint2:CGPointMake(size / 2 + headDis + 4 / 3.0 * size / 2, 0)];
    [path closePath];
    
    return path;
}

- (UIBezierPath *)getOvalCirclePathWithWidth:(CGFloat)aWidth headSize:(CGFloat)headSize {
    
    CGFloat height = self.height;
    CGFloat width = aWidth + self.width;
    CGFloat cotrolPoint = 4;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(cotrolPoint, height / 2 - height / 6.f)];
    
    [path addQuadCurveToPoint:CGPointMake(cotrolPoint, height / 2 + height / 6.f)
                 controlPoint:CGPointMake(headSize, height / 2)];
    
    [path addCurveToPoint:CGPointMake(width, height / 2)
            controlPoint1:CGPointMake(cotrolPoint + width / 5, height / 2 + height / 5.f)
            controlPoint2:CGPointMake(width, height / 2 + 2 / 3.0 * height)];
    
    [path addCurveToPoint:CGPointMake(cotrolPoint, height / 2 - height / 6.f)
            controlPoint1:CGPointMake(width, height / 2 - 2 / 3.0 * height )
            controlPoint2:CGPointMake(cotrolPoint + width / 5, height / 2 - height / 5.f)];
    
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

- (void)ovalCircleAnimationWithMoveDistance:(CGFloat)distance fininshBlock:(void(^)())fininshBlock {
    
    if (self.headTimer || self.tailTiemr) return;
    self.ovalCircleMoveDistance = distance;
    self.ovalCircelMoveFinishBlock = fininshBlock;
    self.headFloat = 0;
    self.tailFloat = 0;

    self.headTimer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                                      target:self
                                                    selector:@selector(headMoveMethod)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)rainDropAnimationWithDistance:(CGFloat)distance fininshBlock:(void(^)())fininshBlock {
    
    if (self.headTimer || self.tailTiemr) return;
    self.ovalCircelMoveFinishBlock = fininshBlock;
    self.ovalCircleMoveDistance = distance;
    self.headFloat = 0;
    self.tailFloat = 0;
    
    self.headTimer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                                      target:self
                                                    selector:@selector(rainHead)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)rainHead {
    
    if (self.headFloat > self.ovalCircleMoveDistance) {
        [self.headTimer invalidate];
        self.headTimer = nil;
        [self stareRainTail];
        return;
    }
    self.headFloat += 1.0;
    self.outerShapeLayer.path = [self getOvalCirclePathWithWidth:self.headFloat headSize:self.tailFloat].CGPath;
}

- (void)stareRainTail {
 
    self.tailTiemr = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                      target:self
                                                    selector:@selector(rainTail)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)rainTail {
    
    if (self.tailFloat > 4) {
        [self.tailTiemr invalidate];
        self.tailTiemr = nil;
        self.outerShapeLayer.path = [self getCirclePathWithRadius:self.height / 2].CGPath;
        self.tailFloat = 0;
        self.headFloat = 0;
        if (self.ovalCircelMoveFinishBlock) {
            self.ovalCircelMoveFinishBlock();
        }
        return;
    }
    self.tailFloat += 1.0;
    self.outerShapeLayer.path = [self getOvalCirclePathWithWidth:self.headFloat
                                                        headSize:self.tailFloat].CGPath;
}

- (void)headMoveMethod {
    
    if (self.headFloat > self.ovalCircleMoveDistance - 1) {
        [self.headTimer invalidate];
        self.headTimer = nil;
        [self stareTailDisMoveMethod];
        return;
    }
    self.headFloat += 1.0;
    self.outerShapeLayer.path = [self getOvalCirclePathWithTailDis:0
                                                           headDis:self.headFloat].CGPath;
}

- (void)stareTailDisMoveMethod {
    
    self.tailTiemr = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                     target:self
                                                   selector:@selector(tailMoveMethod)
                                                   userInfo:nil
                                                    repeats:YES];
}

- (void)tailMoveMethod {
    
    if (self.tailFloat > self.ovalCircleMoveDistance - 1) {
        [self.tailTiemr invalidate];
        self.tailTiemr = nil;
        self.outerShapeLayer.path = [self getCirclePathWithRadius:self.height / 2].CGPath;
        self.tailFloat = 0;
        self.headFloat = 0;
        if (self.ovalCircelMoveFinishBlock) {
            self.ovalCircelMoveFinishBlock();
        }
        return;
    }
    self.tailFloat += 1.0;
    self.outerShapeLayer.path = [self getOvalCirclePathWithTailDis:self.tailFloat
                                                           headDis:self.headFloat].CGPath;
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
    CGContextAddLineToPoint(context, self.height, (self.height - kLineHeight) / 2);
    CGContextAddLineToPoint(context, self.height, (self.height - kLineHeight) / 2 + kLineHeight);
    CGContextAddLineToPoint(context, 0, (self.height - kLineHeight) / 2 + kLineHeight);
    CGContextSetLineWidth(context, kLineWidth);
    CGColorRef currentColor = self.isSelected ? self.selectedColor.CGColor : self.unSelectedColor.CGColor;
    CGContextSetStrokeColorWithColor(context, currentColor);
    CGContextSetFillColorWithColor(context, currentColor);
    CGContextFillPath(context);
}

- (void)drawCircle:(CGContextRef)context rect:(CGRect)rect { // 实心圆
    
    CGContextMoveToPoint(context, self.height, self.height / 2);
    CGContextAddArc(context, self.height / 2, self.height / 2, self.height / 2, degreesToRadians(0), degreesToRadians(360), NO);
    CGContextSetLineWidth(context, kLineWidth);
    CGColorRef currentColor = self.isSelected ? self.selectedColor.CGColor : self.unSelectedColor.CGColor;
    CGContextSetStrokeColorWithColor(context, currentColor);
    CGContextSetFillColorWithColor(context, currentColor);
    CGContextFillPath(context);
}

- (void)drawHollowCircle:(CGContextRef)context rect:(CGRect)rect { // 空心圆

    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextAddEllipseInRect(context, CGRectMake(self.hollowCircleWidth, self.hollowCircleWidth, self.height - 2 * self.hollowCircleWidth, self.height - 2 * self.hollowCircleWidth));
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
            [self.innerShapeLayer setLineWidth:self.height - 2];
        }
    } else {
        self.outerShapeLayer.fillColor = [UIColor colorWithHex:0xffffff alpha:0.5].CGColor;
    }
}

#pragma mark - Getters

- (CAShapeLayer *)outerShapeLayer {
    
    if (!_outerShapeLayer) {
        _outerShapeLayer = [CAShapeLayer layer];
        _outerShapeLayer.frame =  CGRectMake(0, 0, self.height, self.height);//self.bounds;
    }
    return _outerShapeLayer;
}

- (CAShapeLayer *)innerShapeLayer {
    
    if (!_innerShapeLayer) {
        _innerShapeLayer = [CAShapeLayer layer];
        _innerShapeLayer.frame =  CGRectMake(0, 0, self.height, self.height);//self.bounds;
    }
    return _innerShapeLayer;
}

@end
