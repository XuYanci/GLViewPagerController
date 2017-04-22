# GLViewPagerController
![Build Status](https://travis-ci.org/msaps/MSSTabbedPageViewController.svg?branch=develop)
![converage](	https://img.shields.io/sonar/http/sonar.qatools.ru/ru.yandex.qatools.allure:allure-core/coverage.svg)
![license](https://img.shields.io/github/license/mashape/apistatus.svg)

GLViewPagerViewController属于公用控件，常见于新闻资讯模块，这里主要用UIPageViewController以及UIScrollView作为标签栏容器视图来构建。

GLViewPagerViewController is an common public control, it is usally used in news, here use UIPageViewController and UIScrollView as tab container to build it.

<div style="width:100%;">
<img src=".https://github.com/XuYanci/GLViewPagerController/blob/master/readme~resource/present_viewpager.gif" align="center" height="30%" width="30%" style="margin-left:20px;">
</div>

<p><p>

## Example (例子)
运行工程例子，克隆仓库和构建工程，例子支持Objective-C。

To run the example project, clone the repo and build the project. Examples are available for Objective-C project.

<p><p>

## Installation (安装)

GLViewPagerController 暂时不支持cocoapods，你可以克隆仓库，然后添加GLViewPagerController.h GLViewPagerController.m到你的工程中，引入头文件来使用它。

GLViewPagerController is not available through cocoapods now, you can clone the repo and add GLViewPagerController.h GLViewPagerController.m to you project, import the header and use it.

<p><p>

## Usage

使用标签分页控件，你需要创建一个`UIViewController`作为`GLViewPagerViewController`的子类，然后实现下面的数据源接口:

To use the tabbed page view controller, simply create a `UIViewController` that is a subclass of `GLViewPagerViewController`. Then implement the following data source method:

```

Here return the amount of the tabs 

- (NSUInteger)numberOfTabsForViewPager:(GLViewPagerViewController *)viewPager;


Here return the view of the tab at index

- (UIView *)viewPager:(GLViewPagerViewController *)viewPager
      viewForTabIndex:(NSUInteger)index;

Here return the contentview of the viewpager at index

- (UIViewController *)viewPager:(GLViewPagerViewController *)viewPager
contentViewControllerForTabAtIndex:(NSUInteger)index;
```

<p><p>

### Page View Controller Enhancements
```
Here you can get the tab index when swithing between tabs.
- (void)viewPager:(GLViewPagerViewController *)viewPager didChangeTabToIndex:(NSUInteger)index fromTabIndex:(NSUInteger)fromTabIndex;


Want to animate font or textcolor when switching tabs, you can use this delegate method, the progress value range from 0.0 to 1.0.
- (void)viewPager:(GLViewPagerViewController *)viewPager willChangeTabToIndex:(NSUInteger)index fromTabIndex:(NSUInteger)fromTabIndex withTransitionProgress:(CGFloat)progress;

Here you can return the tab width at index, if not implement this interface, it use the default tabwidth value.

- (CGFloat)viewPager:(GLViewPagerViewController *)viewPager widthForTabIndex:(NSUInteger)index;
```

<p><p>

## Appearance

/** 指示器颜色 */

@property (nonatomic,strong)UIColor *indicatorColor;

/** 固定标签宽度 */

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

<p><p>

## Requirements
Supports iOS 8 and above.

<p><p>

## Author
Xu Yanci

Mail: [randy.wind](mailto:grandy.wind@gmail.com)
