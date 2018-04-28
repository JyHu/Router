//
//  FlashOrderViewController.m
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/27.
//

#import "FlashOrderViewController.h"

@interface FlashOrderViewController ()

@property (nonatomic, strong) UILabel *testLabel;

@end

@implementation FlashOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Flash Order";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Place" style:UIBarButtonItemStyleDone target:self action:@selector(placeOrder)];
    
    [self.view addSubview:self.testLabel];
    
    [self.testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_centerY);
    }];
}

- (void)placeOrder {
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tips" message:@"测试，下单成功还是失败" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"成功了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *res = @"fr://place/res?orderId=asod890a8sd09fasd";
        [self.navigationController popViewControllerAnimated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:res]];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"成功了，再回来" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *res = @"fr://place/res?orderId=97as8d789asd#ft://order/res";
        [self.navigationController popViewControllerAnimated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:res]];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"失败了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UILabel *)testLabel {
    if (!_testLabel) {
        _testLabel = [[UILabel alloc] init];
        _testLabel.numberOfLines = 0;
        _testLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _testLabel.font = [UIFont systemFontOfSize:18];
        _testLabel.textColor = [UIColor redColor];
        _testLabel.textAlignment = NSTextAlignmentCenter;
        _testLabel.text = @"这里是下单的页面，不是详情页，别搞错了。";
    }
    return _testLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
