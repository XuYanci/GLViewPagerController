# GLViewPagerController

#### 说明
GLViewPagerViewController属于公用控件，常见于新闻资讯模块，这里主要用UIPageViewController以及UIScrollView作为标签栏容器视图来构建。

#### 使用

*支持属性*
``` objc 
/** 固定标签宽度  */
@property (nonatomic,assign)BOOL fixTabWidth;
/** 标签宽度 */
@property (nonatomic,assign)CGFloat tabWidth;
/** 标签高度 */
@property (nonatomic,assign)CGFloat tabHeight;
/** 指示器高度 */
@property (nonatomic,assign)CGFloat indicatorHeight;
/** 指示器宽度 */
@property (nonatomic,assign)CGFloat indicatorWidth;
/** 固定指示器宽度*/
@property (nonatomic,assign)BOOL fixIndicatorWidth;
/** 标签之间间距 */
@property (nonatomic,assign)CGFloat padding;
/** 标签第一个元素离左边多少Point */
@property (nonatomic,assign)CGFloat leadingPadding;
/** 标签最后一个元素离右边多少Point */
@property (nonatomic,assign)CGFloat trailingPadding;
/** 默认显示第一页 (一般是0) */
@property (nonatomic,assign)NSUInteger defaultDisplayPageIndex;
/** 标签动画时长 */
@property (nonatomic,assign)CGFloat animationTabDuration;
/** 标签动画类型 */
@property (nonatomic,assign)GLTabAnimationType tabAnimationType;
```

*数据源*

``` objc 
/** ViewPager数据源 */
@protocol GLViewPagerViewControllerDataSource <NSObject>

/**
 数据源 - 返回多少个标签
 @param viewPager 分页控件
 @return 返回多少个标签
 */
- (NSUInteger)numberOfTabsForViewPager:(GLViewPagerViewController *)viewPager;

/**
 数据源 - 返回对应标签视图
 @param viewPager 分页控件
 @return 返回对应标签视图
 */
- (UIView *)viewPager:(GLViewPagerViewController *)viewPager
      viewForTabIndex:(NSUInteger)index;


@optional
- (UIViewController *)viewPager:(GLViewPagerViewController *)viewPager
contentViewControllerForTabAtIndex:(NSUInteger)index;

- (UIView *)viewPager:(GLViewPagerViewController *)viewPager
       contentViewForTabAtIndex:(NSUInteger)index;
@end

``` 

*数据委托*

``` objc 
/** ViewPager委托*/
@protocol GLViewPagerViewControllerDelegate <NSObject>

/**
 委托 - 切换到哪个界面Index
 @param viewPager 分页控件
 @param index 切换界面Index
 */
- (void)viewPager:(GLViewPagerViewController *)viewPager didChangeTabToIndex:(NSUInteger)index fromTabIndex:(NSUInteger)fromTabIndex;

/**
  委托 - 切换到哪个界面Index
 @discussion 切换标签带有滑动页面字体变化以及颜色渐变等，则需要获取当前进度设置对应字体颜色以及字体大小等。
 @param viewPager viewPager 分页控
 @param index index 切换界面Index
 @param progress 切换到界面进度 (0.0 ~ 1.0)
 */
- (void)viewPager:(GLViewPagerViewController *)viewPager willChangeTabToIndex:(NSUInteger)index fromTabIndex:(NSUInteger)fromTabIndex withTransitionProgress:(CGFloat)progress;


/**
 委托 - 获取标签宽度

 @param viewPager ViewPager分页控件
 @param index 标签Index
 @return 返回标签宽度
 */
- (CGFloat)viewPager:(GLViewPagerViewController *)viewPager widthForTabIndex:(NSUInteger)index;

@end

```

#### Demo演示
![viewpager](./readme~resource/present_viewpager.gif)

#### End GLViewPagerViewController
