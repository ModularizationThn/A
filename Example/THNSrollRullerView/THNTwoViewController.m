//
//  THNTwoViewController.m
//  THNSrollRullerView_Example
//
//  Created by ICX_THN on 2018/7/17.
//  Copyright © 2018年 TPQuietBro. All rights reserved.
//

#import "THNTwoViewController.h"
#import "ICXScrollRulerView.h"
#define WEAKSELF __weak typeof(self) weakSelf = self;

@interface THNTwoViewController ()
/**
 *************************** maxValue为10000时直接卡死,for循环画线太消耗线能 ***************************
 */
@property(strong,nonatomic) ICXScrollRulerView *ruller;
@end

@implementation THNTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ruller];
    
    WEAKSELF
    self.ruller.currentValueChanged = ^(float value) {
        //        weakSelf.foodweightLabel.text = [NSString stringWithFormat:@"%.0f",value];
        //        [weakSelf.foodweightLabel sizeToFit];
        //        weakSelf.unitLabel.left = weakSelf.foodweightLabel.right+4;
        //        weakSelf.foodweightLabel.centerX = weakSelf.view.centerX;
        //        [weakSelf.view setNeedsLayout];
        NSLog(@"%.f",value);
    };
}

- (ICXScrollRulerView *)ruller {
    
    if (!_ruller) {
        
        _ruller = [[ICXScrollRulerView alloc] initWithFrame:CGRectMake(20, 200+7.5, [UIScreen mainScreen].bounds.size.width-20*2, 73.5) minValue:1 maxValue:2000 initialValue:100 gradientColorArr:@[[UIColor whiteColor], [UIColor colorWithWhite:1 alpha:0]] gradientWidth:100];
        _ruller.backgroundColor = [UIColor whiteColor];
        _ruller.rulerColor = [UIColor colorWithRed:172/255.0 green:190/255.0 blue:212/255.0 alpha:1];
        _ruller.showTopNumber = YES;
        _ruller.showBottomNumber = YES;
        _ruller.minRulerValue = 1;// 更改刻度精确到多少
        _ruller.delegate = (id)self;
        _ruller.indicatorColor = [UIColor colorWithRed:51/255.0 green:133/255.0 blue:238/255.0 alpha:1/1.0];
        _ruller.rulerValueColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        _ruller.rulerOrientation = ICXScrollRulerViewHorizontal;
    }
    return _ruller;
}
#pragma mark - ICXScrollRulerViewDelegate
- (NSString *)scrollRulerView:(ICXScrollRulerView *)scrollRulerView topStingOnIndex:(NSInteger)index {
    return nil;
}

- (NSString *)scrollRulerView:(ICXScrollRulerView *)scrollRulerView bottomStingOnIndex:(NSInteger)index {
    //这里可以设置单位[NSString stringWithFormat:@"%li cm", index];
    return [NSString stringWithFormat:@"%li", index];
}

// top和bottom，设定刻度距离顶部和底部的空隙
- (UIEdgeInsets)scrollRulerView:(ICXScrollRulerView *)scrollRulerView rulerInsetsOnIndex:(NSInteger)index {
    if (index % 10 == 0) {
        return UIEdgeInsetsMake(15, 0, 30, 0);
    }else if (index % 5 == 0) {
        return UIEdgeInsetsMake(15, 0, 30, 0);
    }
    return UIEdgeInsetsMake(15, 0, 45, 0);
}

// 指示器的偏移
- (UIEdgeInsets)indicateViewInsetsOfScrollRulerView:(ICXScrollRulerView *)scrollRulerView {
    return UIEdgeInsetsMake(0, 0, 30, 0);
}

// 最小刻度线宽度
- (CGFloat)minimumScaleWidthWithScrollRulerView:(ICXScrollRulerView *)scrollRulerView {
    return 0.5;
}
// 最大刻度线宽度
- (CGFloat)maximumScaleWidthWithScrollRulerView:(ICXScrollRulerView *)scrollRulerView {
    return 1;
}

// 顶部文字距离顶部间隙
- (float)scrollRulerView:(ICXScrollRulerView *)scrollRulerView topTitleSpaceOnIndex:(NSInteger)index {
    return 0;
}

// 底部文字距离底部间隙
- (float)scrollRulerView:(ICXScrollRulerView *)scrollRulerView bottomTitleSpaceOnIndex:(NSInteger)index {
    return 10;
}

@end
