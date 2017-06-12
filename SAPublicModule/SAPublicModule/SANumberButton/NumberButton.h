//
//  NumberButton.h
//  加减输入框按钮
//
//  Created by lilei on 4/1/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumberButtonDelegate <NSObject>

@optional
- (void)NumberButton:(UIView *)numberButton number:(NSString *)number;


@end


@interface NumberButton : UIView

/** 加减按钮的回调*/
@property (nonatomic, copy) void(^numberBlock)(NSString *number);

/** 代理*/
@property (nonatomic, weak) id<NumberButtonDelegate> delegate;


/** 设置边框的颜色,如果没有设置颜色,就没有边框*/
@property (nonatomic, strong) UIColor *borderColor;

/* 设置最大值*/
@property (nonatomic, assign) NSInteger maxNumber;

/** 是否开启旋转动画,默认NO*/
@property (nonatomic, assign, getter=isShakeAnimation) BOOL shakeAnimation;

#pragma mark - 注意:加减号按钮的标题和背景图片只能设置其中一个,若全部设置,则以最后设置的类型为准

/** 字体大小*/
@property (nonatomic, strong) UIFont *font;
/**
 *  设置加/减按钮的标题
 *
 *  @param increaseTitle 加按钮标题
 *  @param decreaseTitle 减按钮标题
 */
- (void)setTitleWithIncreaseTitle:(NSString *)increaseTitle decreaseTitle:(NSString *)decreaseTitle;

/**
 *  设置加/减按钮的背景图片
 *
 *  @param increaseImage 加按钮背景图片
 *  @param decreaseImage 减按钮背景图片
 */
- (void)setImageWithincreaseImage:(UIImage *)increaseImage decreaseImage:(UIImage *)decreaseImage;


@end
