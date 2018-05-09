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
    
    NSMutableString *info = [[NSMutableString alloc] init];
    [info appendFormat:@"%@\n", NSStringFromClass([self class])];
    if (self.trans_params) {
        [info appendString:@"parameters:\n"];
        for (NSString *key in self.trans_params.allKeys) {
            [info appendFormat:@"   - %@ : %@\n", key, self.trans_params[key]];
        }
    }
    self.textView.text = info;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(pageDismiss)];
}

- (void)pageDismiss {
    [FTRouter routeURL:[NSURL URLWithString:@"back"]];
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
