//
//  SATopScrollView.m
//  SATopScrollView
//
//  Created by 李磊 on 9/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "SATopScrollView.h"
#import <Masonry/Masonry.h>


@implementation SAScrollItem

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:button];
        _button = button;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self);
//            make.centerX.equalTo(self.mas_centerX);
//            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    [self.button setTitle:title forState:UIControlStateNormal];
    [self.button setTitle:title forState:UIControlStateSelected];
}

@end


@interface SATopScrollView ()<UIScrollViewDelegate>

@property (nonatomic,assign,getter=getNumberOfItem) NSInteger numberOfItem;
@property (nonatomic,strong) UIButton *selectedItem;
@property (nonatomic,assign) NSInteger selectedIndex;

@property (nonatomic,strong) UIColor *itemNormalColor;
@property (nonatomic,strong) UIColor *itemSelectedColor;
@property (nonatomic,strong) UIColor *lineColor;

@property (nonatomic, strong) UIView *bgLineView;

@end

@implementation SATopScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedIndex = 0;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        _selectedIndex = 0;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
    }
    return self;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView  = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor orangeColor];
    }
    return _lineView;
}

- (void)reloadTopScrollView{
    [self removeAllItems];
    CGFloat itemHeight = self.itemHeight;
    NSInteger count = [self getNumberOfItem];
    for (int i = 0; i<count; i++) {
        SAScrollItem *item = nil;
        if ([self.dataSource respondsToSelector:@selector(topScrollView:itemForRowIndex:)]) {
            item = [self.dataSource topScrollView:self itemForRowIndex:i];
        }else{
            item = [[SAScrollItem alloc] init];
        }
        item.frame = CGRectMake(i*self.itemWidth+15.0, 0, self.itemWidth, itemHeight);
        item.tag = i;
        
        if (self.itemNormalColor) [item.button setTitleColor:self.itemNormalColor forState:UIControlStateNormal];
        if (self.itemSelectedColor) [item.button setTitleColor:self.itemSelectedColor forState:UIControlStateSelected];
        
        [self addSubview:item];
        if (i == _selectedIndex) {
            self.selectedIndex = i;
        }
        [item.button addTarget:self action:@selector(didClickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    }
    self.contentSize = CGSizeMake(self.itemWidth * count , itemHeight);
    [self addBackgroundLine];
    [self setLineViewFrameWithItem:(SAScrollItem *)_selectedItem.superview animate:NO];
    if (self.lineColor) self.lineView.backgroundColor = self.lineColor;
    [self bringSubviewToFront:self.lineView];
}

- (void)addBackgroundLine{
    
    [self addSubview:self.bgLineView];
    [self addSubview:self.lineView];
}

- (void)removeAllItems{
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
//        if ([obj isKindOfClass:[SAScrollItem class]]) {
            [obj removeFromSuperview];
//        }
    }];
}

- (void)layoutSubviews{
    
    self.bgLineView.frame = CGRectMake(0, _itemHeight-1, CGRectGetWidth(self.frame), 1);
}

- (void)didClickItem:(UIButton *)button{
    
    [self setSelectedIndex:button.superview.tag withScrollToMiddleVisiableAnimate:YES];
    if ([self.dataSource respondsToSelector:@selector(topScrollView:didSelectedItemAtIndex:)]) {
        [self.dataSource topScrollView:self didSelectedItemAtIndex:button.superview.tag];
    }
}

#pragma mark-
#pragma mark- setter and getter
- (UIView *)bgLineView{
    if (!_bgLineView) {
        _bgLineView = [UIView new];
        _bgLineView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
//        lineView.frame = CGRectMake(0, _itemHeight-1, 3*_itemWidth+30, 1);
    }
    return _bgLineView;
}

- (SAScrollItem *)scrollItemAtIndex:(NSInteger)index{
    for (SAScrollItem *item in self.subviews) {
        if ([item isKindOfClass:[SAScrollItem class]]&&(item.tag == index)) {
            return item;
        }
    }
    return nil;
}

