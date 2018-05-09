//
//  LoginViewController.m
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/30.
//

#import "LoginViewController.h"
#import "JMPme.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)loginAction:(id)sender {
    [FTRouter routeURL:[NSURL URLWithString:@"present/contract/list"]];
}


@end
