//
//  ViewController.m
//  GLViewPagerViewController
//
//  Created by Yanci on 17/4/18.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import "ViewController.h"

@interface GLPresentViewController : UIViewController
- (id)initWithTitle:(NSString *)title;
@end


@interface GLPresentViewController()
@property (nonatomic,strong)UILabel *presentLabel;
@end

@implementation GLPresentViewController {
    NSString *_title;
    BOOL _setupSubViews;
}
- (id)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        _title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.presentLabel.text = _title;
    [self.presentLabel sizeToFit];
    [self.view addSubview:self.presentLabel];
    self.presentLabel.center = self.view.center;
}

- (void)viewWillLayoutSubviews {
        self.presentLabel.center = self.view.center;
}

- (UILabel *)presentLabel {
    if (!_presentLabel) {
        _presentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    return _presentLabel;
}

@end

@interface ViewController ()<GLViewPagerViewControllerDataSource,GLViewPagerViewControllerDelegate>
@property (nonatomic,strong)NSArray *viewControllers;
@property (nonatomic,strong)NSArray *tagTitles;
@property (nonatomic,assign)BOOL fullfillTabs;  /** Fullfilltabs when tabs width less than view width */
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Paged Tabs";
    // Do any additional setup after loading the view.
    self.dataSource = self;
    self.delegate = self;
    self.fixTabWidth = NO;
    self.padding = 10;
    self.leadingPadding = 10;
    self.trailingPadding = 10;
    self.defaultDisplayPageIndex = 0;
    self.tabAnimationType = GLTabAnimationType_whileScrolling;
    self.indicatorColor = [UIColor colorWithRed:255.0/255.0 green:205.0 / 255.0 blue:0.0 alpha:1.0];
    self.supportArabic = NO;
    self.fullfillTabs = YES;
    
    /** 设置内容视图 */
    self.viewControllers = @[
                             [[GLPresentViewController alloc]initWithTitle:@"Page One"],
                             [[GLPresentViewController alloc]initWithTitle:@"Page Two"],
                             [[GLPresentViewController alloc]initWithTitle:@"Page Three"],
                             [[GLPresentViewController alloc]initWithTitle:@"Page Four"],
                             [[GLPresentViewController alloc]initWithTitle:@"Page Five"],
                             [[GLPresentViewController alloc]initWithTitle:@"Page Six"],
                             [[GLPresentViewController alloc]initWithTitle:@"Page Seven"],
                             [[GLPresentViewController alloc]initWithTitle:@"Page Eight"],
                             [[GLPresentViewController alloc]initWithTitle:@"Page Nine"],
                             [[GLPresentViewController alloc]initWithTitle:@"Page Ten"],
                             [[GLPresentViewController alloc]initWithTitle:@"Page Eleven"],
                             [[GLPresentViewController alloc]initWithTitle:@"Page Twelve"],
                             ];
    /** 设置标签标题 */
    self.tagTitles = @[
                       @"Page One",
                       @"Page Two",
                       @"Page Three",
                       @"Page Four",
                       @"Page Five",
                       @"Page Six",
                       @"Page Seven",
                       @"Page Eight",
                       @"Page Nine",
                       @"Page Ten",
                       @"Page Eleven",
                       @"Page Twelve"
                       ];
    
    
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GLViewPagerViewControllerDataSource
- (NSUInteger)numberOfTabsForViewPager:(GLViewPagerViewController *)viewPager {
    return self.viewControllers.count;
}



- (UIView *)viewPager:(GLViewPagerViewController *)viewPager
      viewForTabIndex:(NSUInteger)index {
    UILabel *label = [[UILabel alloc]init];
    label.text = [self.tagTitles objectAtIndex:index];
    label.font = [UIFont systemFontOfSize:16.0];
    /** 默认紫色 */
    label.textColor =[UIColor colorWithRed:0.5
                                     green:0.0
                                      blue:0.5
                                     alpha:1.0];
 
    label.textAlignment = NSTextAlignmentCenter;
#if 0
    label.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
#endif
    return label;
}

- (UIViewController *)viewPager:(GLViewPagerViewController *)viewPager
contentViewControllerForTabAtIndex:(NSUInteger)index {
    return self.viewControllers[index];
}
#pragma mark - GLViewPagerViewControllerDelegate
- (void)viewPager:(GLViewPagerViewController *)viewPager didChangeTabToIndex:(NSUInteger)index fromTabIndex:(NSUInteger)fromTabIndex {
    UILabel *prevLabel = (UILabel *)[viewPager tabViewAtIndex:fromTabIndex];
    UILabel *currentLabel = (UILabel *)[viewPager tabViewAtIndex:index];
#if 0
    prevLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    currentLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
#endif
    /* 紫色默认颜色 */
    prevLabel.textColor = [UIColor colorWithRed:0.5
                                          green:0.0
                                           blue:0.5
                                          alpha:1.0];
  
    /* 灰色高亮颜色 */
    currentLabel.textColor =   [UIColor colorWithRed:0.3
                                               green:0.3
                                                blue:0.3
                                               alpha:1.0];
}

- (void)viewPager:(GLViewPagerViewController *)viewPager willChangeTabToIndex:(NSUInteger)index fromTabIndex:(NSUInteger)fromTabIndex withTransitionProgress:(CGFloat)progress {
    
    if (fromTabIndex == index) {
        return;
    }
    UILabel *prevLabel = (UILabel *)[viewPager tabViewAtIndex:fromTabIndex];
    UILabel *currentLabel = (UILabel *)[viewPager tabViewAtIndex:index];
    
#if 0
    prevLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                 1.0 - (0.1 * progress),
                                                 1.0 - (0.1 * progress));
    currentLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                    0.9 + (0.1 * progress),
                                                    0.9 + (0.1 * progress));
    
