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

/**
 用于区分APP信息
 */
@property (nonatomic, readonly, copy) NSString *scheme;

/**
 执行`Router`跳转的时候原始的URL
 */
@property (nonatomic, readonly, copy) NSURL *originalURL;

/**
 执行URL跳转的时候处理过的`host`
 */
@property (nonatomic, readonly, copy) NSString *host;

/**
 执行`URL`跳转的时候处理过的`path`
 
 注意：此处的`path`处理，如果在`Router`中设置了`alwaysTreatsHostAsPathComponent`为`YES`的话，
 
    会把当前跳转的`URL`中有效的`host`添加到`path`中；
 
    在最后会对`path`做处理，删除掉开头的`/`，如果`path`的第一部分是`push`、`present`的话，会被解析为跳转的方式，即下面的`transitionType`
 */
@property (nonatomic, readonly, copy) NSString *path;

/**
 对`path`的分段
 */
@property (nonatomic, readonly, strong) NSArray *pathComponents;

/**
 对`URL`的`query`部分做的拆分处理
 */
@property (nonatomic, readonly, strong) NSDictionary *queryParams;

/**
 在执行`Router`的跳转的时候，附加的传递过来的参数列表
 */
@property (nonatomic, readonly, strong) NSDictionary *additionalParams;

/**
 解析`Router`跳转的时候`path`的第一部分，如果是`push`或者`present`，
 
 则会分别解析为`FTRouterTransitionTypePush`和`FTRouterTransitionTypePresent`，
 
 如果没有指定跳转类型，则会默认为`FTRouterTransitionTypeDefault`。
 */
@property (nonatomic, readonly, assign) FTRouterTransitionType transitionType;

/**
 执行`Router`跳转的时候`URL`中的`fragment`部分，如果没有`scheme`的话，
 
 会把当前跳转的`URL`的`scheme`添加进去。
 
 这个的用处在于跳转以后让目标页面执行一些指定的操作。
 */
@property (nonatomic, readonly, copy) NSURL *followedURL;

/**
 在执行`Router`跳转的时候附带的回调`block`。
 */
@property (nonatomic, readonly, copy) FTRouterCallBack callback;

/**
 在`Router`中注册的`path`对应的目标类名或者动作名。
 */
@property (nonatomic, readonly, copy) NSString *destination;

- (instancetype)initWithURL:(NSURL *)URL additionalParameters:(NSDictionary *)params treatsHostAsPathComponent:(BOOL)treatsHostAsPathComponent;
- (instancetype)initWithURL:(NSURL *)URL additionalParameters:(NSDictionary *)params treatsHostAsPathComponent:(BOOL)treatsHostAsPathComponent defaultScheme:(NSString *)defaultScheme;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end


