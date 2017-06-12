//
//  UILabel+RowColumnSpace.m
//  SAPublicModule
//
//  Created by 李磊 on 12/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "UILabel+RowColumnSpace.h"
#import <CoreText/CoreText.h>

@implementation UILabel (RowColumnSpace)

- (void)setColumnSpace:(CGFloat)columnSpace{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    //调整间距
    [attributedString addAttribute:(__bridge NSString*)kCTKernAttributeName  value:@(columnSpace) range:NSMakeRange(0, [attributedString length])];
    self.attributedText = attributedString;
}

- (void)setRowSpace:(CGFloat)rowSpace{
    self.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    //调整行距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = rowSpace;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}

@end
