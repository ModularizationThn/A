//
//  ICXScrollRulerView.h
//
//  Created by wxj on 2017/8/24.
//  Copyright © 2017年 Daniel Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICXScrollRulerIndicateView;
@class ICXScrollRulerView;
@protocol ICXScrollRulerViewDelegate<NSObject>

@optional
// 顶部刻度文字
- (NSString *)scrollRulerView:(ICXScrollRulerView *)scrollRulerView topStingOnIndex:(NSInteger)index;

// 底部刻度文字
- (NSString *)scrollRulerView:(ICXScrollRulerView *)scrollRulerView bottomStingOnIndex:(NSInteger)index;

// top和bottom，设定刻度距离顶部和底部的空隙
- (UIEdgeInsets)scrollRulerView:(ICXScrollRulerView *)scrollRulerView rulerInsetsOnIndex:(NSInteger)index;

// 指示器的偏移
- (UIEdgeInsets)indicateViewInsetsOfScrollRulerView:(ICXScrollRulerView *)scrollRulerView;

// 最小刻度线宽度
- (CGFloat)minimumScaleWidthWithScrollRulerView:(ICXScrollRulerView *)scrollRulerView;
// 最大刻度线宽度
- (CGFloat)maximumScaleWidthWithScrollRulerView:(ICXScrollRulerView *)scrollRulerView;

// 顶部文字距离顶部间隙
- (float)scrollRulerView:(ICXScrollRulerView *)scrollRulerView topTitleSpaceOnIndex:(NSInteger)index;

// 底部文字距离底部间隙
- (float)scrollRulerView:(ICXScrollRulerView *)scrollRulerView bottomTitleSpaceOnIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, ICXScrollRulerViewOrientation) {
    ICXScrollRulerViewHorizontal = 0,
    ICXScrollRulerViewVertical
};

@interface ICXScrollRulerView : UIView

@property (nonatomic, assign) ICXScrollRulerViewOrientation rulerOrientation;

@property (nonatomic, weak) id<ICXScrollRulerViewDelegate> delegate;

//是否显示刻度值 (默认显示)
@property (nonatomic, assign) BOOL  showTopNumber;

//是否显示底部刻度值
@property (nonatomic, assign) BOOL  showBottomNumber;

//_|_|_最小刻度值(默认为 1.0)
@property (nonatomic, assign) float minRulerValue;

//指示器颜色
@property (nonatomic, strong) UIColor *indicatorColor;

//刻度颜色
@property (nonatomic, strong) UIColor *rulerColor;

//刻度值颜色
@property (nonatomic, strong) UIColor *rulerValueColor;

//拖动显示数值回掉
@property (nonatomic, copy)   void(^currentValueChanged)(float value);

@property (nonatomic, strong) ICXScrollRulerIndicateView *indicateView;

/**
 @param frame 刻度尺坐标位置
 @param minValue 最小值
 @param maxValue 最大值
 @param initialValue 初始值
 @return view
 */
- (instancetype)initWithFrame:(CGRect)frame minValue:(float )minValue maxValue:(float)maxValue initialValue:(float) initialValue gradientColorArr:(NSArray<UIColor *> *)gradientColorArr gradientWidth:(CGFloat)gradientWidth;

@end
