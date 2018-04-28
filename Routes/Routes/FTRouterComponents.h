//
//  FTRouterComponents.h
//  Router
//
//  Created by 胡金友 on 2018/4/26.
//

#import <Foundation/Foundation.h>
#import "FTRouterDefinition.h"

/**
 对于`Router`中跳转信息的保存的类。
 
 主要用于处理跳转的`URL`的解析，处理方式按照标准的`URL`的组成部分进行处理。
 
 主要处理用到的如下：
 
 scheme://host/path?query#fragment
 
 scheme - 用于对应唯一的一个注册的`FTRouter`对象
          注意：这里所有的`scheme`都默认是小写字母，不管外部在使用的时候是大写、小写还是混合的，在`Router`内部都会解析成小写字母的形式。
 
 path - 注册页面对应的唯一标识，在执行跳转的时候，如果`path`的第一部分是`push`或者`present`的时候，
        会解析为对应的页面跳转方式，需要注意的是，如果执行的是`push`，但是当前不是`UINavigationController`，
        那么就会导致跳转失败。
        如果第一部分不是这两种，那么跳转会被解析为默认的方式。
        注意：这里所有的`path`都默认前面不带`/`，如果带有的话，会被删除掉。
 
 host - 可以用来做模块的识别，如果`treatsHostAsPathComponent`为`YES`则会把`host`拼到path中去当做path的开始
        比如 'ft://market/contract/detail'，此时解析过的`path`会是`market/contract/detail`
 
 query - 查询参数，会被解析成字典的形式
 
 fragment - 会被解析成`followedURL`，如果原始的`fragment`里没有`scheme`，则会把当前`URL`的`scheme`拼接进去
 */

@interface FTRouterComponents : NSObject


@property (nonatomic, readonly, copy) NSString *scheme;
@property (nonatomic, readonly, copy) NSURL *originalURL;
@property (nonatomic, readonly, copy) NSString *host;
@property (nonatomic, readonly, copy) NSString *path;
@property (nonatomic, readonly, strong) NSArray *pathComponents;
@property (nonatomic, readonly, strong) NSDictionary *queryParams;
@property (nonatomic, readonly, strong) NSDictionary *additionalParams;
@property (nonatomic, readonly, assign) FTRouterTransitionType transitionType;
@property (nonatomic, readonly, copy) NSURL *followedURL;

@property (nonatomic, readonly, copy) FTRouterCallBack callback;
@property (nonatomic, readonly, copy) NSString *destination;

- (instancetype)initWithURL:(NSURL *)URL additionalParameters:(NSDictionary *)params treatsHostAsPathComponent:(BOOL)treatsHostAsPathComponent;
- (instancetype)initWithURL:(NSURL *)URL additionalParameters:(NSDictionary *)params treatsHostAsPathComponent:(BOOL)treatsHostAsPathComponent defaultScheme:(NSString *)defaultScheme;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end