//- (void)setLineContentOffset:(CGFloat)contextOffset{
//    
//    CGRect rect = self.lineView.frame;
//    
//    rect.origin.x+=_itemWidth*contextOffset/CGRectGetWidth(self.superview.frame);
//    self.lineView.frame = rect;
//}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    _selectedItem.selected = NO;
    _selectedItem = [self scrollItemAtIndex:selectedIndex].button;
    _selectedItem.selected = YES;    
}

- (void)setLineViewFrameWithItem:(SAScrollItem *)item animate:(BOOL)animate{
    if (!animate) {
        self.lineView.frame = CGRectMake(item.frame.origin.x, item.frame.size.height-2, item.frame.size.width, 2);
        return;
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.lineView.frame = CGRectMake(item.frame.origin.x, item.frame.size.height-2, item.frame.size.width, 2);
    } completion:nil];
}

- (void)setDataSource:(id<SATopScrollViewDataSource>)dataSource{
    _dataSource = dataSource;
    [self reloadTopScrollView];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex withScrollToLeftOrRightVisiableAnimate:(BOOL)animate{
    
    UIButton *button = [self scrollItemAtIndex:selectedIndex].button;
    CGPoint point = [self convertPoint:button.superview.frame.origin toView:[[UIApplication sharedApplication].delegate window]];
    //    NSLog(@"%@",NSStringFromCGPoint(point));
    
    CGFloat widthScreen = CGRectGetWidth(self.frame);
    
    if (point.x<0) {
        [self setContentOffset:CGPointMake(self.contentOffset.x + point.x-CGRectGetMinX(self.frame), 0) animated:animate];
    }else if (point.x>=0&&point.x<=widthScreen-_itemWidth){
        
    }else{
        
        [self setContentOffset:CGPointMake(self.contentOffset.x + _itemWidth + point.x - widthScreen-CGRectGetMinX(self.frame), 0) animated:animate];
    }
    
    self.selectedIndex = selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex withScrollToMiddleVisiableAnimate:(BOOL)animate{
    
//    UIButton *button = [self scrollItemAtIndex:selectedIndex].button;
    //    NSLog(@"%@",NSStringFromCGPoint(point));
//    CGPoint point = [self convertPoint:button.superview.frame.origin toView:[[UIApplication sharedApplication].delegate window]];
//    CGFloat widthScreen = CGRectGetWidth([UIScreen mainScreen].bounds);
//    
//    CGFloat leftSpace = (1+selectedIndex)*_itemWidth-_itemWidth/2.0;
//    CGFloat rightSpace = (self.numberOfItem-selectedIndex-1)*_itemWidth+_itemWidth/2.0;
//    
//    CGFloat leftMarginLeftSpace = widthScreen/2.0-CGRectGetMinX(self.frame);
//    CGFloat rightMarginLeftSpace =  widthScreen/2.0-(widthScreen-CGRectGetWidth(self.frame));
//    
//    if (leftSpace <= leftMarginLeftSpace) {
//        
//        [self setContentOffset:CGPointMake(0, 0) animated:YES];
//    }else if (leftSpace>leftMarginLeftSpace&&rightSpace>rightMarginLeftSpace){
//
//        [self setContentOffset:CGPointMake(self.contentOffset.x+point.x-widthScreen/2.0+_itemWidth/2, 0) animated:YES];
//    }else if(rightSpace<rightMarginLeftSpace&&leftSpace>leftMarginLeftSpace&&(CGRectGetWidth(self.frame)-_itemWidth*(selectedIndex+1))<_itemWidth){
//        
//        [self setContentOffset:CGPointMake(self.contentSize.width-CGRectGetWidth(self.frame), 0) animated:YES];
//    }
    
    self.selectedIndex = selectedIndex;
}

- (void)setScrollItemNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor lineColor:(UIColor *)lineColor{
    self.itemNormalColor= normalColor;
    self.itemSelectedColor = selectedColor;
    self.lineColor = lineColor;
}

- (NSInteger)getNumberOfItem{
    if ([self.dataSource respondsToSelector:@selector(numberOfItemInTopScrollView:)]) {
        return [self.dataSource numberOfItemInTopScrollView:self];
    }
    return 0;
}

@end
