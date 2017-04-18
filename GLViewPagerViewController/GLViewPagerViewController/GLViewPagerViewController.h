//
//  GLViewPagerViewController.h
//  66GoodLook
//
//  Created by Yanci on 17/4/11.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GLTabAnimationType_none,    /** 无动画 */
    GLTabAnimationType_whileScrolling, /** 滑动时动画 */
    GLTabAnimationType_end,         /** 结束时动画 */
} GLTabAnimationType;

@class GLViewPagerViewController;
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

@interface GLViewPagerViewController : UIViewController

/** 数据源 */
@property (nonatomic,weak)id<GLViewPagerViewControllerDataSource> dataSource;
/** 委托 */
@property (nonatomic,weak)id<GLViewPagerViewControllerDelegate> delegate;

/** 指示器颜色 */
@property (nonatomic,strong)UIColor *indicatorColor;
/** 默认标签字体 */
@property (nonatomic,strong)DEPRECATED_ATTRIBUTE UIFont *tabFontDefault;
/** 选择标签字体 */
@property (nonatomic,strong)DEPRECATED_ATTRIBUTE UIFont *tabFontSelected;
/** 默认标签字体颜色 */
@property (nonatomic,strong)DEPRECATED_ATTRIBUTE UIColor *tabTextColorDefault;
/** 选择标签字体颜色 */
@property (nonatomic,strong)DEPRECATED_ATTRIBUTE UIColor *tabTextColorSelected;
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

/** 重新加载数据,会调用DataSource方法并重新构建视图 */
- (void)reloadData;

/**
 获取标签

 @param index 标签Index
 @return 返回标签控件
 */
- (UIView *)tabViewAtIndex:(NSUInteger)index;

@end
