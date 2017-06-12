//
//  SAPageViewController.m
//  SAPageViewController
//
//  Created by 李磊 on 9/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "SAPageViewController.h"
#import "SATopScrollView.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>


@interface SAPageViewController ()<SATopScrollViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) SATopScrollView *topScrollView;
@property (nonatomic,strong) UIScrollView *pageScrollView;

//@property (nonatomic,assign,readwrite) NSUInteger currentSelectedIndex;

@end

@implementation SAPageViewController

- (instancetype)initWithViewControllers:(NSArray <UIViewController *> *)viewControllers{
    self = [super init];
    if (self) {
        self.viewControllers = viewControllers;
        [self initMethod];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initMethod];
    }
    return self;
}

- (void)initMethod{
    _topMargin = 0;
    _pageViewTopMargin = 25.0;
    _topViewRightMargin = 15.0;
    _topViewLeftMargin = 15.0;
    _scrollPosition = SATopViewItemScrollPositionMiddle;
    _topViewItemWidth = 65.0;
    _topViewHeight = 41.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupSubviews];
}

- (void)setupSubviews{
    
    [self.view addSubview:self.topScrollView];
    [self.view addSubview:self.pageScrollView];

    [self.topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.view).offset(-self.topViewRightMargin);
        make.top.equalTo(@20);
        make.leading.equalTo(self.view).offset(_topViewLeftMargin);
        make.height.equalTo(@(_topViewHeight));
    }];
//    NSLog(@"%@",NSStringFromCGRect(self.topScrollView.frame));
    
    [_pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //            make.edges.equalTo(self.view);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.topScrollView.mas_bottom).offset(self.pageViewTopMargin);
    }];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.pageScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*self.viewControllers.count, CGRectGetHeight(self.pageScrollView.frame));
    
    
    for (int i = 0; i<self.viewControllers.count; i++) {
        UIViewController *viewController = self.viewControllers[i];
        
        [self addChildViewController:viewController];
        viewController.view.frame = CGRectMake(i*CGRectGetWidth(self.view.frame), self.topMargin, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-_topViewHeight-20.0-_pageViewTopMargin);
        viewController.pageViewController = self;
        [self.pageScrollView addSubview:viewController.view];
        if (self.currentSelectedIndex == i){
            [self.pageScrollView setContentOffset:CGPointMake(i*CGRectGetWidth(self.view.frame), 0)];
            [self.topScrollView setSelectedIndex:i withScrollToMiddleVisiableAnimate:NO];
        }
    }
}

- (void)addPageViewController:(UIViewController *)pageViewController pageTitle:(NSString *)pageTitle currentPageTitle:(NSString *)currentPageTitle{
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.pageScrollView.frame);
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    [viewControllers addObject:pageViewController];
    self.viewControllers = viewControllers;
    
    NSMutableArray *pageTitles = [NSMutableArray arrayWithArray:self.pageTitles];
    [pageTitles replaceObjectAtIndex:pageTitles.count-1 withObject:currentPageTitle];
    [pageTitles addObject:pageTitle];
    self.pageTitles = pageTitles;
    [self.topScrollView reloadTopScrollView];
    
    self.pageScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*self.viewControllers.count, CGRectGetHeight(self.pageScrollView.frame));
    
    [self addChildViewController:pageViewController];
    pageViewController.view.frame = CGRectMake((viewControllers.count-1)*width, self.topMargin, width, height);
    pageViewController.pageViewController = self;
    [self.pageScrollView addSubview:pageViewController.view];
 
    self.currentSelectedIndex += 1;
}

- (void)replaceCurrentPageTitleWithTitle:(NSString *)title{
    
    NSMutableArray *pageTitles = [NSMutableArray arrayWithArray:self.pageTitles];
    [pageTitles replaceObjectAtIndex:self.currentSelectedIndex withObject:title];
    self.pageTitles = pageTitles;
    [self.topScrollView reloadTopScrollView];
}

- (void)deletePageFromIndex:(NSInteger)index{
    
    for (NSInteger i = index; i < self.viewControllers.count; i=i) {
        UIViewController *vc = self.viewControllers[i];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
        [viewControllers removeObject:vc];
        self.viewControllers = viewControllers;
        
        NSMutableArray *titles = [NSMutableArray arrayWithArray:self.pageTitles];
        [titles removeObject:self.pageTitles[i]];
        self.pageTitles = titles;
        
    }
    [self.topScrollView reloadTopScrollView];
    [self.pageScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.pageScrollView.frame)*self.viewControllers.count, CGRectGetHeight(self.pageScrollView.frame))];
}

