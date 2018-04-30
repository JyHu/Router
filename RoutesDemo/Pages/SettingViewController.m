//
//  SettingViewController.m
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/30.
//

#import "SettingViewController.h"
#import "FTRouter.h"

@implementation SettingViewController

- (IBAction)logout:(id)sender {
    [FTRouter routeURL:[NSURL URLWithString:@"root/account/login"]];
}

@end
