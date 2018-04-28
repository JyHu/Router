//
//  AppDelegate+Router.m
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/27.
//

#import "AppDelegate+Router.h"
#import "Router.h"

@implementation AppDelegate (Router)

- (void)registerRoutes {
    
    // 注册了这个默认的`scheme`，那么在项目中使用路由地址的时候，可以带`scheme`，也可以不带了
    [FTRouter registerDefaultScheme:@"ft"];
    
    [FTRouter registerPath:@"ft://contract/apperance" withDestinationName:@"ApperanceSettingViewController"];
    [FTRouter registerPath:@"order/res" withDestinationName:@"ResViewController"];
    [FTRouter registerPath:@"contract/risk" withDestinationName:@"RiskSettingViewController"];
    [FTRouter registerWithPlistFile:[[NSBundle mainBundle] pathForResource:@"rt" ofType:@"plist"]];
    
    [FTRouter shared].keyWindow = self.window;
    
    [[FTRouter shared] setWillTransitionInspector:^UIViewController *(FTRouterTransitionType transitionType, id destination) {
        if (transitionType == FTRouterTransitionTypePresent) {
            return [[UINavigationController alloc] initWithRootViewController:destination];
        }
        return destination;
    }];
}

@end
