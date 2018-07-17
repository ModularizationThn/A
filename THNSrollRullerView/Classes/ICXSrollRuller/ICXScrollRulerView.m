//
//  TYScrollRulerView.m
//
//  Created by wxj on 2017/8/24.
//  Copyright © 2017年 Daniel Yao. All rights reserved.
//

#import "ICXScrollRulerView.h"

//最大刻度线的高度
#define MAX_LINE_HEIGHT  35
//最小一格刻度的间距
#define MIN_X_SPACE 8

//三角指示器的宽度
#define TRANGLE_WIDTH 16

/**
 *  绘制三角形标示
 */
typedef enum : NSUInteger {
    TranglePoint_DOWN,//三角形向下,
    TranglePoint_UP//三角形向上
} TranglePoint;

@interface ICXScrollRulerIndicateView : UIImageView
@property(nonatomic,strong)UIColor *fillColor;
@property(nonatomic,assign)TranglePoint tranglePoint;
@end
@implementation ICXScrollRulerIndicateView

@end

@class ICXScrollRulerIndicateView;
@interface ICXScrollRulerView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * contentView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) CAGradientLayer *startGradientLayer;
@property (nonatomic, strong) CAGradientLayer *endGradientLayer;

@property (nonatomic, assign) CGFloat gradientWidth;

@property (nonatomic, assign) float minValue;//最小值

@property (nonatomic, assign) float maxValue;//最大值

@property (nonatomic, assign) float initialValue;//默认初始值

@end

@implementation ICXScrollRulerView


- (instancetype)initWithFrame:(CGRect)frame minValue:(float )minValue maxValue:(float)maxValue initialValue:(float) initialValue gradientColorArr:(NSArray<UIColor *> *)gradientColorArr gradientWidth:(CGFloat)gradientWidth
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.gradientWidth = gradientWidth;
        self.minValue = minValue;
        self.maxValue = maxValue;
        self.initialValue = initialValue;
        self.minRulerValue = 1.0;
        self.rulerColor = [UIColor lightGrayColor];
        self.rulerValueColor = [UIColor blackColor];
        self.showTopNumber = YES;
        self.showBottomNumber = YES;
    
        _contentView = [[UIScrollView alloc] init];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.frame = self.bounds;
        _contentView.delegate = self;
        [self addSubview:_contentView];
        [self addSubview:self.indicateView];
        
        self.bgView = [[UIView alloc]initWithFrame:self.bounds];
        self.bgView.userInteractionEnabled = NO;
        self.bgView.backgroundColor = [UIColor clearColor];
        self.bgView.frame = self.bounds;
        [self addSubview:self.bgView];
        
        self.startGradientLayer =  [CAGradientLayer layer];
        self.startGradientLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, gradientWidth, self.bounds.size.height);
        
        NSMutableArray *colors = [NSMutableArray array];
        for (UIColor *color in gradientColorArr) {
            [colors addObject:(id)color.CGColor];
        }
        [self.startGradientLayer setColors:colors];
        [self.startGradientLayer setStartPoint:CGPointMake(0.0, 0.0)];
        [self.startGradientLayer setEndPoint:CGPointMake(1.0, 0.0)];
        [self.bgView.layer addSublayer:self.startGradientLayer];
        
        self.endGradientLayer =  [CAGradientLayer layer];
        self.endGradientLayer.frame = CGRectMake(self.bounds.size.width - gradientWidth, self.bounds.origin.y, gradientWidth, self.bounds.size.height);
        [self.endGradientLayer setColors:colors];
        [self.endGradientLayer setStartPoint:CGPointMake(1.0, 0.0)];
        [self.endGradientLayer setEndPoint:CGPointMake(0.0, 0.0)];
        [self.bgView.layer addSublayer:self.endGradientLayer];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
    self.contentView.frame = self.bounds;
    self.startGradientLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.gradientWidth, self.bounds.size.height);
    self.endGradientLayer.frame = CGRectMake(self.bounds.size.width - self.gradientWidth, self.bounds.origin.y, self.gradientWidth, self.bounds.size.height);
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if ([self.delegate respondsToSelector:@selector(indicateViewInsetsOfScrollRulerView:)]) {
        insets = [self.delegate indicateViewInsetsOfScrollRulerView:self];
    }
    _indicateView.frame = CGRectMake((self.bounds.size.width - TRANGLE_WIDTH)/2.0 + 6.5 + insets.left + insets.right, insets.top, 3, self.bounds.size.height - insets.bottom -insets.top);
}

