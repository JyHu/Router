//
//  UIViewController+FTRouter.h
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/27.
//

#import <UIKit/UIKit.h>

@class FTRouterComponents;

@interface UIViewController (FTRouter)

/**
 执行跳转的方法，主要是对于`UIWindow`的顶级视图使用
 
 用来根据`components`里的信息来执行页面的跳转(push/present)，只支持执行这两种跳转方式
 */
- (BOOL)transitionWithRouterComponents:(FTRouterComponents *)components;

/**
 执行页面的返回操作，会根据当前页面的类型，自动的选择返回的方式，
 
 会先判断是否可以`pop`，然后再判断是否可以`dismiss`。
 */
- (BOOL)backtrackViewControllerAnimated:(BOOL)animated;

@end
