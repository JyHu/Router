//
//  FTRouterMap.h
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/28.
//

#import <Foundation/Foundation.h>

/**
 缓存路由的地址信息，单独创建一个类，是为了以后如果有扩展的需求的话，可以做更多数据缓存和特定的操作
 */

@interface FTRouterMap : NSObject

/**
 缓存的`scheme`，此处的`scheme`为小写字母的字符串
 */
@property (nonatomic, readonly, copy) NSString *scheme;

/**
 类方法，用于创建一个`FTRouterMap`对象

 - param scheme 存储的时候会自动的转为小写字母的形式
 */
+ (instancetype)mapWithScheme:(NSString *)scheme;

/**
 缓存的路由地址信息， {路由地址 : 目标类名}
 */
@property (nonatomic, readonly, strong) NSMutableDictionary <NSString *, NSString *> *destinationsMap;

@end
