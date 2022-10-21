//
//  FTRouter.m
//  Router
//
//  Created by 胡金友 on 2018/4/25.
//

#import "FTRouter.h"
#import "FTRouterMap.h"
#import "FTRouterTools.h"
#import "FTRouterComponents.h"
#import "UIWindow+FTRouter.h"
#import "UIViewController+FTRouter.h"
#import "FTRouterComponents+FTExtension.h"
#import <objc/runtime.h>

@interface FTRouter()

/**
 用于缓存注册的路由地址信息
 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, FTRouterMap *> *routerMaps;

@property (nonatomic, readwrite, copy) NSString *defaultScheme;

@property (nonatomic, strong, readwrite) id <FTRouterAdaptor> adaptor;

@end

@implementation FTRouter


+ (instancetype)shared {
    static FTRouter *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[FTRouter alloc] init];
        router.alwaysTreatsHostAsPathComponent = YES;
    });
    return router;
}

#pragma mark - 注册适配器

+ (void)registerAdaptor:(Class)adaptorCls {
    NSAssert(adaptorCls, @"请注册一个有效的适配器");
    NSAssert1(class_conformsToProtocol(adaptorCls, @protocol(FTRouterAdaptor)), @"所注册的适配器`%@`没有实现`FTRouterAdaptor`协议", NSStringFromClass(adaptorCls));
    [FTRouter shared].adaptor = [[adaptorCls alloc] init];
}

+ (void)checkAllRegisteredPath {
    for (FTRouterMap *map in [FTRouter shared].routerMaps.allValues) {
        for (NSString *path in map.destinationsMap) {
            NSString *dest = map.destinationsMap[path];
            if (NSClassFromString(dest) == NULL) {
                _FTRouterDebugLog(@"Invalidate path:%@ -> dest:%@", path, dest);
            }
        }
    }
}

#pragma mark - `scheme`的注册、销毁等操作

+ (void)unregisterRouterWithScheme:(NSString *)scheme {
    scheme = _FT_UNIFY_SCHEME_(scheme);
    if (_FT_UNIFY_SCHEME_(scheme)) {
        [[FTRouter shared].routerMaps removeObjectForKey:scheme];
    }
}

+ (void)unregisterAllRouters {
    [[FTRouter shared].routerMaps removeAllObjects];
}

+ (BOOL)registerDefaultScheme:(NSString *)scheme {
    if ([FTRouter shared].defaultScheme) {
        return NO;
    }
    
    if ([FTRouter registerScheme:scheme]) {
        [FTRouter shared].defaultScheme = _FT_UNIFY_SCHEME_(scheme);
        return YES;
    }
    
    return NO;
}

+ (void)registerSchemes:(NSArray<NSString *> *)schemes {
    if (schemes && schemes.count > 0) {
        for (NSString *scheme in schemes) {
            [self registerScheme:scheme];
        }
    }
}

+ (BOOL)registerScheme:(NSString *)scheme {
    return [self _registerRouterMap:[FTRouterMap mapWithScheme:scheme]];
}

+ (BOOL)_registerRouterMap:(FTRouterMap *)routerMap {
    if (routerMap) {
        if (routerMap.scheme) {
            // 避免重复注册导致数据丢失
            if (![[FTRouter shared].routerMaps objectForKey:routerMap.scheme]) {
                [[FTRouter shared].routerMaps setObject:routerMap forKey:routerMap.scheme];
            }
            
            return YES;
        }
    }
    return NO;
}

#pragma mark - 页面地址的注册和获取等操作

+ (BOOL)registerPath:(NSString *)path withDestinationName:(NSString *)destName {
    if (_FT_IS_VALIDATE_STRING_(path) && _FT_IS_VALIDATE_STRING_(destName)) {
        NSURLComponents *components = [NSURLComponents componentsWithString:path];
        return [self _registerWithURLComponents:components destinationName:destName];
    }
    
    return NO;
}

+ (BOOL)registerPath:(NSString *)path withScheme:(NSString *)scheme destinationName:(NSString *)destName {
    if (_FT_IS_VALIDATE_STRING_(path) && _FT_IS_VALIDATE_STRING_(destName)) {
        NSURLComponents *components = [NSURLComponents componentsWithString:path];
        components.scheme = scheme;
        return [self _registerWithURLComponents:components destinationName:destName];
    }
    
    return NO;
}

+ (BOOL)_registerWithURLComponents:(NSURLComponents *)components destinationName:(NSString *)destName {
    NSString *scheme = _FT_UNIFY_SCHEME_(components.scheme) ?: [FTRouter shared].defaultScheme;
    
    NSAssert1(scheme, @"无效的scheme `%@`", scheme);
    NSAssert1(_FT_IS_VALIDATE_STRING_(destName), @"无效的目标类名`%@`", destName);
    
    NSString *path = _FT_UNIFY_PATH_([components routerPathWithTreatsHostAsPath:[FTRouter shared].alwaysTreatsHostAsPathComponent]);
    
    NSAssert1(_FT_IS_VALIDATE_STRING_(path), @"无效的路由地址`%@`", path);
    
    FTRouterMap *routerMap = [self _mapWithAutoRegisteredScheme:scheme];
    
    if (routerMap) {
        [routerMap.destinationsMap setObject:destName forKey:path];
    }
    
    _FTRouterDebugLog(@"Register --> [Router `%@` : <`%@` - `%@`>]", scheme, path, destName);
    
    return YES;
}

+ (FTRouterMap *)_mapWithAutoRegisteredScheme:(NSString *)scheme {
    FTRouterMap *routerMap = [[FTRouter shared].routerMaps objectForKey:scheme];
    if (!routerMap) {
        routerMap = [FTRouterMap mapWithScheme:scheme];
        [self _registerRouterMap:routerMap];
    }
    return routerMap;
}

+ (void)unregisterURLString:(NSString *)URLString {
    if (_FT_IS_VALIDATE_STRING_(URLString)) {
        NSURLComponents *components = [NSURLComponents componentsWithString:URLString];
        [self _unregisterWithComponents:components];
    }
}

+ (void)unregisterPath:(NSString *)path withScheme:(NSString *)scheme {
    if (_FT_IS_VALIDATE_STRING_(path)) {
        NSURLComponents *components = [NSURLComponents componentsWithString:path];
        components.scheme = scheme;
        [self _unregisterWithComponents:components];
    }
}

+ (void)_unregisterWithComponents:(NSURLComponents *)components {
    NSString *scheme = _FT_UNIFY_SCHEME_(components.scheme);
    NSString *path = _FT_UNIFY_PATH_([components routerPathWithTreatsHostAsPath:FTRouterShared.alwaysTreatsHostAsPathComponent]);
    if (scheme && path) {
        FTRouterMap *routerMap = [[FTRouter shared].routerMaps objectForKey:scheme];
        if (routerMap) {
            [routerMap.destinationsMap removeObjectForKey:path];
        }
    }
}

+ (BOOL)registerWithPlistFile:(NSString *)plistFile {
    return [self registerWithDictionary:[NSDictionary dictionaryWithContentsOfFile:plistFile]];
}

+ (BOOL)registerWithJSONFile:(NSString *)jsonFile {
    return [self registerWithDictionary:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonFile] options:NSJSONReadingMutableContainers error:nil]];
}

+ (BOOL)registerWithDictionary:(NSDictionary *)routesDictionary {
    if (routesDictionary) {
        [self _registerWithDictionary:routesDictionary curPath:nil deepLevel:0];
        return YES;
    }
    return NO;
}

+ (void)_registerWithDictionary:(NSDictionary *)dict curPath:(NSString *)curPath deepLevel:(NSInteger)level {
    for (NSString *key in dict) {
        NSString *path = nil;
        if ([key isEqualToString:@"/"]) {
            path = nil;
        } else if ([key isEqualToString:@"."]) {
            path = curPath;
        } else if (level == 0) {
            path = [key stringByAppendingString:@"://"];
        } else if (level == 1) {
            path = [NSString stringWithFormat:@"%@%@", curPath ?: @"", key];
        } else {
            path = [NSString stringWithFormat:@"%@/%@", curPath, key];
        }

        id value = dict[key];
        if (value) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                [self _registerWithDictionary:value curPath:path deepLevel:level + 1];
            } else {
                [self registerPath:path withDestinationName:value];
            }
        }
    }
}


+ (BOOL)isRegisteredScheme:(NSString *)scheme {
    scheme = _FT_UNIFY_SCHEME_(scheme);
    return scheme ? ([[FTRouter shared].routerMaps objectForKey:scheme] ? YES : NO) : NO;
}

+ (NSString *)destinationForPath:(NSString *)path {
    if (_FT_IS_VALIDATE_STRING_(path)) {
        return [self _destinationWithURLComponents:[NSURLComponents componentsWithString:path]];
    }
    return nil;
}

+ (NSString *)destinationForPath:(NSString *)path withScheme:(NSString *)scheme {
    scheme = _FT_UNIFY_SCHEME_(scheme);
    if (scheme && _FT_IS_VALIDATE_STRING_(path)) {
        NSURLComponents *components = [NSURLComponents componentsWithString:path];
        components.scheme = scheme;
        return [self _destinationWithURLComponents:components];
    }
    
    return nil;
}

+ (NSString *)_destinationWithURLComponents:(NSURLComponents *)components {
    NSString *scheme = _FT_UNIFY_SCHEME_(components.scheme) ?: [FTRouter shared].defaultScheme;
    NSString *path = _FT_UNIFY_PATH_([components routerPathWithTreatsHostAsPath:[FTRouter shared].alwaysTreatsHostAsPathComponent]);
    
    if (scheme && path) {
        FTRouterMap *routerMap = [[FTRouter shared].routerMaps objectForKey:scheme];
        if (routerMap) {
            return [routerMap.destinationsMap objectForKey:path];
        }
    }
    
    return nil;
}

#pragma mark - getter and setter

- (NSMutableDictionary<NSString *,FTRouterMap *> *)routerMaps {
    if (!_routerMaps) {
        _routerMaps = [[NSMutableDictionary alloc] init];
    }
    return _routerMaps;
}

@end


@implementation FTRouter (FTTransition)

#pragma mark - 使用`router`进行跳转的方法

+ (BOOL)routeURL:(NSURL *)URL {
    return [self routeURL:URL parameters:nil];
}

+ (BOOL)routeURL:(NSURL *)URL parameters:(NSDictionary *)parameters {
    return [self routeURL:URL parameters:parameters callBack:nil];
}

+ (BOOL)routeURL:(NSURL *)URL callBack:(FTRouterCallBack)callBack {
    return [self routeURL:URL parameters:nil callBack:callBack];
}

+ (BOOL)routeURL:(NSURL *)URL parameters:(NSDictionary<NSString *,id> *)parameters
        callBack:(FTRouterCallBack)callBack {
    return [self _router:URL parameters:parameters callBack:callBack];
}

+ (BOOL)_router:(NSURL *)URL parameters:(NSDictionary *)parameters
       callBack:(FTRouterCallBack)callback{
    
    NSString *scheme = URL.scheme ?: [FTRouter shared].defaultScheme;
    id <FTRouterAdaptor> adaptor = [FTRouter shared].adaptor;
    
    if (!URL || ![FTRouter isRegisteredScheme:scheme] ||
        (!adaptor && ![FTRouter shared].keyWindow)) {
        return NO;
    }
    
    FTRouterComponents *components = [[FTRouterComponents alloc] initWithURL:URL additionalParameters:parameters treatsHostAsPathComponent:[FTRouter shared].alwaysTreatsHostAsPathComponent defaultScheme:[FTRouter shared].defaultScheme];
    
    components.destination = [FTRouter destinationForPath:components.path withScheme:components.scheme];
    components.callback = callback;
    
    _FTRouterDebugLog(@"%@", components);
    
    if (adaptor && [adaptor respondsToSelector:@selector(routerHandler:)]) {
        return [adaptor routerHandler:components];
    }
    
    if ([FTRouter shared].keyWindow) {
        if (!adaptor ||
            ![adaptor respondsToSelector:@selector(routerShouldAutoTransitionWith:topViewController:)] ||
            [adaptor routerShouldAutoTransitionWith:components topViewController:[FTRouter shared].keyWindow.ft_topViewController]) {
            
            if (components.transitionType == FTRouterTransitionTypeRoot) {
                return [[FTRouter shared].keyWindow changeRootViewControllerWithComponents:components];
            } else {
                UIViewController *topViewController = [[FTRouter shared].keyWindow ft_topViewController];
                if ((topViewController && [topViewController isKindOfClass:[UIViewController class]])) {
                    
                    if (components.transitionType == FTRouterTransitionTypePageback) {
                        return [topViewController backtrackViewControllerAnimated:YES];
                    }
                    
                    return [topViewController transitionWithRouterComponents:components];
                }
            }
        }
    }
    
    return NO;
}

@end




NSErrorDomain const FTRouterDomain = @"com.ft.routerDomain";
NSInteger FTTransitionErrorCode = 20001;

NSString *const FTTransitionTypePushKey        = @"push";
NSString *const FTTransitionTypePresentKey     = @"present";
NSString *const FTTransitionTypePageBackKey    = @"back";
NSString *const FTTransitionTypeRootKey        = @"root";