#pragma mark-
#pragma mark-   observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
//    NSLog(@"%@--->change:%@",object,change);
    CGFloat offset = [change[@"new"] CGPointValue].x - [change[@"old"] CGPointValue].x;
    CGRect rect = self.topScrollView.lineView.frame;
    
    rect.origin.x+=self.topViewItemWidth*offset/CGRectGetWidth(self.topScrollView.superview.frame);
    self.topScrollView.lineView.frame = rect;
//    [self.topScrollView setLineContentOffset:offset];
}

#pragma mark-
#pragma mark-   UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.currentSelectedIndex = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
//    if (self.scrollPosition==SATopViewItemScrollPositionMiddle) {
//        [self.topScrollView setSelectedIndex:self.currentSelectedIndex withScrollToMiddleVisiableAnimate:YES];
//    }else{
//        [self.topScrollView setSelectedIndex:self.currentSelectedIndex withScrollToLeftOrRightVisiableAnimate:YES];
//    }
    NSInteger number = self.currentSelectedIndex ;
    if(self.delegate && [self.delegate respondsToSelector:@selector(ViewController:atIndex:)]){
        [self.delegate ViewController:self.viewControllers[number] atIndex:number];
    }
    
}

#pragma mark- 
#pragma mark-   SATopScrollViewDataSource
- (NSInteger)numberOfItemInTopScrollView:(SATopScrollView *)topScrollView{
    return self.viewControllers.count;
}

- (SAScrollItem *)topScrollView:(SATopScrollView *)topScrollView itemForRowIndex:(NSInteger)index{
    SAScrollItem *item = [[SAScrollItem alloc] init];
    NSString *title = [NSString stringWithFormat:@"标题%@",@(index+1).stringValue];
//    if ([self.dataSource respondsToSelector:@selector(titleForTopViewItemAtIndex:)]) {
//        title = [self.dataSource titleForTopViewItemAtIndex:index];
//    }
    if (index < self.pageTitles.count) {
        title = self.pageTitles[index];
    }
    [item setTitle:title];
    return item;
}

- (void)topScrollView:(SATopScrollView *)topScrollView didSelectedItemAtIndex:(NSInteger)index{
    
//    [self.pageScrollView setContentOffset:CGPointMake(index*CGRectGetWidth(self.pageScrollView.frame), 0) animated:YES];
    self.currentSelectedIndex = index;
    NSInteger number = self.currentSelectedIndex ;
    if(self.delegate && [self.delegate respondsToSelector:@selector(ViewController:atIndex:)]){
        [self.delegate ViewController:self.viewControllers[number] atIndex:number];
    }
}

#pragma mark-
#pragma makr- setter and getter
- (UIScrollView *)pageScrollView{
    
    if (!_pageScrollView) {
        _pageScrollView = [[UIScrollView alloc] init];
        _pageScrollView.backgroundColor = [UIColor whiteColor];
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.delegate = self;
        [_pageScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return _pageScrollView;
}

- (SATopScrollView *)topScrollView{
    if (!_topScrollView) {
        _topScrollView = [SATopScrollView new];
        _topScrollView.itemWidth = self.topViewItemWidth;
        _topScrollView.itemHeight = self.topViewHeight;
        [_topScrollView setScrollItemNormalColor:self.topViewItemTitleNormalColor selectedColor:self.topViewItemTitleSelectedColor lineColor:self.lineColor];
        _topScrollView.dataSource = self;
      
    }
    return _topScrollView;
}

- (NSMutableArray<NSArray *>*)areaArray{
    if (!_areaArray) {
        _areaArray = [NSMutableArray array];
    }
    return _areaArray;
}

- (void)setCurrentSelectedIndex:(NSUInteger)currentSelectedIndex{
    _currentSelectedIndex = currentSelectedIndex;
    [self.topScrollView setSelectedIndex:currentSelectedIndex withScrollToMiddleVisiableAnimate:YES];
    [self.pageScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.pageScrollView.frame)*currentSelectedIndex, 0) animated:YES];

}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers{
    _viewControllers = viewControllers;
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.pageViewController = self;
        obj.index = idx;
    }];
}

- (void)setDidEndSelectedAddress:(DidEndSelectedAddress)didEndSelected{
    _didEndSelectedAddress = didEndSelected;
}

- (void)dealloc{
    [_pageScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

static const char *kPageViewController = "pageViewController";
static const char *kIndex = "index";
@implementation UIViewController (SAPageViewController)

- (void)setPageViewController:(SAPageViewController *)pageViewController{
    objc_setAssociatedObject(self, kPageViewController, pageViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SAPageViewController *)pageViewController{
    return objc_getAssociatedObject(self, kPageViewController);
}

- (void)setIndex:(NSInteger)index{
    objc_setAssociatedObject(self, kIndex, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)index{
    id index = objc_getAssociatedObject(self, kIndex);
    return [index integerValue];
}

@end
