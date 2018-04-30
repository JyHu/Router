//
//  UIViewController+FTRouter.h
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/27.
//

#import <UIKit/UIKit.h>

@class FTRouterComponents;

@protocol FTTransitionDelegate

- (void)pageWillTransitionTo:(id)target withURL:(NSURL *)URL;
- (void)pageDidTransitionTo:(id)target withURL:(NSURL *)URL;
- (void)pageTransitionTo:(id)target withURL:(NSURL *)URL failedWithError:(NSError *)error;

@end

@interface UIViewController (FTRouter)

/**
 执行跳转的方法，主要是对于`UIWindow`的顶级视图使用
 
 用来根据`components`里的信息来执行页面的跳转(push/present)，只支持执行这两种跳转方式
 */
- (BOOL)transitionWithRouterComponents:(FTRouterComponents *)components;

- (BOOL)backtrackViewControllerAnimated:(BOOL)animated;

@end
