
//  SATopScrollView.h
//  SATopScrollView
//
//  Created by 李磊 on 9/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAScrollItem : UIView

@property (nonatomic,strong) UIButton *button;

- (void)setTitle:(NSString *)title;

@end

@protocol SATopScrollViewDataSource;

@interface SATopScrollView : UIScrollView

@property (nonatomic,assign) CGFloat itemWidth;
@property (nonatomic,assign) CGFloat itemHeight;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,assign) id<SATopScrollViewDataSource> dataSource;

- (void)setScrollItemNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor lineColor:(UIColor *)lineColor;

- (void)setSelectedIndex:(NSInteger)selectedIndex withScrollToLeftOrRightVisiableAnimate:(BOOL)animate;
- (void)setSelectedIndex:(NSInteger)selectedIndex withScrollToMiddleVisiableAnimate:(BOOL)animate;
//- (void)setLineContentOffset:(CGFloat)contextOffset;

- (void)reloadTopScrollView;

@end

@protocol SATopScrollViewDataSource <NSObject>

- (NSInteger)numberOfItemInTopScrollView:(SATopScrollView *)topScrollView;

- (SAScrollItem *)topScrollView:(SATopScrollView *)topScrollView itemForRowIndex:(NSInteger)index;
@optional
- (void)topScrollView:(SATopScrollView *)topScrollView didSelectedItemAtIndex:(NSInteger)index;

@end
