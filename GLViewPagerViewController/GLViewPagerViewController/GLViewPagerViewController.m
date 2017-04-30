// GLViewPagerViewController.m
//
// Copyright (c) 2017 XuYanci (http://yanci.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "GLViewPagerViewController.h"

/**
 * 常量定义
 */
#define kTabTagBegin                    0xA0
#define kIndicatorColor                 [UIColor blueColor]
#define kTabFontDefault                 [UIFont systemFontOfSize:12]
#define kTabFontSelected                [UIFont systemFontOfSize:12]
#define kTabTextColorDefault            [UIColor blueColor]
#define kTabTextColorSelected           [UIColor blueColor]
#define kBackgroundColor                [UIColor whiteColor]
#define kTabContentBackgroundColor      [UIColor clearColor]
#define kPageViewCtrlBackgroundColor    [UIColor whiteColor]


static const CGFloat kTabHeight = 44.0;
static const CGFloat kTabWidth = 128.0;
static const CGFloat kIndicatorHeight = 2.0;
static const CGFloat kIndicatorWidth = 128.0;
static const CGFloat kPadding = 0.0;
static const CGFloat kLeadingPadding = 0.0;
static const CGFloat kTrailingPadding = 0.0;
static const BOOL kFixTabWidth = YES;
static const BOOL kFixIndicatorWidth = YES;
static const NSUInteger kDefaultDisplayPageIndex = 0;
static const CGFloat kAnimationTabDuration = 0.3;
static const GLTabAnimationType kTabAnimationType = GLTabAnimationType_none;

@interface GLViewPagerViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>
@property (nonatomic,strong)UIPageViewController *pageViewController;
@property (nonatomic,strong)NSMutableArray <UIViewController *>*contentViewControllers;
@property (nonatomic,strong)NSMutableArray <UIView *>*contentViews;
@property (nonatomic,strong)UIScrollView *tabContentView;
@property (nonatomic,strong)NSMutableArray <UIView *>*tabViews;
@property (nonatomic,strong)UIView *indicatorView;
@end

@implementation GLViewPagerViewController {
    BOOL _needsReload;
    struct {
        unsigned numberOfTabsForViewPager:1;
        unsigned viewForTabIndex:1;
        unsigned contentViewControllerForTabAtIndex:1;
        unsigned contentViewForTabAtIndex:1;
    }_datasourceHas;
    
    struct{
        unsigned didChangeTabToIndex;
        unsigned willChangeTabToIndex;
        unsigned widthForTabIndex;
    }_delegateHas;
    
    CGFloat leftTabOffsetWidth;     /** 标签离前一个偏移宽度*/
    CGFloat rightTabOffsetWidth;    /** 标签离后一个偏移宽度*/
    CGFloat leftMinusCurrentWidth;  /** 左标签减去当前标签得出宽度 */
    CGFloat rightMinusCurrentWidth; /** 右标签减去当前标签得出宽度 */
    NSUInteger _currentPageIndex;   /** 当前页 */
    BOOL _enableTabAnimationWhileScrolling; /** 是否允许标签滑动显示 */
}


#pragma mark - life cycle
- (id)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)dealloc {
    
}

- (void)loadView  {
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:[[UIView alloc]init]];
    /** @note 如果先添加tabContentView会导致contentSize设置无效、具体原因待查明 */
    [self.view addSubview:self.tabContentView];
    [self.tabContentView addSubview:self.indicatorView];
    [self.view addSubview:self.pageViewController.view];
}

- (void)viewWillLayoutSubviews {
    [self _reloadDataIfNeed];
    [self _layoutSubviews];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

#pragma mark - datasource

#pragma mark - UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.contentViewControllers indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }
    return [self.contentViewControllers objectAtIndex:index - 1];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.contentViewControllers indexOfObject:viewController];
    if (index == self.contentViewControllers.count - 1 ) {
        return nil;
    }
    return [self.contentViewControllers objectAtIndex:index + 1];
}


