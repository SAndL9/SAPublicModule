//
//  SACustomAlertView.m
//  SAPublicModule
//
//  Created by 李磊 on 13/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "SACustomAlertView.h"
static const NSInteger buttonHeight = 40;
static const NSInteger height  = 40;
static const NSInteger alertViewWidth = 243;
static const NSInteger space = 12;


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation SACustomAlertView

- ( instancetype )initWithFrame:(CGRect)frame withMessage:(NSMutableString *)messageString{
  
    if ([super initWithFrame:frame]) {
        
        _customAlertView = [[UIView alloc] init];
        [self addSubview:_customAlertView];
        
        //算高
        CGRect messageR = [messageString boundingRectWithSize:CGSizeMake(alertViewWidth - 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil];
        NSInteger alertViewHeight = messageR.size.height + buttonHeight + space * 5 + height;
        
        _customAlertView.layer.cornerRadius = 10.0;
        _customAlertView.center = self.center;
        _customAlertView.frame = CGRectMake((ScreenWidth - alertViewWidth)/2, (ScreenHeight - alertViewHeight)/2, alertViewWidth, alertViewHeight);
        _customAlertView.backgroundColor = [UIColor whiteColor];
        
        //提示文字
        _titleLabel = [[UILabel alloc] init];
        [_customAlertView addSubview:_titleLabel];
        _titleLabel.text = @"提示";
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:15];
        _titleLabel.textColor = UIColorFromRGB(0x73C0BC);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, alertViewWidth, height);
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), _customAlertView.bounds.size.width, 1)];
        [_customAlertView addSubview:lineView];
        lineView.backgroundColor = UIColorFromRGB(0x73C0BC);
        
        //显示文字
        _messageLabel = [[UILabel alloc] init];
        [_customAlertView addSubview:_messageLabel];
        _messageLabel.textColor = UIColorFromRGB(0x666666);
        _messageLabel.font = [UIFont systemFontOfSize:12];
        _messageLabel.text = messageString;
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.numberOfLines = 0;//最多显示Message行数
        
        
        _messageLabel.frame = CGRectMake(12, CGRectGetMaxY(_titleLabel.frame) + space, _customAlertView.frame.size.width - 24, messageR.size.height);
        
        //是否选择不提示
        _selectPromptButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_messageLabel.frame) + space , _customAlertView.frame.size.width - 40, 20)];
        [_customAlertView addSubview:_selectPromptButton];
        [_selectPromptButton setImage:[UIImage imageNamed:@"矩形-33"] forState:UIControlStateNormal];
        [_selectPromptButton setTitle:@"记住我的选择，下次不再提示" forState:UIControlStateNormal];
        [_selectPromptButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        _selectPromptButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _selectPromptButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
        _selectPromptButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [_selectPromptButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //创建中间灰色分割线
        UIView * separateBottomLine = [[UIView alloc] init];
        separateBottomLine.backgroundColor = [UIColor colorWithRed:153.f/255 green:153.f/255 blue:153.f/255 alpha:1];
        [_customAlertView addSubview:separateBottomLine];
        separateBottomLine.frame = CGRectMake(0, CGRectGetMaxY(_selectPromptButton.frame) + space , _customAlertView.bounds.size.width, 0.5);
        
        //取消button
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(separateBottomLine.frame)  , _customAlertView.frame.size.width / 2, buttonHeight)];
        [_customAlertView addSubview:_cancelButton];
        [_cancelButton setTitleColor:[UIColor colorWithRed:16.f/255 green:123.f/255 blue:251.f/255 alpha:1] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        _cancelButton.tag = 0;
        [_cancelButton addTarget:self action:@selector(didClickBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBezierPath *cancelmaskPath = [UIBezierPath bezierPathWithRoundedRect:_cancelButton.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *cancelmaskLayer = [[CAShapeLayer alloc] init];
        cancelmaskLayer.frame = _cancelButton.bounds;
        cancelmaskLayer.path = cancelmaskPath.CGPath;
        _cancelButton.layer.mask = cancelmaskLayer;
        
        //接受button
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(_customAlertView.bounds.size.width/2, CGRectGetMaxY(separateBottomLine.frame) , _customAlertView.frame.size.width / 2, buttonHeight)];
        [_customAlertView addSubview:_sureButton];
        _sureButton.tag = 1;
        [_sureButton setTitleColor:[UIColor colorWithRed:16.f/255 green:123.f/255 blue:251.f/255 alpha:1] forState:UIControlStateNormal];
        [_sureButton setTitle:@"接受" forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_sureButton setBackgroundColor:[UIColor whiteColor]];
        [_sureButton addTarget:self action:@selector(didClickBtnConfirm:) forControlEvents:UIControlEventTouchUpInside];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_sureButton.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _sureButton.bounds;
        maskLayer.path = maskPath.CGPath;
        _sureButton.layer.mask = maskLayer;
        
        //创建中间灰色分割线
        UIView * mLine = [[UIView alloc] init];
        mLine.backgroundColor = [UIColor grayColor];
        [_customAlertView addSubview:mLine];
        mLine.frame = CGRectMake(_customAlertView.bounds.size.width / 2,  CGRectGetMaxY(separateBottomLine.frame), 0.5, buttonHeight);
        
        
        
    }
    return self;
    
}


- (void) selectButtonClicked:(UIButton *)btn{
    NSLog(@"记住我的选择");
    btn.selected = !btn.selected;
    if (!btn.selected) {
        [btn setImage:[UIImage imageNamed:@"矩形-33"] forState:UIControlStateNormal];
        
    }else{
        [btn setImage:[UIImage imageNamed:@"矩形-34"] forState:UIControlStateNormal];
    }
}

- (void) didClickBtnCancel:(UIButton *)btn {
    [self.delegate ButtonDidClickedWithCancleOrSure:@"cancle" IsRemberMyChose:NO];
    [_customAlertView removeFromSuperview];
    [self removeFromSuperview];
}

- (void) didClickBtnConfirm:(UIButton *)btn {
    
    if (_selectPromptButton.selected) {
        [self.delegate ButtonDidClickedWithCancleOrSure:@"confirm" IsRemberMyChose:YES];
    }else{
        [self.delegate ButtonDidClickedWithCancleOrSure:@"confirm" IsRemberMyChose:NO];
    }
    [_customAlertView removeFromSuperview];
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
