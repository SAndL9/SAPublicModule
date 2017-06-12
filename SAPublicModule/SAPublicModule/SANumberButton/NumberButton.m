//
//  NumberButton.m
//  加减输入框按钮
//
//  Created by lilei on 4/1/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "NumberButton.h"

@interface NumberButton ()<UITextFieldDelegate>

/** 减按钮*/
@property (nonatomic, strong) UIButton *decreaseBtn;
/** 加按钮*/
@property (nonatomic, strong) UIButton *increaseBtn;
/** 数量展示/输入框*/
@property (nonatomic, strong) UITextField *textField;
/** 快速加减定时器*/
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation NumberButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
        self.frame = frame;
    }
    return self;
}
#pragma mark - UI布局
- (void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3.f;
    self.clipsToBounds = YES;
    //整个控件的默认尺寸(和某宝上面的按钮同样大小)
    self.frame = CGRectMake(0, 0, 110, 30);
    
    //减,加按钮
    _decreaseBtn = [self setupButtonWithTitle:@"－"];
    _increaseBtn = [self setupButtonWithTitle:@"＋"];
    
    //数量展示/输入框
    _textField = [[UITextField alloc] init];
    _textField.text = @"1";
    _textField.delegate = self;
    _textField.font = [UIFont boldSystemFontOfSize:15];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self addSubview:_textField];
    
    [self setFrame:self.frame];
    
}
//设置控件Frame
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    //加减按钮为正方形
    CGFloat height = self.frame.size.height;
    CGFloat width =  self.frame.size.width;
    _decreaseBtn.frame = CGRectMake(0, 0, height, height);
    _increaseBtn.frame = CGRectMake(width - height, 0, height, height);
    _textField.frame = CGRectMake(height, 0, width - height * 2, height);
}

//设置加减按钮的公共方法
- (UIButton *)setupButtonWithTitle:(NSString *)text
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel];
    [self addSubview:button];
    return button;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text.length == 0 || textField.text.integerValue <= 0 ? _textField.text = @"1" : nil;
    
    if ([textField.text integerValue] < _maxNumber) {
        
    }else{
        textField.text = [NSString stringWithFormat:@"%ld",(long)_maxNumber - 1];
    }
    _numberBlock ? _numberBlock(_textField.text) : nil;
    _delegate ? [_delegate NumberButton:self number:_textField.text] : nil;
}

#pragma mark - 加减按钮点击响应
//单击逐次加减,长按连续加减
- (void)touchDown:(UIButton *)sender
{
    [_textField resignFirstResponder];
    
    if (sender == _increaseBtn) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(increase) userInfo:nil repeats:YES];
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(decrease) userInfo:nil repeats:YES];
    }
    [_timer fire];
}

- (void)touchUp:(UIButton *)sender
{
    [self cleanTimer];
}

//加
- (void)increase
{
    _textField.text.length == 0 ? _textField.text = @"1" : nil;
    NSInteger number = [_textField.text integerValue] + 1;
    if (number < _maxNumber) {
        _textField.text = [NSString stringWithFormat:@"%ld", number];
        
        _numberBlock ? _numberBlock(_textField.text) : nil;
        _delegate ? [_delegate NumberButton:self number:_textField.text] : nil;

    }else{
      _shakeAnimation ? [self shakeAnimation] : nil;  
    }
    
    
}

//减
- (void)decrease
{
    _textField.text.length == 0 ? _textField.text = @"1" : nil;
    NSInteger number = [_textField.text integerValue] - 1;
    if (number > 0)
    {
        _textField.text = [NSString stringWithFormat:@"%ld", number];
        
        _numberBlock ? _numberBlock(_textField.text) : nil;
        _delegate ? [_delegate NumberButton:self number:_textField.text] : nil;
    }
    else
    {
        _shakeAnimation ? [self shakeAnimation] : nil;

    }
}

- (void)cleanTimer
{
    if (_timer.isValid)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)dealloc
{
    [self cleanTimer];
}

#pragma mark - 加减按钮的属性设置

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = [borderColor CGColor];
    _decreaseBtn.layer.borderColor = [borderColor CGColor];
    _increaseBtn.layer.borderColor = [borderColor CGColor];
    
    self.layer.borderWidth = 0.5;
    _decreaseBtn.layer.borderWidth = 0.5;
    _increaseBtn.layer.borderWidth = 0.5;
}

- (void)setFont:(UIFont *)font
{
    _increaseBtn.titleLabel.font = font;
    _decreaseBtn.titleLabel.font = font;
}

- (void)setTitleWithIncreaseTitle:(NSString *)increaseTitle decreaseTitle:(NSString *)decreaseTitle
{
    [_increaseBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [_decreaseBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [_increaseBtn setTitle:increaseTitle forState:UIControlStateNormal];
    [_decreaseBtn setTitle:decreaseTitle forState:UIControlStateNormal];
}

- (void)setImageWithincreaseImage:(UIImage *)increaseImage decreaseImage:(UIImage *)decreaseImage
{
    [_increaseBtn setTitle:@"" forState:UIControlStateNormal];
    [_decreaseBtn setTitle:@"" forState:UIControlStateNormal];
    
    [_increaseBtn setBackgroundImage:increaseImage forState:UIControlStateNormal];
    [_decreaseBtn setBackgroundImage:decreaseImage forState:UIControlStateNormal];
}

#pragma mark - 抖动动画
- (void)shakeAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    //获取当前View的position坐标
    CGFloat positionX = self.layer.position.x;
    //设置抖动的范围
    animation.values = @[@(positionX-10),@(positionX),@(positionX+10)];
    //动画重复的次数
    animation.repeatCount = 3;
    //动画时间
    animation.duration = 0.07;
    //设置自动反转
    animation.autoreverses = YES;
    [self.layer addAnimation:animation forKey:nil];
}

@end