#pragma mark - delegate

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        NSUInteger currentPageIndex = [self.contentViewControllers indexOfObject:pageViewController.viewControllers[0]];
        NSUInteger prevPageIndex = [self.contentViewControllers indexOfObject:previousViewControllers[0]];
        NSLog(@"Current Page Index = %ld",currentPageIndex);
        [self _setActiveTabIndex:currentPageIndex];
        [self _caculateTabOffsetWidth:currentPageIndex];
        _currentPageIndex = currentPageIndex;
        if (_delegateHas.didChangeTabToIndex) {
            [_delegate viewPager:self didChangeTabToIndex:currentPageIndex fromTabIndex:prevPageIndex];
        }
        
        if (self.tabAnimationType == GLTabAnimationType_whileScrolling) {
            _enableTabAnimationWhileScrolling = NO;
        }
    }
}

#pragma mar - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.tabAnimationType == GLTabAnimationType_whileScrolling) {
        _enableTabAnimationWhileScrolling = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.tabAnimationType == GLTabAnimationType_whileScrolling) {
        _enableTabAnimationWhileScrolling = NO;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    if (self.tabAnimationType == GLTabAnimationType_whileScrolling && _enableTabAnimationWhileScrolling) {
        CGFloat scale = fabs((scrollView.contentOffset.x - scrollView.frame.size.width) /  scrollView.frame.size.width);
        
        
        
        CGFloat offset = 0;
        CGFloat indicationAnimationWidth = 0;
        NSUInteger currentPageIndex = _currentPageIndex;
        CGRect indicatorViewFrame = [self _caculateTabViewFrame:currentPageIndex];
        
        /** left to right */
        if (scrollView.contentOffset.x - scrollView.frame.size.width > 0) {
            offset =  rightTabOffsetWidth * scale;
            indicationAnimationWidth = indicatorViewFrame.size.width + rightMinusCurrentWidth * scale;
            
            if (_delegateHas.willChangeTabToIndex) {
                [_delegate viewPager:self
                willChangeTabToIndex:(currentPageIndex + 1) > self.tabViews.count - 1 ? currentPageIndex : currentPageIndex + 1
                        fromTabIndex:currentPageIndex
              withTransitionProgress:scale];
            }
        }
        /** right to left */
        else {
             offset = -leftTabOffsetWidth * scale;
             indicationAnimationWidth = indicatorViewFrame.size.width + leftMinusCurrentWidth * scale;
            
            if (_delegateHas.willChangeTabToIndex) {
                [_delegate viewPager:self
                willChangeTabToIndex: currentPageIndex == 0 ? 0 : currentPageIndex - 1
                        fromTabIndex:currentPageIndex
              withTransitionProgress:scale];
            }
        }

        indicatorViewFrame.origin.x += offset;
        indicatorViewFrame.size.width = indicationAnimationWidth;
        self.indicatorView.frame = indicatorViewFrame;
        
     
    }
}

#pragma mark - user events
- (void)tapInTabView:(UITapGestureRecognizer *)tapGR {
    NSUInteger tabIndex = tapGR.view.tag - kTabTagBegin;
    [self _selectTab:tabIndex animate:NO];
}


#pragma mark - functions

/**
 默认初始化
 */
- (void)commonInit {
    /** 初始化默认参数 */
    self.indicatorColor = kIndicatorColor;
    self.tabFontDefault = kTabFontDefault;
    self.tabFontSelected = kTabFontSelected;
    self.tabTextColorDefault = kTabTextColorDefault;
    self.tabTextColorSelected = kTabTextColorSelected;
    self.fixTabWidth = kFixTabWidth;
    self.tabWidth = kTabWidth;
    self.tabHeight = kTabHeight;
    self.indicatorHeight = kIndicatorHeight;
    self.padding = kPadding;
    self.indicatorWidth = kIndicatorWidth;
    self.fixIndicatorWidth = kFixIndicatorWidth;
    self.leadingPadding = kLeadingPadding;
    self.trailingPadding = kTrailingPadding;
    self.defaultDisplayPageIndex = kDefaultDisplayPageIndex;
    self.tabAnimationType = kTabAnimationType;
    self.animationTabDuration = kAnimationTabDuration;

    [self _setNeedsReload];
}

