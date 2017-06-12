//
//  SAPageViewController.h
//  SAPageViewController
//
//  Created by 李磊 on 9/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidEndSelectedAddress)(NSString *address);

typedef NS_ENUM(NSInteger,SATopViewItemScrollPosition) {
    
    SATopViewItemScrollPositionMiddle,      //  默认值
    SATopViewItemScrollPositionleftOrRight,
};
@class SAPageViewController;

@protocol SAPageViewControllerDelegate <NSObject>

- (void)ViewController:(UIViewController* )viewcontroller atIndex:(NSInteger)index;

@end


@interface SAPageViewController : UIViewController

/*! 顶部视图上按钮普通状态的颜色 */
@property (nonatomic,strong) UIColor *topViewItemTitleNormalColor;
/*! 顶部视图上按钮选中状态的颜色 */
@property (nonatomic,strong) UIColor *topViewItemTitleSelectedColor;
/*! 顶部视图上选中状态横线的颜色 */
@property (nonatomic,strong) UIColor *lineColor;
/*! 顶部视图上按钮的宽度 */
@property (nonatomic,assign) CGFloat topViewItemWidth;      //  默认65
/*! 整个PageView视图上方的间距 */
@property (nonatomic,assign) CGFloat topMargin;             //  默认为0
@property (nonatomic,assign) CGFloat topViewRightMargin;    //  默认为0
@property (nonatomic,assign) CGFloat topViewLeftMargin;     //  默认为0
@property (nonatomic,assign) CGFloat topViewHeight;         //  默认41
/*! 下方的视图与顶部视图的间距 */
@property (nonatomic,assign) CGFloat pageViewTopMargin;     //  默认25
@property (nonatomic,assign) SATopViewItemScrollPosition scrollPosition;

@property (nonatomic,assign) NSUInteger currentSelectedIndex;
@property (nonatomic,strong) NSArray <UIViewController *> *viewControllers;
@property (nonatomic, strong) NSArray <NSString *> *pageTitles;
/*! 存储地址 */
@property (nonatomic, strong) NSMutableArray <NSArray *>*areaArray;
@property (nonatomic,copy) DidEndSelectedAddress didEndSelectedAddress;
@property (nonatomic,weak)id <SAPageViewControllerDelegate> delegate;

- (instancetype)initWithViewControllers:(NSArray <UIViewController *> *)viewControllers;

- (void)addPageViewController:(UIViewController *)pageViewController pageTitle:(NSString *)pageTitle currentPageTitle:(NSString *)currentPageTitle;

- (void)replaceCurrentPageTitleWithTitle:(NSString *)title;

- (void)deletePageFromIndex:(NSInteger)index;

- (void)setDidEndSelectedAddress:(DidEndSelectedAddress)didEndSelected;

@end


@interface UIViewController (SAPageViewController)

@property (nonatomic,strong) SAPageViewController *pageViewController;

@property (nonatomic,assign) NSInteger index;

@end
