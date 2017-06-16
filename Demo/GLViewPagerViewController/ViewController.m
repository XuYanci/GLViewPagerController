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
    self.leadingPadding = 30;
    self.trailingPadding = 30;
    self.defaultDisplayPageIndex = 0;
    self.tabAnimationType = GLTabAnimationType_whileScrolling;
    self.indicatorColor = [UIColor colorWithRed:255.0/255.0 green:205.0 / 255.0 blue:0.0 alpha:1.0];
    self.supportArabic = NO;
    
    //Test Case1
//    self.fixTabWidth = NO;
//    self.supportArabic = NO;
    
    //Test case2
//    self.fixTabWidth = NO;
//    self.supportArabic = YES;
//
    // Test case3
//    self.fixTabWidth = YES;
//    self.supportArabic = YES;
//
    // Test case4
//    self.fixTabWidth = YES;
//    self.supportArabic = NO;
    
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
                       @"Page Four Four Four",
                       @"Five",
                       @"Page Six",
                       @"Page Seven",
                       @"Eight",
                       @"Page Nine",
                       @"Page Ten Ten Ten",
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
    label.textColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
 
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
    prevLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    currentLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    prevLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    currentLabel.textColor = [UIColor colorWithWhite:0.0 alpha:1.0];
}

- (void)viewPager:(GLViewPagerViewController *)viewPager willChangeTabToIndex:(NSUInteger)index fromTabIndex:(NSUInteger)fromTabIndex withTransitionProgress:(CGFloat)progress {
    
    if (fromTabIndex == index) {
        return;
    }
    
    UILabel *prevLabel = (UILabel *)[viewPager tabViewAtIndex:fromTabIndex];
    UILabel *currentLabel = (UILabel *)[viewPager tabViewAtIndex:index];
    prevLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                 1.0 - (0.1 * progress),
                                                 1.0 - (0.1 * progress));
    currentLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                    0.9 + (0.1 * progress),
                                                    0.9 + (0.1 * progress));
    prevLabel.textColor = [UIColor colorWithWhite:0.0 alpha:1.0 - (0.5 * progress)];
    currentLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.5 + (0.5 * progress)];
}

- (CGFloat)viewPager:(GLViewPagerViewController *)viewPager widthForTabIndex:(NSUInteger)index {
    static UILabel *prototypeLabel ;
    if (!prototypeLabel) {
        prototypeLabel = [[UILabel alloc]init];
    }
    prototypeLabel.text = [self.tagTitles objectAtIndex:index];
    prototypeLabel.textAlignment = NSTextAlignmentCenter;
    prototypeLabel.font = [UIFont systemFontOfSize:16.0];
    return prototypeLabel.intrinsicContentSize.width;
}


@end