- (void)setDataSource:(id<GLViewPagerViewControllerDataSource>)newDataSource {
    _dataSource = newDataSource;
    
    _datasourceHas.numberOfTabsForViewPager = [newDataSource respondsToSelector:@selector(numberOfTabsForViewPager:)];
    _datasourceHas.contentViewForTabAtIndex = [newDataSource respondsToSelector:@selector(viewPager:contentViewForTabAtIndex:)];
    _datasourceHas.numberOfTabsForViewPager = [newDataSource respondsToSelector:@selector(numberOfTabsForViewPager:)];
    _datasourceHas.viewForTabIndex = [newDataSource respondsToSelector:@selector(viewPager:viewForTabIndex:)];
    _datasourceHas.contentViewControllerForTabAtIndex = [newDataSource respondsToSelector:@selector(viewPager:contentViewControllerForTabAtIndex:)];
    [self _setNeedsReload];
}

- (void)setDelegate:(id<GLViewPagerViewControllerDelegate>)newDelegate {
    _delegateHas.didChangeTabToIndex = [newDelegate respondsToSelector:@selector(viewPager:didChangeTabToIndex:fromTabIndex:)];
    _delegateHas.willChangeTabToIndex = [newDelegate respondsToSelector:@selector(viewPager:willChangeTabToIndex:fromTabIndex:withTransitionProgress:)];
    _delegateHas.widthForTabIndex = [newDelegate respondsToSelector:@selector(viewPager:widthForTabIndex:)];
    _delegate = newDelegate;
}


/**
 重载数据
 @discussion  调用数据源填充数据以及建立视图树
 */
- (void)reloadData {
    
    // 设置控件属性
    self.indicatorView.backgroundColor = self.indicatorColor;
    
    // 清理Tab子控件
    [self.tabViews removeAllObjects];
    [self.tabContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    // 填充Tab
    NSUInteger numberOfTabs = 0;
    if (_datasourceHas.numberOfTabsForViewPager) {
        numberOfTabs = [_dataSource numberOfTabsForViewPager:self];
    }
    
    if (_datasourceHas.viewForTabIndex) {
        /** 添加标签指示视图 */
        if (![self.tabContentView.subviews containsObject:self.indicatorView]
            && numberOfTabs > 0) {
            [self.tabContentView addSubview:self.indicatorView];
        }
        
        UIView *preTabView = nil;
        CGFloat tabContentWidth = 0;
        for (NSUInteger i = 0; i < numberOfTabs; i++) {
            UIView *tabView = [_dataSource viewPager:self viewForTabIndex:i];
            NSAssert([tabView isKindOfClass:[UIView class]], @"This is not an UIView subclass");
            [self.tabContentView addSubview:tabView];
            [self.tabViews addObject:tabView];

            /** 添加单击手势 选择标签*/
            [tabView setTag:kTabTagBegin + i];
            tabView.userInteractionEnabled = YES;
            [tabView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInTabView:)]];
            
            
            if (!preTabView) {
                CGRect rect = tabView.frame;
                rect.size.width = self.fixTabWidth ? self.tabWidth : [self _getTabWidthAtIndex:i];
                rect.size.height = self.tabHeight;
                rect.origin.x = self.leadingPadding;
                rect.origin.y = 0;
                tabView.frame = rect;
                preTabView = tabView;
                tabContentWidth += self.fixTabWidth ? self.tabWidth : [self _getTabWidthAtIndex:i] + self.leadingPadding;
            }
            else {
                CGRect rect = tabView.frame;
                rect.size.width = self.fixTabWidth ? self.tabWidth : [self _getTabWidthAtIndex:i];
                rect.size.height = self.tabHeight;
                rect.origin.x = CGRectGetMaxX(preTabView.frame) + self.padding;
                rect.origin.y = 0;
                tabView.frame =rect;
                preTabView = tabView;
                tabContentWidth += ((self.fixTabWidth ? self.tabWidth : [self _getTabWidthAtIndex:i]) + self.padding);
                
                if (i == numberOfTabs - 1) {
                    tabContentWidth += self.trailingPadding;
                }
            }
        }
        self.tabContentView.contentSize = CGSizeMake(tabContentWidth, kTabHeight);
    }
    
    [self.contentViews removeAllObjects];
    [self.contentViewControllers removeAllObjects];
    
    /**填充分页方式一
     */
    if (_datasourceHas.contentViewControllerForTabAtIndex) {
        for (NSUInteger i = 0; i < numberOfTabs; i++) {
            UIViewController *viewController = [_dataSource viewPager:self contentViewControllerForTabAtIndex:i];
            NSAssert([viewController isKindOfClass:[UIViewController class]], @"This is not an UIViewController subclass");
            [self.contentViewControllers addObject:viewController];
        }
        
        NSAssert(self.defaultDisplayPageIndex <= self.contentViewControllers.count - 1, @"Default display page index is bigger than amount of  view controller");
        
        [self _setActivePageIndex:self.defaultDisplayPageIndex];
        [self _setActiveTabIndex:self.defaultDisplayPageIndex];
        [self _caculateTabOffsetWidth:self.defaultDisplayPageIndex];
        _currentPageIndex = self.defaultDisplayPageIndex;
        
        if (_delegateHas.didChangeTabToIndex) {
            [_delegate viewPager:self didChangeTabToIndex:_currentPageIndex fromTabIndex:self.defaultDisplayPageIndex];
        }
        
    }
    /**填充分页方式二
     */
    else if(_datasourceHas.contentViewForTabAtIndex) {
        for (NSUInteger i = 0; i < numberOfTabs; i++) {
            
        }
    }
    _needsReload = NO;
}

