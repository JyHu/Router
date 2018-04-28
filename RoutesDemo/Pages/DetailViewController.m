//
//  DetailViewController.m
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/27.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *apperanceButton;
@property (nonatomic, strong) UIButton *riskButton;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.contract;
    
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [self.view addSubview:toolBar];
    [toolBar setItems:@[
                        [[UIBarButtonItem alloc] initWithTitle:@"Flash order" style:UIBarButtonItemStyleDone target:self action:@selector(flashOrder)],
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                        [[UIBarButtonItem alloc] initWithTitle:@"Apperance" style:UIBarButtonItemStyleDone target:self action:@selector(apperanceSetting)],
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                        [[UIBarButtonItem alloc] initWithTitle:@"Risk setting" style:UIBarButtonItemStyleDone target:self action:@selector(riskSetting)]
                        ]];
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
}

- (void)flashOrder {
    [FTRouter routeURL:[NSURL URLWithString:@"ft://order/flash"] withParameters:self.parameters];
}

- (void)apperanceSetting {
    [FTRouter routeURL:[NSURL URLWithString:@"ft://present/contract/apperance"]];
}

- (void)riskSetting {
    [FTRouter routeURL:[NSURL URLWithString:@"ft://contract/risk"]];
}

@end
