//
//  NSObject+FTRouterAssociated.h
//  Router
//
//  Created by 胡金友 on 2018/4/25.
//

#import <Foundation/Foundation.h>
#import "FTRouterDefinition.h"

/*
 用于对跳转到的页面保存一些传递的参数
 */

@interface NSObject (FTRouterAssociated)

/**
 从哪里跳转过来的
 
 可以在调用`router`的`handlerBlock`的时候自己设置，
 也可以调用`mergeParamsFromComponents:transitionFrom:`来实现
 */
@property (nonatomic, weak) id trans_from;

/**
 页面跳转的时候附带的参数，包括url中的query部分和附加的参数
 
 可以在调用`router`的`handlerBlock`的时候自己设置，
 也可以调用`mergeParamsFromComponents:transitionFrom:`来实现
 */
@property (nonatomic, strong) NSDictionary *trans_params;

/**
 在`Router`执行跳转的时候附带的回调`block`，用于在目标页面对上级页面做一些数据的回传和控制等。
 
 可以在调用`router`的`handlerBlock`的时候自己设置，
 也可以调用`mergeParamsFromComponents:transitionFrom:`来实现
 */
@property (nonatomic, copy) FTRouterCallBack trans_callback;

@end


@interface NSObject (FTRouterMerger)

/**
 将`Router`跳转时所附带的参数列表、附加的信息、解析URL获得数据等映射给当前的对象。
 比如 `A` -> `B`，需要`B`即要跳转到的目标页面来调用。
 这里主要映射的是`NSObject (FTRouterAssociated)`里提到的几个参数。

 @param components `Router`中用于保存跳转信息和解析得到的信息的对象
 @param transitionFrom 从哪个页面跳转过来的，可以设置也可以不设置
 */
- (instancetype)mergeParamsFromComponents:(FTRouterComponents *)components transitionFrom:(id)transitionFrom;
- (instancetype)mergeParamsFromComponents:(FTRouterComponents *)components;


/**
 将字典里的有效信息映射到当前对象。
 
 比如有这样一个字典:
 
 `{ propertyA : valueA, propertyB : valueB, propertyC : valueC }`
 
 在遍历映射的时候，会根据每一个`key`去当前对象里找对应的属性，如果存在就会把对应的`value`赋值过去，否则的话，就丢弃。
 */
- (instancetype)mergeParamsFromDictionary:(NSDictionary *)paramsDictionary;

@end
