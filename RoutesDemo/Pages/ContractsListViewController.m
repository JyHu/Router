//
//  ContractsListViewController.m
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/27.
//

#import "ContractsListViewController.h"

@interface ContractsListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ContractsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.title = @"Contracts list";
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self randomDatas];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
    self.navigationItem.rightBarButtonItems =
    @[
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)],
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(settingAction)]
    ];
}

- (void)editAction {
    __weak typeof(self) weakself = self;
    // 带回调block
    [FTRouter routeURL:[NSURL URLWithString:@"ft://present/contract/edit"] withParameters:@{@"datas" : self.datas} callBack:^id(__weak id directedTarget, id userInfo) {
        __strong typeof(weakself) strongSelf = weakself;
        [strongSelf randomDatas];
        return nil;
    }];
}

- (void)search {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"ft://present/market/search?keywords=FTmain"]];
}

- (void)settingAction {
    [FTRouter routeURL:[NSURL URLWithString:@"account/setting"]];
}

- (void)randomDatas {
    [self.datas removeAllObjects];
    
    for (NSInteger i = 0; i < arc4random_uniform(100) + 5; i ++) {
        [self.datas addObject:[self contractName]];
    }
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusefulIdentifier = @"reusefulIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusefulIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusefulIdentifier];
    }
    
    cell.textLabel.text = self.datas[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [FTRouter routeURL:[NSURL URLWithString:@"push/contract/detail"]
        withParameters:@{@"contract" : self.datas[indexPath.row]}];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (NSString *)contractName {
    NSString *base = @"0123456789qwertyuiopasdfghjklzxcvbnm";
    NSMutableString *res = [[NSMutableString alloc] initWithString:@"contract"];
    for (NSInteger i = 0; i < 1 + arc4random_uniform(10); i ++) {
        [res appendFormat:@"%c", [base characterAtIndex:arc4random_uniform((uint32_t)base.length)]];
    }
    return res;
}

@end
