//
//  AppDelegate+Router.m
//  RoutesDemo2
//
//  Created by 胡金友 on 2018/4/27.
//

#import "AppDelegate+Router.h"
#import "Router.h"

@implementation AppDelegate (Router)

- (void)registerRouters {
    [[FTRouter routerForScheme:@"fr"] addHandler:^BOOL(FTRouterComponents *components) {
        [self alertWithComponents:components];
        return YES;
    }];
}

- (void)alertWithComponents:(FTRouterComponents *)components {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Place Result" message:[NSString stringWithFormat:@"%@\n%@", components.queryParams, components.additionalParams] preferredStyle:UIAlertControllerStyleAlert];
    
    if (components.followedURL) {
        [alert addAction:[UIAlertAction actionWithTitle:@"GoBack" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:components.followedURL];
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [[self.window ft_topViewController] presentViewController:alert animated:YES completion:nil];
    
}

@end