- (UIView *)tabViewAtIndex:(NSUInteger)index {
    return [self.tabViews objectAtIndex:index];
}

/**
 选择标签视图
 @param tabIndex 标签Index
 */
- (void)_selectTab:(NSUInteger)tabIndex animate:(BOOL)animate {
    
    NSUInteger prevPageIndex = _currentPageIndex;
    
    [self _disableViewPagerScroll];
    [self _setActivePageIndex:tabIndex];
    [self _setActiveTabIndex:tabIndex];
    [self _caculateTabOffsetWidth:tabIndex];
    _currentPageIndex = tabIndex;
    _enableTabAnimationWhileScrolling = NO;
    [self _enableViewPagerScroll];
    
    if (_delegateHas.didChangeTabToIndex) {
        [_delegate viewPager:self didChangeTabToIndex:_currentPageIndex fromTabIndex:prevPageIndex];
    }
}

/**
 * 重新加载数据
 */
- (void)_setNeedsReload {
    _needsReload = YES;
    [self.view setNeedsLayout];
}

/**
 按需重新加载数据
 */
- (void)_reloadDataIfNeed {
    if (_needsReload) {
        [self reloadData];
    }
}

/** 视图布局 */
- (void)_layoutSubviews {
 
    CGFloat topLayoutGuide = self.topLayoutGuide.length;
    CGFloat bottomLayoutGuide = self.bottomLayoutGuide.length;
    
    /** 布局TabContentView */
    CGRect tabContentViewFrame = self.tabContentView.frame;
    tabContentViewFrame.size.width = self.view.bounds.size.width;
    tabContentViewFrame.size.height = kTabHeight;
    tabContentViewFrame.origin.x = 0;
    tabContentViewFrame.origin.y = topLayoutGuide;
    self.tabContentView.frame = tabContentViewFrame;
 
    /** 布局PageViewController */
    CGRect pageViewCtrlFrame = self.pageViewController.view.frame;
    pageViewCtrlFrame.size.width = self.view.bounds.size.width;
    pageViewCtrlFrame.size.height = self.view.bounds.size.height - topLayoutGuide - bottomLayoutGuide - CGRectGetHeight(self.tabContentView.frame);
    pageViewCtrlFrame.origin.x = 0;
    pageViewCtrlFrame.origin.y = topLayoutGuide + CGRectGetHeight(self.tabContentView.frame);
    self.pageViewController.view.frame = pageViewCtrlFrame;
}

