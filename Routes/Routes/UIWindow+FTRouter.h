//
//  UIWindow+FTRouter.h
//  Router
//
//  Created by 胡金友 on 2018/4/25.
//

#import <UIKit/UIKit.h>

@class FTRouterComponents;

@interface UIWindow (FTRouter)

/**
 对于`UIWindow`的扩充，用于遍历去寻找最顶层的视图控制器，
 
 增加了两个用于过滤的属性，比如一个页面弹出了一个`UIAlertController`，
 由于`alert`也是继承自`UIViewController`的，但是又不能用它执行页面的跳转，
 比如`present`，所以需要对此类的视图进行一下过滤：
 
 - param exceptBlock 对当前枚举到的页面进行判断，如果返回了YES，则说明这个类是一个无效的页面
 - param classes 需要过滤掉的页面

 @return 最顶层的视图控制器
 */



- (UIViewController *)ft_topViewControllerWithExceptBlock:(BOOL (^)(UIResponder *responder))exceptBlock;
- (UIViewController *)ft_topViewControllerWithExceptClasses:(NSArray *)classes;
- (UIViewController *)ft_topViewController;

/**
 切换跟视图控制器
 */
- (BOOL)changeRootViewControllerWithComponents:(FTRouterComponents *)components;

@end
