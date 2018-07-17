//
//  ICXFoodScrollRullerView.h
//  ICXCommercialPR
//
//  Created by ICX_THN on 2018/7/16.
//  Copyright © 2018年 ICX. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, IndicatorViewType) {
    IndicatorViewTypeTriangle = 1,
    IndicatorViewTypeypeLine
};
@class ICXFoodScrollRullerView;
@protocol ICXFoodScrollRullerViewDelegate <NSObject>

/*
 *  游标卡尺滑动，对应value回调
 *  滑动视图
 *  当前滑动的值
 */
-(void)dyScrollRulerView:(ICXFoodScrollRullerView *)rulerView valueChange:(float)value;

@end
@interface ICXFoodScrollRullerView : UIView

@property(nonatomic,weak)id<ICXFoodScrollRullerViewDelegate>       delegate;

//滑动时是否改变textfield值
@property(nonatomic, assign)BOOL scrollByHand;
//是否显示底部文字的单位
@property(nonatomic, assign)BOOL showBotoomUnit;
//是否允许尺子上面的TextFile交互
@property(nonatomic, assign)BOOL allowUserActiveValueTF;

//指示条颜色
@property(nonatomic,strong)UIColor *indicatorColor;
//背景颜色
@property(nonatomic,strong)UIColor *bgColor;

-(instancetype)initWithFrame:(CGRect)frame theMinValue:(float)minValue theMaxValue:(float)maxValue theStep:(float)step theUnit:(NSString *)unit theNum:(NSInteger)betweenNum gradientColorArr:(NSArray*)gradientColorArr gradientWidth:(CGFloat)gradientWidth indicatorViewType:(IndicatorViewType)indicatorViewType;

-(void)setRealValue:(float)realValue animated:(BOOL)animated;

+(CGFloat)rulerViewHeight;

-(void)setDefaultValue:(float)defaultValue animated:(BOOL)animated;

@end
