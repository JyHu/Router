//
//  FTRouter.h
//  Router
//
//  Created by 胡金友 on 2018/4/25.
//

#import <UIKit/UIKit.h>
#import "FTRouterDefinition.h"

#define FTRouterShared [FTRouter shared]

@interface FTRouter : NSObject

/**
 单例方法，用于做一些全局的缓存和配置等操作
 */
+ (instancetype)shared;

#pragma mark - 一些全局参数的设置，注意，必须使用`shared`单例方法来调用

/**
 用于全局的测试信息输出的控制属性。
 */
@property (nonatomic, assign) BOOL debugLogEnable;

/**
 用于对路由地址的解析控制。
 
 如果设置为YES，那么会对路由地址中的`host`拼到path中去当做path的开始，

 比如 'ft://market/contract/detail'，此时解析过的`path`会是`market/contract/detail`
 
 注意：对于`/`、`localhost`默认为一个有效的网址
 */
@property (nonatomic, assign) BOOL alwaysTreatsHostAsPathComponent;

/**
 用于对路由地址的解析控制，如果设置为YES，那么会对路由地址中的网址内容全部转为`/`，
 
 如 `ft://futures.com/market/detail`会被解析为`ft:///futures.com/market/detail`
 */
@property (nonatomic, assign) BOOL alwaysTreatsURLHostsAsRoot;

/**
 当前APP的`keyWindow`，即在`AppDelegate`中注册的`[UIApplication sharedApplication].keyWindow`，
 
 此处不用这种方法直接获取，首先是因为有的第三方会对`keyWindow`做替换，用于实现这些第三方自己的一些功能内容，
 
 还一个原因是因为在项目中有时候为了获取最高层级的展示效果或者一些弹窗的控制，会临时的更换`keyWindow`，
 
 以上这两种情况如果在跳转过程中发生都会出现跳转失败、找不到顶部视图等问题。
 
 设置了这个属性的话，如果没有实现`handlerBlock`，那么`Router`会根据注册了的页面路自己来执行页面的跳转等操作，
 
 对于自动跳转的操作可以使用`shouldAutoTransitionInspector`、`willTransitionInspector`来实现拦截和介入处理。
 */
@property (nonatomic, strong) UIWindow *keyWindow;

/**
 路由跳转外部实现的`block`，如果添加了这个`block`，那么在执行`Router`跳转的时候，
 
 会将路由跳转的一些解析到的信息都通过这`block`回传出去，由外部决定执行的操作
 */
@property (nonatomic, copy) BOOL (^handlerBlock)(FTRouterComponents *components);

/**
 在执行自动跳转的时候，用于跳转的拦截处理，用来决定是否可以执行自动跳转
 */
@property (nonatomic, copy) BOOL (^shouldAutoTransitionInspector)(FTRouterComponents *components);

/**
 在执行自动跳转的时候，用于改变目标对象的拦截操作。
 
 比如在执行`present`的时候，如果我需要目标页面时一个`UINavigationController`，
 
 那么就可以在这里做拦截处理，并返回一个`UINavigationCotontroller`或其子类
 */
@property (nonatomic, copy) id (^willTransitionInspector)(FTRouterComponents *components, UIViewController *topViewController);

/**
 当前APP全局的`scheme`，如果不设置这个参数，那么在执行路由地址注册、路由跳转的时候，必须带上`scheme`，
 
 否则会跳转失败或者注册失败。
 
 如果设置了这个参数，那么在执行上述操作的时候，如果没有发现有效的`scheme`，那么会使用这个注册了的`scheme`来执行操作。
 
 如果路由地址中带了`scheme`，那么还是以路由地址中的为主。
 */
@property (nonatomic, readonly, copy) NSString *defaultScheme;

#pragma mark - `scheme`的注册、销毁等操作

/**
 取消注册一个`scheme`，并删除注册了的所有路由信息
 */
+ (void)unregisterRouterWithScheme:(NSString *)scheme;

/**
 删除所有注册的`scheme`，和注册了的路由信息。
 */
+ (void)unregisterAllRouters;

/**
 注册一个路由信息，用于识别`APP`。
 
 对于`Router`的路由处理，必须有对应的`scheme`，如果没有注册，在接收到第三方比如QQ、微信、微博等的回调的时候，
 
 自动的为其注册或者处理了，会导致APP收不到第三方的回调等。
 
 对于`scheme`的注册，可以自己显式的调用这个方法注册，也可以在注册路由地址的时候带上`scheme`，
 
 这时候在注册路由地址的同时会自动的注册`scheme`。
 */
+ (BOOL)registerScheme:(NSString *)scheme;

/**
 批量的注册`scheme`，会遍历`schemes`并调用`registerScheme:`去注册。
 */
+ (void)registerSchemes:(NSArray <NSString *> *)schemes;

/**
 注册一个默认的`scheme`，详细见`defaultScheme`属性，只能注册一次，后续的注册都会丢弃。
 */
+ (BOOL)registerDefaultScheme:(NSString *)scheme;

/**
 用于判断一个`scheme`是否已经注册了。
 */
+ (BOOL)isRegisteredScheme:(NSString *)scheme;

#pragma mark - 页面地址的注册和获取等操作

/**
 注册一个路由地址，用于执行页面的跳转和信息的缓存。
 
 如果`path`里包含了`scheme`，那么会自动去检查是否注册并对未注册的`scheme`执行`registerScheme:`注册方法，
 
 如果没有，那么会取`defaultScheme`作为其`scheme`，如果都没有设置，那么会返回`NO`，即注册失败。

 - param path 要注册的路由地址，不可为空，需要注意`scheme`的处理。
 
              此处注册的`path`都会被删除掉开头的`/`，不过不用担心，在所有用到`path`的地方，
 
              在`Router`内部都会自动的处理，即使你加了`/`也没关系
 
 - param destName 此路由地址对应的类名
 */
