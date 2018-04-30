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
    
    [FTRouter shared].debugLogEnable = YES;
    
    // 注册了这个默认的`scheme`，那么在项目中使用路由地址的时候，可以带`scheme`，也可以不带了
    [FTRouter registerDefaultScheme:@"ft"];
    
    [FTRouter registerPath:@"ft://contract/apperance" withDestinationName:@"ApperanceSettingViewController"];
    [FTRouter registerPath:@"order/res" withDestinationName:@"ResViewController"];
    [FTRouter registerPath:@"contract/risk" withDestinationName:@"RiskSettingViewController"];
    [FTRouter registerWithPlistFile:[[NSBundle mainBundle] pathForResource:@"rt" ofType:@"plist"]];
    [FTRouter registerPath:@"guide" withDestinationName:@"GuidViewController"];
    [FTRouter registerPath:@"account/login" withDestinationName:@"LoginViewController"];
    
    [FTRouter shared].keyWindow = self.window;
    
    [[FTRouter shared] setWillTransitionInspector:^id(FTRouterComponents *components, UIViewController *topViewController) {
        if (components.transitionType == FTRouterTransitionTypePresent ||
            components.transitionType == FTRouterTransitionTypeRoot) {
            
            Class destCls = components.destination ? NSClassFromString(components.destination) : NULL;
            if (destCls != NULL && [destCls isSubclassOfClass:[UIViewController class]]) {
                UIViewController *destVC = [[destCls alloc] init];
                [destVC mergeParamsFromComponents:components transitionFrom:topViewController];
                return [[UINavigationController alloc] initWithRootViewController:destVC];
            }
        }
        return nil;
    }];
}

@end
