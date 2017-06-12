//
//  SAPlaceholderLabelTextView.h
//  SmallAnimal
//
//  Created by lilei on 17/11/16.
//  Copyright © 2016年 浙江网仓科技有限公司. All rights reserved.
// 封装textView

#import <UIKit/UIKit.h>

/**
 带 placeholder 的 textView
 */
@interface SAPlaceholderLabelTextView : UITextView

/**
 占位文字
 */
@property (nonatomic, copy) NSString * placeholder;

/**
 占位文字颜色
 */
@property (nonatomic, strong) UIColor * placeholderColor;

@end
