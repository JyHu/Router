//
//  UIViewController+FTRouter.m
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/27.
//

#import "UIViewController+FTRouter.h"
#import "FTRouterComponents.h"
#import "FTRouterTools.h"
#import "FTRouter.h"
#import "NSObject+FTRouterAssociated.h"
#import <objc/runtime.h>

/*
 
        destination
            |
            |
            |              否
     能不能转成一个类(cls) -------->  没有注册的类
            |
            |能
            |
 是否有willTransitionInspector -------------------------->
            |                                           |
            |设置了block拦截block                         |
            |                                           |
 是否生成了一个UIViewController对象 ---------------> 使用cls生成一个对象
            |                                           |
            |                                           |
            |                                           |
            |                            是否是一个UIViewController的对象
            |                                           |
            |                                           |
            |<------------------------------------------|
            |
            |
            |
  根据跳转类型执行跳转等操作
 
 */

@implementation UIViewController (FTRouter)

- (BOOL)transitionWithRouterComponents:(FTRouterComponents *)components {
    
    if (_FT_IS_VALIDATE_STRING_(components.destination)) {
        
        Class cls = NSClassFromString(components.destination);
        id <FTRouterAdaptor> adaptor = [FTRouter shared].adaptor;
        if (cls) {
            
            id dest = nil;
            // 如果设置了拦截器，则使用拦截器从外部生成一个对象
            if (adaptor && [adaptor respondsToSelector:@selector(routerTransitionInspector:topViewController:)]) {
                dest = [adaptor routerTransitionInspector:components topViewController:self];
            }
            
            // 如果没有目标对象，而且当前的类是一个`UIViewController`子类，则生成一个对应的对象
            if (!dest && [cls isSubclassOfClass:[UIViewController class]]) {
                dest = [[cls alloc] init];
            }

            // 如果生成的目标对象是一个有效的`UIViewController`对象，那么就执行跳转的操作
            if (dest && [dest isKindOfClass:[UIViewController class]]) {
                
                // 解析跳转类型
                FTRouterTransitionType transitionType = components.transitionType;
                if (transitionType == FTRouterTransitionTypeDefault &&
                    !([self isKindOfClass:[UINavigationController class]] || self.navigationController)) {
                    transitionType = FTRouterTransitionTypePresent;
                }
                
                // 将当前跳转的参数映射到目标对象
                if ([dest isKindOfClass:cls]) {
                    [dest mergeParamsFromComponents:components transitionFrom:self];
                }
                
                // 执行`present`跳转
                if (transitionType == FTRouterTransitionTypePresent) {
                    [self presentViewController:dest animated:YES completion:nil];
                    return YES;
                } else {
                    // 如果当前是一个`UINavigationController`对象执行`push`跳转
                    if ([self isKindOfClass:[UINavigationController class]]) {
                        [(UINavigationController *)self pushViewController:dest animated:YES];
                        return YES;
                    }
                    // 如果当前是一个`UINavigationController`对象执行`push`跳转
                    else if (self.navigationController != nil) {
                        [self.navigationController pushViewController:dest animated:YES];
                        return YES;
                    }
                    // 当前的对象不是一个`UINavigationController`对象
                    else {
                        // 对于默认的跳转方式，只能执行`present`方式跳转
                        if (transitionType == FTRouterTransitionTypeDefault) {
                            [self presentViewController:dest animated:YES completion:nil];
                            return YES;
                        }
                        // 没有`UINavigationController`执行`push`跳转肯定失败
                        else {
                            _FTRouterDebugLog(@"从<%@>跳转到<%@>失败，URL<%@>", self, dest, components.originalURL);
                        }
                    }
                }
            } else {
                _FTRouterDebugLog(@"跳转的类不是`UIViewController`的子类");
            }
        } else {
            _FTRouterDebugLog(@"跳转的类<%@>不是一个有效的类名", components.destination);
        }
    } else {
        _FTRouterDebugLog(@"没有注册[%@]对应的类", components.originalURL);
    }
    
    return NO;
}

- (BOOL)backtrackViewControllerAnimated:(BOOL)animated {
    UINavigationController *navigationController = nil;
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        navigationController = (UINavigationController *)self;
    } else {
        navigationController = self.navigationController;
    }
    
    if (navigationController && navigationController.viewControllers.count > 1) {
        [navigationController popViewControllerAnimated:animated];
        
        return YES;
    }
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:animated completion:nil];
        
        return YES;
    }
    
    return NO;
}

@end