- (ICXScrollRulerIndicateView *)indicateView
{
    if (!_indicateView) {
        _indicateView = [[ICXScrollRulerIndicateView alloc] init];
        UIEdgeInsets insets = UIEdgeInsetsZero;
        _indicateView.frame = CGRectMake((self.bounds.size.width - TRANGLE_WIDTH)/2.0 + 6.5 + insets.left + insets.right, insets.top, 3, self.bounds.size.height + insets.bottom);
        _indicateView.backgroundColor = [UIColor blueColor];
        _indicateView.contentMode = UIViewContentModeCenter;
    }
    return _indicateView;
}

- (void)drawRect:(CGRect)rect
{
    [self drawRuler];
    [self configLabelOrientation:self.rulerOrientation];
}

-(void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    self.indicateView.backgroundColor = indicatorColor;
}

- (void)setRulerColor:(UIColor *)rulerColor
{
    _rulerColor = rulerColor;
}

- (void)setShowTopNumber:(BOOL)showRulerNumber
{
    _showTopNumber = showRulerNumber;
}

- (void)setRulerValueColor:(UIColor *)rulerValueColor
{
    _rulerValueColor = rulerValueColor;
}

- (void)setMinRulerValue:(float)minRulerValue
{
    _minRulerValue = minRulerValue;
}

