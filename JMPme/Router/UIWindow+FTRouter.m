//
//  UIWindow+FTRouter.m
//  Router
//
//  Created by 胡金友 on 2018/4/25.
//

#import "UIWindow+FTRouter.h"
#import "FTRouterComponents.h"
#import "FTRouter.h"
#import <objc/runtime.h>

@implementation UIWindow (FTRouter)

- (void)setUnlegallyViewControllerClasses:(NSArray<NSString *> *)unlegallyViewControllerClasses {
    objc_setAssociatedObject(self, @selector(unlegallyViewControllerClasses), unlegallyViewControllerClasses, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<NSString *> *)unlegallyViewControllerClasses {
    return objc_getAssociatedObject(self, @selector(unlegallyViewControllerClasses)) ?: @[];
}

- (UIViewController *)ft_topViewController {
    return [self ft_topViewControllerWithExceptClasses:nil];
}

- (UIViewController *)ft_topViewControllerWithExceptClasses:(NSArray *)classes {
    NSArray *clses = [classes ?: @[] arrayByAddingObjectsFromArray:self.unlegallyViewControllerClasses];
    return [self ft_topViewControllerWithExceptBlock:^BOOL(UIResponder *responder) {
        return clses && [clses containsObject:NSStringFromClass([responder class])];
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

- (BOOL)changeRootViewControllerWithComponents:(FTRouterComponents *)components {
    
    UIViewController *destPage = nil;
    
    if ([FTRouter shared].adaptor && [[FTRouter shared].adaptor respondsToSelector:@selector(routerTransitionInspector:topViewController:)]) {
        destPage = [[FTRouter shared].adaptor routerTransitionInspector:components topViewController:self.ft_topViewController];
    }
    
    if (!destPage) {
        destPage = components.destinationViewController;
    }
    
    if (destPage && [destPage isKindOfClass:[UIViewController class]]) {
        self.rootViewController = destPage;
        [self makeKeyAndVisible];
        return YES;
    }
    
    return NO;
}

@end