+ (BOOL)registerPath:(NSString *)path withDestinationName:(NSString *)destName;

/**
 注册一个路由地址，用于执行页面的跳转和信息的缓存。
 
 此处会以`scheme`参数为主，如果`path`中也有`scheme`的话，会被忽略掉。
 
 如果此处有有效的`scheme`，那么会自动的去检查是否注册并对未注册的`scheme`执行`registerScheme:`注册方法，
 
 如果没有，那么会取`defaultScheme`作为其`scheme`，如果都没有设置，那么会返回`NO`，即注册失败。
 */
+ (BOOL)registerPath:(NSString *)path withScheme:(NSString *)scheme destinationName:(NSString *)destName;

/**
 取消注册一个路由地址，如果包含了`scheme`，那么会去注册的信息中去查找对应的有效`path`并删除，否则删除失败。
 
 注意，此处不会去主动的取`defaultScheme`。
 */
+ (void)unregisterURLString:(NSString *)URLString;

/**
 取消注册一个路由地址，如果`scheme`参数有效，那么会去注册的信息中去查找对应的有效`path`并删除，否则删除失败。
 
 注意，此处会忽略掉`path`中的`scheme`信息，而且此处不会去主动的取`defaultScheme`。
 */
+ (void)unregisterPath:(NSString *)path withScheme:(NSString *)scheme;

/**
 根据给定的`plist`文件信息来批量的注册路由信息。
 
 注册内部使用的是`registerWithDictionary:`方法。

 - param plistFile `plist`文件的地址，获取方式如：
 
     `[[NSBundle mainBundle] pathForResource:@"filename" ofType:@"plist"]`
 */
+ (BOOL)registerWithPlistFile:(NSString *)plistFile;

/**
 根据给定的`json`文件信息来批量的注册路由信息。
 
 注册内部使用的是`registerWithDictionary:`方法。
 
 - param jsonFile `json`文件的地址，获取方式如：
 
     `[[NSBundle mainBundle] pathForResource:@"filename" ofType:@"json"]`
 */
+ (BOOL)registerWithJSONFile:(NSString *)jsonFile;

/**
 根据给定的字典信息来批量的注册路由信息。
 
 内容必须是如示格式 `{'scheme://path' : 'destination name'}`，
 
 其`key`为包含有`scheme`的路由地址信息，其`value`为路由地址对应的目标类名。
 */
+ (BOOL)registerWithDictionary:(NSDictionary *)routesDictionary;

/**
 根据给定的路由地址信息来获取已经注册的对应的目标类名。
 
 如果`path`有`scheme`，则会根据给定的`scheme`和路由地址信息去查询目标类名，
 
 如果没有，会使用`defaultScheme`，如果还没有，则直接返回`nil`。
 */
+ (NSString *)destinationForPath:(NSString *)path;

/**
 根据给定的路由地址信息来获取已经注册的对应的目标类名。
 
 如果传递的`scheme`参数有效，则会根据给定的`scheme`和路由地址信息去查询目标类名，
 
 如果没有，会使用`defaultScheme`，如果还没有，则直接返回`nil`。
 
 注意，此处`path`中的`scheme`会被主动的忽略掉。
 */
+ (NSString *)destinationForPath:(NSString *)path withScheme:(NSString *)scheme;

@end

@interface FTRouter (FTTransition)

#pragma mark - 使用`router`进行跳转的方法

/**
 根据给定的`URL`执行一个指定的跳转动作。
 
 这里会根据`URL`里的`scheme`和`path`在已注册的列表里查找对应的目标类名，如果找到了，会根据处理方式来做不同的跳转处理。
 
 - `scheme`
 
    - 如果`URL`里有`scheme`，那么会直接用
 
    - 如果没有，那么会用`defaultScheme`
 
    - 如果都没有，那么就会执行失败，返回`NO`
 
 - path 此处处理path的时候，会对`path`的第一段信息进行判断，如果是`push`或者`present`，则会被解析为页面跳转的方式
 
 - handler
 
    - 如果设置了`handler`，则会调用`handler`交给外部执行跳转等逻辑的处理
 
    - 如果没有设置`handler`，但是注册了keyWindow，那么会自动的从`keyWindow`处枚举当前顶部的视图并执行跳转。
 
            在跳转的过程中，可以注册`willTransitionInspectorBlock`来对要跳转的视图做拦截处理
 
 - param URL 跳转处理的`URL`
 
 - param parameters 跳转附加的参数，跳转后会一起附加到`parameters`参数里
 
 - param callBack 回调的`block`，在跳转到的页面中可以调用`callback`参数来获取，具体看`NSObject+FTRouterAssociated`类
 
 - return 根据是否能够执行跳转，来返回执行的结果
 
 */

+ (BOOL)routeURL:(nullable NSURL *)URL parameters:(NSDictionary<NSString *,id> *)parameters callBack:(FTRouterCallBack)callBack;
+ (BOOL)routeURL:(nullable NSURL *)URL callBack:(FTRouterCallBack)callBack;
+ (BOOL)routeURL:(nullable NSURL *)URL parameters:(NSDictionary<NSString *, id> *)parameters;
+ (BOOL)routeURL:(nullable NSURL *)URL;


@end



extern NSErrorDomain const FTRouterDomain;
extern NSInteger FTTransitionErrorCode;

extern NSString *const FTPageTransitionTypePush;
extern NSString *const FTPageTransitionTypePresent;
extern NSString *const FTPageTransitionTypePageBack;
extern NSString *const FTPageTransitionTypeRoot;