- (void)drawRuler
{
    CGMutablePathRef pathRef1 = CGPathCreateMutable();
    CGMutablePathRef pathRef2 = CGPathCreateMutable();
    
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.strokeColor = self.rulerColor.CGColor;
    shapeLayer1.fillColor = [UIColor clearColor].CGColor;
    shapeLayer1.lineWidth = 1.f;
    shapeLayer1.lineCap = kCALineCapButt;
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.strokeColor = self.rulerColor.CGColor;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    shapeLayer2.lineWidth = 1.f;
    shapeLayer2.lineCap = kCALineCapButt;
    
    float totalValue = self.maxValue - self.minValue;
    NSInteger totalCount = totalValue/self.minRulerValue;//要画的刻度数量
    float halfWidth = self.bounds.size.width/2.0;
    
    float horizontalLineY = CGRectGetHeight(self.bounds)/2.0 + MAX_LINE_HEIGHT/2.0 -2;

    for (int i = self.minValue ; i <= totalCount+self.minValue; i++) {
        
        
        float topSpace = NSNotFound;
        float bottomSpace = NSNotFound;
        
        if ([self.delegate respondsToSelector:@selector(scrollRulerView:rulerInsetsOnIndex:)]) {
            UIEdgeInsets inset = [self.delegate scrollRulerView:self rulerInsetsOnIndex:i];
            topSpace = inset.top;
            bottomSpace = inset.bottom;
        }
        
        
        float x = halfWidth + MIN_X_SPACE*(i-self.minValue);
        if (i % 10 == 0){
        
            if (topSpace == NSNotFound) {
                topSpace = 5;
            }
            if (bottomSpace == NSNotFound) {
                bottomSpace = 5;
            }
            CGPathMoveToPoint(pathRef2, NULL,x, self.bounds.origin.y + topSpace);
            CGPathAddLineToPoint(pathRef2, NULL, x, self.bounds.origin.y + self.bounds.size.height - bottomSpace);
            
            if (self.showBottomNumber) {
                UILabel *ruleLabel = [[UILabel alloc] init];
                ruleLabel.textAlignment = NSTextAlignmentCenter;
                ruleLabel.textColor = self.rulerValueColor;
                ruleLabel.font = [UIFont systemFontOfSize:12.0];
                ruleLabel.text = [NSString stringWithFormat:@"%.0f",i * self.minRulerValue + self.minValue];
                
                if ([self.delegate respondsToSelector:@selector(scrollRulerView:bottomStingOnIndex:)]) {
                    NSString *bottomString = [self.delegate scrollRulerView:self bottomStingOnIndex:i];
                    ruleLabel.text = bottomString;
                }
                CGSize textSize = [ruleLabel.text sizeWithAttributes:@{ NSFontAttributeName : ruleLabel.font }];
                
                float bottomTitleSpace = NSNotFound;
                if ([self.delegate respondsToSelector:@selector(scrollRulerView:bottomTitleSpaceOnIndex:)]) {
                    bottomTitleSpace = [self.delegate scrollRulerView:self bottomTitleSpaceOnIndex:i];
                }
                if (bottomTitleSpace == NSNotFound) {
                    bottomTitleSpace = 5;
                }
                
                ruleLabel.frame = CGRectMake(x - (textSize.width/2.0)/2,self.bounds.origin.y + self.bounds.size.height - textSize.height - bottomTitleSpace,0,0);
                [ruleLabel sizeToFit];
                ruleLabel.center = CGPointMake(x, ruleLabel.center.y);
                [self.contentView addSubview:ruleLabel];
            }
            
            if (self.showTopNumber) {
                UILabel *ruleLabel = [[UILabel alloc] init];
                ruleLabel.textAlignment = NSTextAlignmentCenter;
                ruleLabel.textColor = self.rulerValueColor;
                ruleLabel.font = [UIFont systemFontOfSize:12.0];
                ruleLabel.text = [NSString stringWithFormat:@"%.0f",i * self.minRulerValue + self.minValue];
                
                if ([self.delegate respondsToSelector:@selector(scrollRulerView:topStingOnIndex:)]) {
                    NSString *topString = [self.delegate scrollRulerView:self topStingOnIndex:i];
                    ruleLabel.text = topString;
                }
                
                CGSize textSize = [ruleLabel.text sizeWithAttributes:@{ NSFontAttributeName : ruleLabel.font }];
                
                float topTitleSpace = NSNotFound;
                if ([self.delegate respondsToSelector:@selector(scrollRulerView:bottomTitleSpaceOnIndex:)]) {
                    topTitleSpace = [self.delegate scrollRulerView:self topTitleSpaceOnIndex:i];
                }
                if (topTitleSpace == NSNotFound) {
                    topTitleSpace = 5;
                }
                ruleLabel.frame = CGRectMake(x - (textSize.width/2.0)/2, topTitleSpace,0,0);
                [ruleLabel sizeToFit];
                ruleLabel.center = CGPointMake(x, ruleLabel.center.y);
                [self.contentView addSubview:ruleLabel];
            }
            
        }else if (i % 5 == 0){
            
            if (topSpace == NSNotFound) {
                topSpace = 10;
            }
            if (bottomSpace == NSNotFound) {
                bottomSpace = 10;
            }
            
            CGPathMoveToPoint(pathRef1, NULL, x , self.bounds.origin.y + topSpace);
            CGPathAddLineToPoint(pathRef1, NULL, x, self.bounds.origin.y + self.bounds.size.height - bottomSpace);
        
        }else{
        
            if (topSpace == NSNotFound) {
                topSpace = 15;
            }
            if (bottomSpace == NSNotFound) {
                bottomSpace = 15;
            }
            
            CGPathMoveToPoint(pathRef1, NULL, x , self.bounds.origin.y + topSpace);
            CGPathAddLineToPoint(pathRef1, NULL, x, self.bounds.origin.y + self.bounds.size.height - bottomSpace);
        }
        
        if ([self.delegate respondsToSelector:@selector(minimumScaleWidthWithScrollRulerView:)]) {
            CGFloat width = [self.delegate minimumScaleWidthWithScrollRulerView:self];
            shapeLayer1.lineWidth = width;
        }
        if ([self.delegate respondsToSelector:@selector(maximumScaleWidthWithScrollRulerView:)]) {
            CGFloat width = [self.delegate maximumScaleWidthWithScrollRulerView:self];
            shapeLayer2.lineWidth = width;
        }
        shapeLayer1.path = pathRef1;
        shapeLayer2.path = pathRef2;
        
        [self.contentView.layer addSublayer:shapeLayer1];
        [self.contentView.layer addSublayer:shapeLayer2];
    }
    
    if (self.indicateView.tranglePoint == TranglePoint_UP) {
        
       self.indicateView.frame = CGRectMake((self.bounds.size.width - TRANGLE_WIDTH)/2.0, horizontalLineY - TRANGLE_WIDTH, TRANGLE_WIDTH, TRANGLE_WIDTH);
    }
    
    self.contentView.contentSize = CGSizeMake(halfWidth*2 + MIN_X_SPACE * totalCount, 0);
    
    if (self.initialValue <= self.minValue) {
        [self.contentView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    else if (self.initialValue >= self.maxValue){
        [self.contentView setContentOffset:CGPointMake(self.contentView.contentSize.width - self.contentView.bounds.size.width, 0) animated:NO];
    }else{
    
        float moveX = ((self.initialValue - self.minValue)/self.minRulerValue)*MIN_X_SPACE;
        [self.contentView setContentOffset:CGPointMake(moveX, 0) animated:NO];
    }
}

#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float value = scrollView.contentOffset.x;
    float selectValue = (value/MIN_X_SPACE)*self.minRulerValue;
    selectValue += self.minValue;
    
    if (selectValue <= self.minValue) {
        selectValue = self.minValue;
    }
    if (selectValue >= self.maxValue){
    
        selectValue = self.maxValue;
    }
    
    if (self.currentValueChanged) {
        self.currentValueChanged(selectValue);
    }
    NSLog(@"scrollViewDidScroll ====%f",selectValue);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self animateToIntValuePosition];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self animateToIntValuePosition];
}

