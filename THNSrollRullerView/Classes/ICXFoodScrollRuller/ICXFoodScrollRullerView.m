//
//  ICXFoodScrollRullerView.m
//  ICXCommercialPR
//
//  Created by ICX_THN on 2018/7/16.
//  Copyright © 2018年 ICX. All rights reserved.
//

#define ScreenWidth  ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight  ([[UIScreen mainScreen] bounds].size.height)

#define TextColorGrayAlpha 1.0 //文字的颜色灰度
#define TextRulerFont  [UIFont systemFontOfSize:12]
#define TextRulerColor [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0]
#define RulerLineColor [UIColor colorWithRed:172/255.0 green:190/255.0 blue:212/255.0 alpha:1/1.0]

#define RulerGap        12 //单位距离
#define IndicatorLineLong       35
#define RulerLong       30
#define RulerMiddle     25
#define RulerShort      20
#define TrangleWidth    16
#define TFHeight 40
#define Margin 18
#define CollectionHeight 70

#import "ICXFoodScrollRullerView.h"

/**
 *  绘制三角形标示
 */
@interface ICXTriangleView : UIView
@property(nonatomic,strong)UIColor *triangleColor;
@property(assign,nonatomic) IndicatorViewType indicatorType;
@end
@implementation ICXTriangleView

-(void)drawRect:(CGRect)rect{
    
    if (_indicatorType==IndicatorViewTypeTriangle) {
        //设置背景颜色
        [[UIColor clearColor]set];
        
        UIRectFill([self bounds]);
        
        //拿到当前视图准备好的画板
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //利用path路径进行绘制三角形
        CGContextBeginPath(context);//标记
        
        CGContextMoveToPoint(context, 0, 0);
        
        CGContextAddLineToPoint(context, TrangleWidth, 0);
        
        CGContextAddLineToPoint(context, TrangleWidth/2.0, TrangleWidth/2.0);
        
        CGContextClosePath(context);//路径结束标志，不写默认封闭
        
        [_triangleColor setFill];//设置填充色
        [_triangleColor setStroke];//设置边框色
        
        CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path，后属性表示填充
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.indicatorType==IndicatorViewTypeTriangle) {
        self.backgroundColor = [UIColor clearColor];
    }else{
        self.backgroundColor = self.triangleColor;
    }
}
@end


/***************DY************分************割************线***********/

@interface ICXRulerView : UIView

@property (nonatomic,assign)NSInteger betweenNumber;
@property (nonatomic,assign)int originMinValue;
@property (nonatomic,assign)int minValue;
@property (nonatomic,assign)int maxValue;
@property (nonatomic,  copy)NSString *unit;
@property (nonatomic,assign)CGFloat step;

@end
@implementation ICXRulerView

-(void)drawRect:(CGRect)rect{
    CGFloat startX = 0;
    CGFloat lineCenterX = RulerGap;
    CGFloat topY = 0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);//设置线的宽度，
    CGContextSetLineCap(context,kCGLineCapButt);
    int startIndex = 0;
    int multiple = _originMinValue / _betweenNumber;
    if (_minValue==_originMinValue) {
        startIndex = _originMinValue % _betweenNumber;
        _minValue = _minValue-startIndex;
    }else{
        _minValue = _minValue-_originMinValue + (int)(multiple*_betweenNumber);
    }
    for (int i = 0; i <= (_betweenNumber-startIndex); i ++){
        CGContextMoveToPoint(context, startX+lineCenterX*i, topY);
        if (i%_betweenNumber == 0 || i==_betweenNumber-startIndex){
            NSString *num = [NSString stringWithFormat:@"%.f%@",(i+startIndex)*_step+_minValue,_unit];
            if ([num floatValue]>1000000){
                num = [NSString stringWithFormat:@"%.f万%@",[num floatValue]/10000.f,_unit];
            }
            
            NSDictionary *attribute = @{NSFontAttributeName:TextRulerFont,NSForegroundColorAttributeName:TextRulerColor};
            CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
            [num drawInRect:CGRectMake(startX+lineCenterX*i-width/2, IndicatorLineLong+10, width, 15) withAttributes:attribute];
        }
        if ((i+startIndex)%_betweenNumber == 0) {
            CGContextAddLineToPoint(context, startX+lineCenterX*i, RulerLong);
        }else if((i+startIndex)%5 == 0){
            CGContextAddLineToPoint(context, startX+lineCenterX*i, RulerMiddle);
        }else{
            CGContextAddLineToPoint(context, startX+lineCenterX*i, RulerShort);
        }
        [RulerLineColor set];
        CGContextStrokePath(context);//开始绘制
    }
}

@end


/***************DY************分************割************线***********/

@interface ICXHeaderRulerView : UIView

