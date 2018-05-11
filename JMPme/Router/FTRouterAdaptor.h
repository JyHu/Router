//
//  FTRouterAdaptor.h
//  JMPme
//
//  Created by 胡金友 on 2018/5/11.
//

#import <Foundation/Foundation.h>

@class FTRouterComponents;

@protocol FTRouterAdaptor <NSObject>

@optional

/**
 路由跳转外部实现的协议方法，如果实现了这个方法，那么在执行`Router`跳转的时候，
 
 会将路由跳转的一些解析到的信息都通过这`block`回传出去，由外部决定执行的操作
 */
- (BOOL)routerHandler:(FTRouterComponents *)components;

/**
 在执行自动跳转的时候，用于跳转的拦截处理，用来决定是否可以执行自动跳转
 */
- (BOOL)routerShouldAutoTransitionWith:(FTRouterComponents *)components topViewController:(UIViewController *)topVC;

/**
 在执行自动跳转的时候，用于改变目标对象的拦截操作。
 
 比如在执行`present`的时候，如果我需要目标页面时一个`UINavigationController`，
 
 那么就可以在这里做拦截处理，并返回一个`UINavigationCotontroller`或其子类
 */
- (UIViewController *)routerTransitionInspector:(FTRouterComponents *)components topViewController:(UIViewController *)topVC;

@end
