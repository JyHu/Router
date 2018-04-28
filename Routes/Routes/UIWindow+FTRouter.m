//
//  UIWindow+FTRouter.m
//  Router
//
//  Created by 胡金友 on 2018/4/25.
//

#import "UIWindow+FTRouter.h"

@implementation UIWindow (FTRouter)

- (UIViewController *)ft_topViewController {
    return [self ft_topViewControllerWithExceptBlock:nil];
}

- (UIViewController *)ft_topViewControllerWithExceptClasses:(NSArray *)classes {
    return [self ft_topViewControllerWithExceptBlock:^BOOL(UIResponder *responder) {
        return classes && [classes containsObject:NSStringFromClass([responder class])];
    }];
}

- (UIViewController *)ft_topViewControllerWithExceptBlock:(BOOL (^)(UIResponder *))exceptBlock {
    UIViewController * curVC = nil;
    UIViewController * rootVC = self.rootViewController ;
    
    do {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            curVC = [((UINavigationController *)rootVC).viewControllers lastObject];
            rootVC = curVC.presentedViewController;
        } else if([rootVC isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)rootVC;
            curVC = tabVC;
            rootVC = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
        } else {
            curVC = rootVC;
            rootVC = rootVC.presentedViewController;
        }
        
        if (exceptBlock && exceptBlock(rootVC)) {
            rootVC = nil;
        }
    } while (rootVC!=nil);
    
    return curVC;
}

@end