@property(nonatomic, assign)NSInteger       betweenNum;
@property(nonatomic,assign)int minValue;
@property(nonatomic,  copy)NSString *unit;

@end

@implementation ICXHeaderRulerView

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    CGContextMoveToPoint(context, rect.size.width, 0);
    NSString *num = [NSString stringWithFormat:@"%d%@",_minValue,_unit];
    if ([num floatValue]>1000000){
        num = [NSString stringWithFormat:@"%.f万%@",[num floatValue]/10000.f,_unit];
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:TextRulerFont,NSForegroundColorAttributeName:TextRulerColor };
    CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
    [num drawInRect:CGRectMake(rect.size.width-width/2, IndicatorLineLong+10, width, 15) withAttributes:attribute];
    //    CGContextAddLineToPoint(context,rect.size.width, lineY);
    if (_minValue%_betweenNum==0) {
        CGContextAddLineToPoint(context,rect.size.width, RulerLong);
    }else if (_minValue%_betweenNum==5) {
        CGContextAddLineToPoint(context,rect.size.width, RulerMiddle);
    }else{
        CGContextAddLineToPoint(context,rect.size.width, RulerShort);
    }
    [RulerLineColor set];
    CGContextStrokePath(context);//开始绘制
}

@end




/***************DY************分************割************线***********/
@interface ICXFooterRulerView : UIView

@property(nonatomic, assign)NSInteger       betweenNum;
@property(nonatomic,assign)int maxValue;
@property(nonatomic,  copy)NSString *unit;
@property(assign,nonatomic) CGFloat step;
@end
@implementation ICXFooterRulerView

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    CGContextMoveToPoint(context, 0, 0);//起始点
    NSString *num = [NSString stringWithFormat:@"%d%@",_maxValue,_unit];
    if ([num floatValue]>1000000) {
        num = [NSString stringWithFormat:@"%.f万%@",[num floatValue]/10000.f,_unit];
    }
    NSDictionary *attribute = @{NSFontAttributeName:TextRulerFont,NSForegroundColorAttributeName:TextRulerColor};
    CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
    [num drawInRect:CGRectMake(0-width/2, IndicatorLineLong+10, width, 15) withAttributes:attribute];
    //    CGContextAddLineToPoint(context, 0, lineY);
    if (_maxValue%_betweenNum==0 || _step<1) {
        CGContextAddLineToPoint(context, 0, RulerLong);
    }else if (_maxValue%_betweenNum==5) {
        CGContextAddLineToPoint(context, 0, RulerMiddle);
    }else{
        CGContextAddLineToPoint(context, 0, RulerShort);
    }
    [RulerLineColor set];
    CGContextStrokePath(context);//开始绘制
}

@end

/***************DY************分************割************线***********/
@interface ICXFoodScrollRullerView()<UIScrollViewDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)UITextField     *valueTF;
@property(nonatomic, strong)UILabel         *unitLab;
@property(nonatomic, strong)UICollectionView*collectionView;
@property(nonatomic, strong)UIImageView     *redLine;
@property(nonatomic, strong)ICXTriangleView  *triangle;
@property(nonatomic, assign)float           realValue;
@property(nonatomic, copy  )NSString        *unit;//单位
@property(nonatomic, assign)float           stepNum;//分多少个区
@property(nonatomic, assign)float           minValue;//游标的最小值
@property(nonatomic, assign)float           maxValue;//游标的最大值
@property(nonatomic, assign)float           step;//间隔值，每两条相隔多少值
@property(nonatomic, assign)NSInteger       betweenNum;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) CAGradientLayer *startGradientLayer;
@property (nonatomic, strong) CAGradientLayer *endGradientLayer;
@property (nonatomic, assign) CGFloat gradientWidth;
@property(assign,nonatomic) IndicatorViewType indicatorViewType;
@end
@implementation ICXFoodScrollRullerView

