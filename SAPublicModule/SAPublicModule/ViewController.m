//
//  ViewController.m
//  SAPublicModule
//
//  Created by 李磊 on 9/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "ViewController.h"
#import "SAPageViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"

@interface ViewController () <SAPageViewControllerDelegate>

@property (nonatomic, strong)OneViewController *oneVC;

@property (nonatomic, strong)TwoViewController *twoVC;

@property (nonatomic, strong)ThreeViewController *threeVC;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubviews];
}


#pragma mark----

- (void)createSubviews{
    SAPageViewController *pageViewController = [[SAPageViewController alloc]init];
    _oneVC = [OneViewController new];
    _twoVC = [TwoViewController new];
    _threeVC = [ThreeViewController new];
    pageViewController.pageTitles = @[@"首页",@"视频",@"主页"];
    pageViewController.viewControllers = @[_oneVC,_twoVC,_threeVC];
    pageViewController.scrollPosition = SATopViewItemScrollPositionMiddle;
    pageViewController.pageViewTopMargin = 0;
    pageViewController.topViewItemTitleNormalColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    pageViewController.topViewItemTitleSelectedColor = pageViewController.lineColor = [UIColor colorWithRed:0/255.0 green:148/255.0 blue:246/255.0 alpha:1.0];
    pageViewController.topViewItemWidth = (CGRectGetWidth(self.view.frame)-60)/3.0;
    pageViewController.currentSelectedIndex = 0;
    pageViewController.delegate = self;
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    pageViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height );
    

}

- (void)ViewController:(UIViewController *)viewcontroller atIndex:(NSInteger)index{
//    NSArray *arr = @[ _oneVC,_twoVC,_threeVC];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
