//
//  FTRouterDefinition.h
//  TigerRouter
//
//  Created by 胡金友 on 2018/4/25.
//

#ifndef FTRouterDefinition_h
#define FTRouterDefinition_h

@class FTRouterComponents;

/**
 页面跳转时传到目标页面的一个回调block，用于回传参数、上级页面的控制等
 */
typedef id (^FTRouterCallBack)(__weak id directedTarget, id userInfo);

/**
 页面跳转的方法

 - FTRouterTransitionTypeDefault: 默认的方式，如果当前是`UINavigationController`，则执行`push`否则执行`present`
 - FTRouterTransitionTypePush: 执行`push`，如果当前不是`UINavigationController`则无法跳转
 - FTRouterTransitionTypePresent: 执行`present`
 */
typedef NS_ENUM(NSUInteger, FTRouterTransitionType) {
    FTRouterTransitionTypeDefault       = 0,
    FTRouterTransitionTypePush          = 1,
    FTRouterTransitionTypePresent       = 2,
    
    FTRouterTransitionTypePageback      = 10,
};


#endif /* FTRouterDefinition_h */