-(instancetype)initWithFrame:(CGRect)frame theMinValue:(float)minValue theMaxValue:(float)maxValue theStep:(float)step theUnit:(NSString *)unit theNum:(NSInteger)betweenNum gradientColorArr:(NSArray*)gradientColorArr gradientWidth:(CGFloat)gradientWidth indicatorViewType:(IndicatorViewType)indicatorViewType{
    
    self = [super initWithFrame:frame];
    if (self) {
        _minValue   = minValue;
        _maxValue   = maxValue;
        _step       = step;
        _stepNum    = (NSInteger)((_maxValue-_minValue)/_step/betweenNum+0.5);
        _unit       = unit;
        _betweenNum = betweenNum;
        _bgColor    = [UIColor whiteColor];
        _indicatorColor          = [UIColor colorWithRed:51/255.0 green:133/255.0 blue:238/255.0 alpha:1/1.0];//默认蓝色
        _indicatorViewType = indicatorViewType;
        self.backgroundColor    = [UIColor whiteColor];
        
        [self addSubview:self.valueTF];
        [self.valueTF addSubview:self.unitLab];
        [self addSubview:self.collectionView];
        [self addSubview:self.bgView];
        [self addSubview:self.triangle];
        self.unitLab.text = _unit;
        
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.valueTF resignFirstResponder];
}
-(UITextField *)valueTF{
    if (!_valueTF) {
        _valueTF                          = [[UITextField alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-100, 0,200, TFHeight)];
        _valueTF.userInteractionEnabled   = YES;
        _valueTF.defaultTextAttributes    = @{
                                              NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size:TFHeight-1],
                                              NSForegroundColorAttributeName:_indicatorColor};
        _valueTF.textAlignment            = NSTextAlignmentCenter
        ;
        _valueTF.delegate                 = self;
        _valueTF.keyboardType             = UIKeyboardTypeNamePhonePad;
    }
    return _valueTF;
}
-(UILabel *)unitLab{
    if (!_unitLab) {
        _unitLab = [[UILabel alloc]initWithFrame:CGRectMake(self.valueTF.bounds.size.width/2+40 , 0, 40, 16)];
        _unitLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _unitLab.textColor = _indicatorColor;
    }
    return _unitLab;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:self.bounds];
        _bgView.userInteractionEnabled = NO;
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.frame = self.bounds;
    }
    return _bgView;
}
-(ICXTriangleView *)triangle{
    if (!_triangle) {
        CGRect frame = CGRectMake(self.bounds.size.width/2-0.5-TrangleWidth/2, CGRectGetMaxY(_valueTF.frame)+Margin, TrangleWidth, TrangleWidth);
        if (self.indicatorViewType == IndicatorViewTypeypeLine) {
            frame = CGRectMake((self.bounds.size.width-3)/2, CGRectGetMaxY(_valueTF.frame)+Margin, 3, IndicatorLineLong);
        }
        _triangle = [[ICXTriangleView alloc]initWithFrame:frame];
        _triangle.indicatorType = self.indicatorViewType;
        _triangle.triangleColor     = _indicatorColor;
    }
    return _triangle;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_valueTF.frame)+Margin, self.bounds.size.width, CollectionHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = _bgColor;
        _collectionView.bounces         = YES;
        _collectionView.showsHorizontalScrollIndicator  = NO;
        _collectionView.showsVerticalScrollIndicator    = NO;
        _collectionView.dataSource      = self;
        _collectionView.delegate        = self;
        _collectionView.contentSize     = CGSizeMake(_stepNum*_step+ScreenWidth/2, CollectionHeight);
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"headCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"footerCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"custemCell"];
    }
    return _collectionView;
}
-(void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    _collectionView.backgroundColor = _bgColor;
}
-(void)setIndicatorColor:(UIColor *)indicatorColor{
    _indicatorColor = indicatorColor;
    _triangle.triangleColor = _indicatorColor;
}

-(void)setRealValue:(float)realValue{
    [self setRealValue:realValue animated:NO];
}
-(void)setRealValue:(float)realValue animated:(BOOL)animated{
    
    _realValue      = realValue;
    if (_step>=1) {
        _valueTF.text   = [NSString stringWithFormat:@"%.f",_realValue*_step+_minValue];
    }else{
        _valueTF.text   = [NSString stringWithFormat:@"%.1f",_realValue*_step+_minValue];
    }
    [self resetUnitFrame];
    [_collectionView setContentOffset:CGPointMake((int)realValue*RulerGap, 0) animated:animated];
}

+(CGFloat)rulerViewHeight{
    return TFHeight+Margin+CollectionHeight;
}

