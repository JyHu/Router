//
//  AppDelegate.m
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/26.
//

#import "AppDelegate.h"
#import "AppDelegate+Router.h"
#import "Router.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerRoutes];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [FTRouter routeURL:url withParameters:options];
}

@end
