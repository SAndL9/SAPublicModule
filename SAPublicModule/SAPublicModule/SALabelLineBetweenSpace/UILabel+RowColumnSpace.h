//
//  UILabel+RowColumnSpace.h
//  SAPublicModule
//
//  Created by 李磊 on 12/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (RowColumnSpace)

/**
 设置字间距
 
 @param columnSpace 间距
 */
- (void)setColumnSpace:(CGFloat)columnSpace;



/**
 设置行距
 
 @param rowSpace 行距
 */
- (void)setRowSpace:(CGFloat)rowSpace;

@end