-(void)setDefaultValue:(float)defaultValue animated:(BOOL)animated{
    _realValue      = defaultValue;
    if (_step>=1) {
        _valueTF.text   = [NSString stringWithFormat:@"%.f",defaultValue];
    }else{
        _valueTF.text   = [NSString stringWithFormat:@"%.1f",defaultValue];
    }
    [self resetUnitFrame];
    [_collectionView setContentOffset:CGPointMake(((defaultValue-_minValue)/(float)_step)*RulerGap, 0) animated:animated];
    
}
- (void)resetUnitFrame{
    CGFloat textWidth = [self.valueTF.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine) attributes:@{NSFontAttributeName: self.valueTF.font} context:nil].size.width;
    self.unitLab.frame = CGRectMake(self.valueTF.bounds.size.width/2+textWidth/2+5, 0, 0, 0);
    [self.unitLab sizeToFit];
    [self setNeedsLayout];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newStr intValue]>_maxValue){
        _valueTF.text =  [NSString stringWithFormat:@"%.f",_maxValue];
        [self performSelector:@selector(didChangeValue) withObject:nil afterDelay:0];
        return NO;
    }else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(didChangeValue) withObject:nil afterDelay:1];
        return YES;
    }
}
-(void)didChangeValue{
    float textFieldValue = [_valueTF.text floatValue];
    if ((textFieldValue-_minValue)>=0) {
        [self setRealValue:(textFieldValue-_minValue)/(float)_step animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"少于最低值，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark UICollectionViewDataSource & Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2+_stepNum;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == 0){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        ICXHeaderRulerView *headerView = [cell.contentView viewWithTag:1000];
        if (!headerView){
            headerView = [[ICXHeaderRulerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, CollectionHeight)];
            headerView.backgroundColor  =  [UIColor whiteColor];
            headerView.tag              =  1000;
            headerView.minValue         = _minValue;
            headerView.unit             = _showBotoomUnit?_unit:@"";
            headerView.betweenNum = _betweenNum;
            [cell.contentView addSubview:headerView];
        }
        
        return cell;
    }else if( indexPath.item == _stepNum +1){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"footerCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        ICXFooterRulerView *footerView = [cell.contentView viewWithTag:1001];
        if (!footerView){
            footerView = [[ICXFooterRulerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, CollectionHeight)];
            footerView.backgroundColor  = [UIColor whiteColor];
            footerView.tag              = 1001;
            footerView.maxValue         = _maxValue;
            footerView.unit             = _showBotoomUnit?_unit:@"";
            footerView.betweenNum       = _betweenNum;
            footerView.step             = _step;
            [cell.contentView addSubview:footerView];
        }
        
        return cell;
    }else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"custemCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        ICXRulerView *rulerView = [cell.contentView viewWithTag:1002];
        if (!rulerView){
            rulerView = [[ICXRulerView alloc]initWithFrame:CGRectMake(0, 0, RulerGap*_betweenNum, CollectionHeight)];
            rulerView.tag               = 1002;
            rulerView.step              = _step;
            rulerView.unit              = _showBotoomUnit?_unit:@"";
            rulerView.betweenNumber     = _betweenNum;
            [cell.contentView addSubview:rulerView];
        }
        if(indexPath.item>=8 && indexPath.item<=12){
            rulerView.backgroundColor   =  [UIColor whiteColor];
        }else if(indexPath.item>=13 && indexPath.item<=18){
            rulerView.backgroundColor   =  [UIColor whiteColor];
        }else{
            rulerView.backgroundColor   =  [UIColor whiteColor];
        }
        if (_minValue!=0 && indexPath.item==1) {
            rulerView.frame = CGRectMake(0, 0, RulerGap*(_betweenNum-((NSInteger)_minValue %_betweenNum)), CollectionHeight);
        }else{
            rulerView.frame = CGRectMake(0, 0, RulerGap*_betweenNum, CollectionHeight);
        }
        rulerView.originMinValue = _minValue;
        rulerView.minValue = _step*(indexPath.item-1)*_betweenNum+_minValue;
        rulerView.maxValue = _step*indexPath.item*_betweenNum;
        [rulerView setNeedsDisplay];
        return cell;
    }
}

-(CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0 || indexPath.item == _stepNum+1){
        return CGSizeMake(self.frame.size.width/2, CollectionHeight);
    }else{
        if (indexPath.item==1 && _minValue!=0) {
            return CGSizeMake(RulerGap*(_betweenNum-((NSInteger)_minValue %_betweenNum)), CollectionHeight);
        }
        return CGSizeMake(RulerGap*_betweenNum, CollectionHeight);
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int value = scrollView.contentOffset.x/RulerGap;
    float totalValue = value*_step +_minValue;
    
    if (_scrollByHand) {
        if (totalValue >= _maxValue) {
            if (_step>=1) {
                _valueTF.text = [NSString stringWithFormat:@"%.f",_maxValue];
            }else{
                _valueTF.text = [NSString stringWithFormat:@"%.1f",_maxValue];
            }
        }else if(totalValue <= _minValue){
            if (_step>=1) {
                _valueTF.text = [NSString stringWithFormat:@"%.0f",_minValue];
            }else{
                _valueTF.text = [NSString stringWithFormat:@"%.1f",_minValue];
            }
        }else{
            if (_step>=1) {
                _valueTF.text = [NSString stringWithFormat:@"%.f",value*_step +_minValue];
            }else{
                _valueTF.text = [NSString stringWithFormat:@"%.1f",value*_step +_minValue];
            }
        }
        [self resetUnitFrame];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dyScrollRulerView:valueChange:)]) {
        [self.delegate dyScrollRulerView:self valueChange:totalValue];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{//拖拽时没有滑动动画
    if (!decelerate){
        [self setRealValue:round(scrollView.contentOffset.x/(RulerGap)) animated:YES];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self setRealValue:round(scrollView.contentOffset.x/(RulerGap)) animated:YES];
}

@end