/**
 设置当前标签
 @note 计算方式同标签宽度
 */
- (void)_setActiveTabIndex:(NSUInteger)tabIndex {
    
    NSAssert(tabIndex <= self.tabViews.count - 1, @"Default display page index is bigger than amount of  view controller");
   
    CGRect frameOfTabView = [self _caculateTabViewFrame:tabIndex];
    if (self.tabAnimationType == GLTabAnimationType_end
        || self.tabAnimationType == GLTabAnimationType_whileScrolling) {
        [UIView animateWithDuration:self.animationTabDuration animations:^{
            self.indicatorView.frame = frameOfTabView;
        }];
    }
    else if (self.tabAnimationType == GLTabAnimationType_none
             ){
        self.indicatorView.frame = frameOfTabView;
    }
    
    /** Center active tab in scrollview */
    UIView *tabView = self.tabViews[tabIndex];
    CGRect frame = tabView.frame;
    if (1) {
        
        frame.origin.x += (CGRectGetWidth(frame) / 2);
        frame.origin.x -= CGRectGetWidth(self.tabContentView.frame) / 2;
        frame.size.width = CGRectGetWidth(self.tabContentView.frame);
        
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
        }
        if ((frame.origin.x + CGRectGetWidth(frame)) > self.tabContentView.contentSize.width) {
            frame.origin.x = (self.tabContentView.contentSize.width - CGRectGetWidth(self.tabContentView.frame));
        }
    }

    [self.tabContentView scrollRectToVisible:frame animated:YES];
}

