//
//  BaseViewController.m
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/27.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_centerY);
    }];
    
    self.textView.text = [NSString stringWithFormat:@"%@\n%@", NSStringFromClass([self class]), self.parameters ?: @""];
    
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = nil;
    } else if (self.presentingViewController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(pageDismiss)];
    }
}

- (void)pageDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.editable = NO;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = [UIColor redColor];
    }
    return _textView;
}

@end
