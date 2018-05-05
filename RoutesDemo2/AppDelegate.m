//
//  AppDelegate.m
//  RoutesDemo2
//
//  Created by 胡金友 on 2018/4/27.
//

#import "AppDelegate.h"
#import "AppDelegate+Router.h"
#import "Router.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self registerRouters];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [FTRouter routeURL:url parameters:options];
}

@end