#endif
    
    currentLabel.textColor =[UIColor colorWithRed:0.5 - 0.2 * progress
                                            green:0.0 + 0.3 * progress
                                             blue:0.5 - 0.2 * progress
                                            alpha:1.0];
 
    prevLabel.textColor =[UIColor colorWithRed:0.3 + 0.2 * progress
                                         green:0.3 - 0.3 * progress
                                          blue:0.3 + 0.2 * progress
                                         alpha:1.0];


}


- (CGFloat)viewPager:(GLViewPagerViewController *)viewPager widthForTabIndex:(NSUInteger)index {
    static UILabel *prototypeLabel ;
    if (!prototypeLabel) {
        prototypeLabel = [[UILabel alloc]init];
    }
    prototypeLabel.text = [self.tagTitles objectAtIndex:index];
    prototypeLabel.textAlignment = NSTextAlignmentCenter;
    prototypeLabel.font = [UIFont systemFontOfSize:16.0];
#if 0
    prototypeLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
#endif
    return prototypeLabel.intrinsicContentSize.width + (self.fullfillTabs == YES ?  [self tabsFulFillToScreenWidthInset] : 0);
}

#pragma mark - funcs

- (CGFloat)tabsFulFillToScreenWidthInset {
    if ([self isTabsWidthGreaterThanScreenWidth]) {
        return 0.0;
    }
    
    return [self screenleftWidthForTabs] / self.tagTitles.count;
}

- (CGFloat)estimateTabsWidthInView {
    static UILabel *prototypeLabel ;
    if (!prototypeLabel) {
        prototypeLabel = [[UILabel alloc]init];
    }
    prototypeLabel.textAlignment = NSTextAlignmentCenter;
    prototypeLabel.font = [UIFont systemFontOfSize:16.0];
    
    CGFloat estimateTabsWidth = 0.0;
    estimateTabsWidth += self.leadingPadding;
    
    for (NSUInteger i = 0; i < self.tagTitles.count; i++) {
        prototypeLabel.text = [self.tagTitles objectAtIndex:i];
        estimateTabsWidth += prototypeLabel.intrinsicContentSize.width;
        if (i == self.tagTitles.count - 1) {
            estimateTabsWidth += 0;
        }
        else {
            estimateTabsWidth += self.padding;
        }
    }
    estimateTabsWidth+=self.trailingPadding;
    return estimateTabsWidth;
}

- (CGFloat)screenleftWidthForTabs {
    CGFloat tabsWidth = [self estimateTabsWidthInView];
    return self.view.bounds.size.width - tabsWidth;
}

- (BOOL)isTabsWidthGreaterThanScreenWidth {
    return [self screenleftWidthForTabs] < 0 ? true : false;
}









@end