/** 设置当前页 */
- (void)_setActivePageIndex:(NSUInteger)pageIndex {
    NSAssert(pageIndex <= self.contentViewControllers.count - 1, @"Default display page index is bigger than amount of  view controller");
   
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionReverse;
    if (pageIndex > _currentPageIndex) {
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    
    [self.pageViewController setViewControllers:@[self.contentViewControllers[pageIndex]]
                                      direction:direction
                                       animated:YES
                                     completion:^(BOOL finished) {
                                        
                                     }];
}


/**
 获取标签宽度

 @param tabIndex 标签Index
 @return 标签宽度
 */
- (CGFloat)_getTabWidthAtIndex:(NSUInteger)tabIndex {
    CGFloat tabWidth = 0.0;
    UIView *tabView = [self.tabViews objectAtIndex:tabIndex];
    if (_delegateHas.widthForTabIndex) {
        tabWidth = [_delegate viewPager:self widthForTabIndex:tabIndex];
    }
    
    return tabWidth == 0 ? tabView.intrinsicContentSize.width : tabWidth;
}

/** 计算标签位置大小等 */
- (CGRect)_caculateTabViewFrame:(NSUInteger)tabIndex {
    
    CGRect frameOfTabView = CGRectZero;
    if (self.fixTabWidth) {
        frameOfTabView.origin.x = tabIndex * self.fixTabWidth + (tabIndex * self.padding) + self.leadingPadding;
        frameOfTabView.origin.y = self.tabContentView.frame.size.height - self.indicatorHeight;
        frameOfTabView.size.height = self.indicatorHeight;
        frameOfTabView.size.width = self.tabWidth;
    }
    else {
        UIView *previousTabView = (tabIndex  > 0) ? self.tabViews[tabIndex - 1]:nil;
        CGFloat x = 0;
        if (tabIndex == 0) {
            x += self.leadingPadding;
        }
        else {
            x += self.padding;
        }
        x += CGRectGetMaxX(previousTabView.frame);
        frameOfTabView = CGRectZero;
        frameOfTabView.origin.x = x;
        frameOfTabView.origin.y = self.tabHeight - self.indicatorHeight;
        frameOfTabView.size.height = self.indicatorHeight;
        frameOfTabView.size.width = [self _getTabWidthAtIndex:tabIndex];
    }
    return frameOfTabView;
}

/** 计算当前标签偏移左边偏移右边宽度 */
- (void)_caculateTabOffsetWidth:(NSUInteger)pageIndex {
    /** 计算当前标签间隔宽度 */
    NSUInteger currentTabIndex = pageIndex;
    UIView *currentTabView = self.tabViews[currentTabIndex];
    UIView *previousTabView = (currentTabIndex  > 0) ? self.tabViews[currentTabIndex - 1]:nil;
    UIView *afterTabView = (currentTabIndex < self.tabViews.count - 1) ? self.tabViews[currentTabIndex + 1] : nil;
    
    /** 第一个标签 */
    if (currentTabIndex == 0) {
        leftTabOffsetWidth = self.leadingPadding;
        rightTabOffsetWidth = CGRectGetMinX(afterTabView.frame) - CGRectGetMinX(currentTabView.frame);
        leftMinusCurrentWidth = 0.0;
        rightMinusCurrentWidth = CGRectGetWidth(afterTabView.frame) - CGRectGetWidth(currentTabView.frame);
    }
    /** 最后一个标签 */
    else if(currentTabIndex == self.tabViews.count - 1) {
        leftTabOffsetWidth = CGRectGetMinX(currentTabView.frame) - CGRectGetMinX(previousTabView.frame);
        rightTabOffsetWidth = self.trailingPadding;
        leftMinusCurrentWidth = CGRectGetWidth(previousTabView.frame) - CGRectGetWidth(currentTabView.frame);
        rightMinusCurrentWidth = 0.0;
    }
    /** 中间标签 */
    else {
        leftTabOffsetWidth = CGRectGetMinX(currentTabView.frame) - CGRectGetMinX(previousTabView.frame);
        rightTabOffsetWidth = CGRectGetMinX(afterTabView.frame) - CGRectGetMinX(currentTabView.frame);
        leftMinusCurrentWidth = CGRectGetWidth(previousTabView.frame) - CGRectGetWidth(currentTabView.frame);
        rightMinusCurrentWidth = CGRectGetWidth(afterTabView.frame) - CGRectGetWidth(currentTabView.frame);
    }
    NSLog(@"left tab offset = %lf,right tab offset = %lf",leftTabOffsetWidth,rightTabOffsetWidth);
}


/**
 关闭视图滚动
 */
- (void)_disableViewPagerScroll {
    for (UIView *view in _pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)view setScrollEnabled:NO];
        }
    }
}

/**
 开启视图滚动
 */
- (void)_enableViewPagerScroll {
    for (UIView *view in _pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)view setScrollEnabled:YES];
        }
    }
}

#pragma mark - notification
#pragma mark - getter and setter
- (UIScrollView *)tabContentView {
    if (!_tabContentView) {
        _tabContentView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _tabContentView.backgroundColor = kTabContentBackgroundColor;
        _tabContentView.showsVerticalScrollIndicator = YES;
        _tabContentView.showsHorizontalScrollIndicator = YES;
        _tabContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tabContentView.scrollsToTop = NO;
        _tabContentView.showsHorizontalScrollIndicator = NO;
        _tabContentView.showsVerticalScrollIndicator = NO;
        _tabContentView.bounces = NO;
        _tabContentView.contentSize = CGSizeZero;
    }
    return _tabContentView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _indicatorView;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.view.backgroundColor = kPageViewCtrlBackgroundColor;
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        
        for (UIView *view in _pageViewController.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                [(UIScrollView *)view setDelegate:self];
            }
        }
    }
    return _pageViewController;
}

- (NSMutableArray *)contentViewControllers {
    if (!_contentViewControllers) {
        _contentViewControllers = [NSMutableArray array];
    }
    return _contentViewControllers;
}

- (NSMutableArray *)contentViews {
    if (!_contentViews) {
        _contentViews = [NSMutableArray array];

    }
    return _contentViews;
}

- (NSMutableArray *)tabViews {
    if (!_tabViews) {
        _tabViews = [NSMutableArray array];
    }
    return _tabViews;
}

@end
