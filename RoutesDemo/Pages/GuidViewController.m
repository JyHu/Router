//
//  GuidViewController.m
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/30.
//

#import "GuidViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+Helper.h"
#import "JMPme.h"

@interface GuidViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation GuidViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
    }];
    
    self.navigationController.navigationBarHidden = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor randomColor];
    [button setTitle:@"Go Login" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gologin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
}

- (void)gologin {
    [FTRouter routeURL:[NSURL URLWithString:@"account/login"]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / width + 0.5);
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.contentSize = CGSizeMake(size.width * 4, size.height - 20);
        for (NSInteger i = 0; i < 4; i ++) {
            UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(size.width * i, 0, size.width, size.height - 100)];
            tempView.backgroundColor = [UIColor randomColor];
            [_scrollView addSubview:tempView];
        }
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = 4;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

@end
