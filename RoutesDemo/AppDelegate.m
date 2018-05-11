//
//  AppDelegate.m
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/26.
//

#import "AppDelegate.h"
#import "AppDelegate+Router.h"
#import "JMPme.h"
#import "GuidViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    [self registerRoutes];
    [FTRouter routeURL:[NSURL URLWithString:@"root/guide"]];

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [FTRouter routeURL:url parameters:options];
}

@end
