# GLViewPagerController
![Build Status](https://travis-ci.org/msaps/MSSTabbedPageViewController.svg?branch=develop)
![converage](	https://img.shields.io/sonar/http/sonar.qatools.ru/ru.yandex.qatools.allure:allure-core/coverage.svg)
![license](https://img.shields.io/github/license/mashape/apistatus.svg)

GLViewPagerViewController属于公用控件，常见于新闻资讯模块，这里主要用UIPageViewController以及UIScrollView作为标签栏容器视图来构建。

GLViewPagerViewController is an common public control, it is usally used in news, here use UIPageViewController and UIScrollView as tab container to build it.

GLViewPagerViewController for swift is available [refer link](https://github.com/XuYanci/GLViewPagerViewController-Swift)
Here is an project where i use it . [Project:666](https://github.com/XuYanci/666) 

<div style="width:100%;">
<img src="https://github.com/XuYanci/GLViewPagerController/blob/master/readme~resource/present_viewpager.gif" align="center" height="30%" width="30%" style="margin-left:20px;">
</div>

<p><p>

## Example (例子)
运行工程例子，克隆仓库和构建工程，例子支持Objective-C。

To run the example project, clone the repo and build the project. Examples are available for Objective-C project.

<p><p>

## Installation (安装)

GLViewPagerController 支持cocoapods，你可以这样来使用它

GLViewPagerController is now available support cocoapods now, you can use it 

```
pod 'GLViewPagerViewController', '~> 1.0.1'
```
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
-`indicatorColor` - The indicator color

-`fixTabWidth` - When fixtabWidth is true, it use tabWidth as default value, if fixtabWidth is false, it will adjust its width for its content size.
 
-`tabWidth` - The default tabWidth value when fixtabWidth is true.
 
-`tabHeight` - The default tabHeight 
 
-`indicatorHeight` - The indicator height

-`indicatorWidth` - The indicator width when fixIndicatorWidth is true
 
-`fixIndicatorWidth` - When fixIndicatorWidth is true, it use indicatorWidth as default value, if fixIndicatorWidth is false, it will adjust its width for tab content size.

-`padding` - The padding between tabs
 
-`leadingPadding` - The leadingPadding for the first tab
 
-`trailingPadding` - The trailingPadding for the last tab

-`defaultDisplayPageIndex` - The default display page index when first display 

-`animationTabDuration` - The tab animation duration

-`tabAnimationType` - The tabAnimation type,list belows:

-`GLTabAnimationType_none` - it means no animation

-`GLTabAnimationType_whileScrolling` - animate while scrolling tab

-`GLTabAnimationType_end` - animation when finish scrolling tab

-`supportArabic` - When supportArabic is true, layout will be reverse, default is false

<p><p>

## Requirements
Supports iOS 8 and above.

<p><p>

## Author
Xu Yanci

Mail: [XuYanci](mailto:grandy.wind@gmail.com)
