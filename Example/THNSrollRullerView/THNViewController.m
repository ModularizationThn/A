//
//  THNViewController.m
//  THNSrollRullerView
//
//  Created by TPQuietBro on 07/17/2018.
//  Copyright (c) 2018 TPQuietBro. All rights reserved.
//

#import "THNViewController.h"
#import "ICXFoodScrollRullerView.h"

#define ScreenWidth  ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight  ([[UIScreen mainScreen] bounds].size.height)

@interface THNViewController ()
/**
 *************************** maxValue为10000时,照样很顺畅,运用了collectionView的复用机制 ***************************
 */
@property(nonatomic,strong)ICXFoodScrollRullerView *rullerView;
@property(nonatomic,strong)ICXFoodScrollRullerView *timeRullerView;
@property(nonatomic,strong)ICXFoodScrollRullerView *noneZeroRullerView;
@end

@implementation THNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.rullerView];
    [self.view addSubview:self.timeRullerView];
    [self.view addSubview:self.noneZeroRullerView];
}

-(ICXFoodScrollRullerView *)rullerView{
    if (!_rullerView) {
        CGFloat rullerHeight = [ICXFoodScrollRullerView rulerViewHeight];
        _rullerView = [[ICXFoodScrollRullerView alloc]initWithFrame:CGRectMake(10, ScreenHeight/5.0*0.5+20, ScreenWidth-20, rullerHeight) theMinValue:1 theMaxValue:10000 theStep:1 theUnit:@"克" theNum:10 gradientColorArr:@[[UIColor whiteColor], [UIColor colorWithWhite:1 alpha:0]] gradientWidth:100 indicatorViewType:IndicatorViewTypeypeLine];
        [_rullerView setDefaultValue:100 animated:YES];
        _rullerView.bgColor = [UIColor whiteColor];
        _rullerView.delegate        = self;
        _rullerView.scrollByHand    = YES;
        _rullerView.showBotoomUnit = NO;
    }
    return _rullerView;
}


-(ICXFoodScrollRullerView *)timeRullerView{
    if (!_timeRullerView) {
        NSString *unitStr = @"";
        CGFloat rullerHeight = [ICXFoodScrollRullerView rulerViewHeight];
        _timeRullerView = [[ICXFoodScrollRullerView alloc]initWithFrame:CGRectMake(5, ScreenHeight/5.0*2, ScreenWidth-20, rullerHeight) theMinValue:0 theMaxValue:23  theStep:0.2 theUnit:unitStr theNum:5 gradientColorArr:@[[UIColor whiteColor], [UIColor colorWithWhite:1 alpha:0]] gradientWidth:100 indicatorViewType:IndicatorViewTypeTriangle];
        [_timeRullerView setDefaultValue:2 animated:YES];
        _timeRullerView.bgColor = [UIColor orangeColor];
        _timeRullerView.indicatorColor   = [UIColor redColor];
        _timeRullerView.delegate        = self;
        _timeRullerView.scrollByHand    = YES;
    }
    return _timeRullerView;
}


-(ICXFoodScrollRullerView *)noneZeroRullerView{
    if (!_noneZeroRullerView) {
        NSString *unitStr = @"";
        CGFloat rullerHeight = [ICXFoodScrollRullerView rulerViewHeight];
        _noneZeroRullerView = [[ICXFoodScrollRullerView alloc]initWithFrame:CGRectMake(5, ScreenHeight/5.0*3.5, ScreenWidth-20, rullerHeight) theMinValue:20 theMaxValue:200  theStep:1 theUnit:unitStr theNum:5 gradientColorArr:@[[UIColor whiteColor], [UIColor colorWithWhite:1 alpha:0]] gradientWidth:100 indicatorViewType:IndicatorViewTypeTriangle];
        [_noneZeroRullerView setDefaultValue:50 animated:YES];
        _noneZeroRullerView.bgColor = [UIColor orangeColor];
        _noneZeroRullerView.indicatorColor   = [UIColor redColor];
        _noneZeroRullerView.delegate        = self;
        _noneZeroRullerView.scrollByHand    = YES;
    }
    return _noneZeroRullerView;
}
#pragma mark - YKScrollRulerDelegate
-(void)dyScrollRulerView:(ICXFoodScrollRullerView *)rulerView valueChange:(float)value{
    
      NSLog(@"value->%.f",value);
}

@end