- (void)animateToIntValuePosition {
    float value = self.contentView.contentOffset.x;
    float selectValue = (value/MIN_X_SPACE)*self.minRulerValue;
    selectValue += self.minValue;
    NSInteger intValue = (NSInteger)selectValue;
    float floatValue = selectValue - intValue;
    if (floatValue >= 0.5) {
        intValue++;
    }
    
    float moveX = ((intValue - self.minValue)/self.minRulerValue)*MIN_X_SPACE;
    [self.contentView setContentOffset:CGPointMake(moveX, 0) animated:YES];
}

// 改变UIColor的Alpha
- (UIColor *)getNewColorWith:(UIColor *)color alpha:(CGFloat)alpha {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return newColor;
}

- (void)setRulerOrientation:(ICXScrollRulerViewOrientation)orientation {
    if (_rulerOrientation != orientation) {
        [self configOrientation:orientation];
        [self configLabelOrientation:orientation];
    }
    _rulerOrientation = orientation;
}

- (void)configOrientation:(ICXScrollRulerViewOrientation)orientation {
    if (orientation == ICXScrollRulerViewVertical) {
        self.transform = CGAffineTransformMakeRotation (-M_PI_2);
    }else {
        self.transform = CGAffineTransformMakeRotation (0);
    }
}

- (void)configLabelOrientation:(ICXScrollRulerViewOrientation)orientation {
    if (orientation == ICXScrollRulerViewVertical) {
        for (UILabel *label in self.contentView.subviews) {
            label.transform = CGAffineTransformMakeRotation (M_PI_2);
        }
    }else {
        for (UILabel *label in self.contentView.subviews) {
            label.transform = CGAffineTransformMakeRotation (0);
        }
    }
}



@end
