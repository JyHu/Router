//
//  FTRouter.m
//  Router
//
//  Created by 胡金友 on 2018/4/25.
//

#import "FTRouter.h"
#import "FTRouterMap.h"
#import "_FTRouterTools.h"
#import "FTRouterComponents.h"
#import "UIWindow+FTRouter.h"
#import "UIViewController+FTRouter.h"
#import "FTRouterComponents+FTExtension.h"

@interface FTRouter()

/**
 用于缓存注册的路由地址信息
 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, FTRouterMap *> *routerMaps;

@property (nonatomic, readwrite, copy) NSString *defaultScheme;

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
    if (scheme && _FT_IS_VALIDATE_STRING_(destName)) {
        NSString *path = _FT_UNIFY_PATH_([components routerPathWithTreatsHostAsPath:[FTRouter shared].alwaysTreatsHostAsPathComponent]);
        if (_FT_IS_VALIDATE_STRING_(path)) {
            FTRouterMap *routerMap = [self _mapWithAutoRegisteredScheme:scheme];
            
            if (routerMap) {
                [routerMap.destinationsMap setObject:destName forKey:path];
            }
            
            _FTRouterDebugLog(@"Register --> [Router `%@` : <`%@` - `%@`>]", scheme, path, destName);
            
            return YES;
        }
    }
    
    return NO;
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
        for (NSString *path in routesDictionary) {
            [self registerPath:path withDestinationName:routesDictionary[path]];
        }
        return YES;
    }
    return NO;
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
    NSString *path = _FT_UNIFY_PATH_(components.path);
    
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
    return [self routeURL:URL withParameters:nil];
}

+ (BOOL)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters {
    return [self routeURL:URL withParameters:parameters callBack:nil];
}

+ (BOOL)routeURL:(NSURL *)URL callBack:(FTRouterCallBack)callBack {
    return [self routeURL:URL withParameters:nil callBack:callBack];
}

+ (BOOL)routeURL:(NSURL *)URL withParameters:(NSDictionary<NSString *,id> *)parameters
        callBack:(FTRouterCallBack)callBack {
    return [self _router:URL parameters:parameters callBack:callBack];
}

+ (BOOL)_router:(NSURL *)URL parameters:(NSDictionary *)parameters
       callBack:(FTRouterCallBack)callback{
    
    NSString *scheme = URL.scheme ?: [FTRouter shared].defaultScheme;
    
    if (!URL || ![FTRouter isRegisteredScheme:scheme] ||
        (![FTRouter shared].handlerBlock && ![FTRouter shared].keyWindow)) {
        return NO;
    }
    
    FTRouterComponents *components = [[FTRouterComponents alloc] initWithURL:URL additionalParameters:parameters treatsHostAsPathComponent:[FTRouter shared].alwaysTreatsHostAsPathComponent defaultScheme:[FTRouter shared].defaultScheme];
    
    components.destination = [FTRouter destinationForPath:components.path withScheme:components.scheme];
    components.callback = callback;
    
    _FTRouterDebugLog(@"%@", components);
    
    if ([FTRouter shared].handlerBlock) {
        return [FTRouter shared].handlerBlock(components);
    }
    
    if ([FTRouter shared].keyWindow) {
        if (![FTRouter shared].autoTransitionInspector || ([FTRouter shared].autoTransitionInspector && [FTRouter shared].autoTransitionInspector(components))) {
            UIViewController *topViewController = [[FTRouter shared].keyWindow ft_topViewController];
            if ((topViewController && [topViewController isKindOfClass:[UIViewController class]])) {
                
                if (components.transitionType == FTRouterTransitionTypePageback) {
                    return [topViewController backtrackViewControllerAnimated:YES];
                }
                
                return [topViewController transitionWithRouterComponents:components];
            }
        }
    }
    
    return NO;
}

@end




NSErrorDomain const FTRouterDomain = @"com.ft.routerDomain";
NSInteger FTTransitionErrorCode = 20001;

NSString *const FTPageTransitionTypePush        = @"push";
NSString *const FTPageTransitionTypePresent     = @"present";
NSString *const FTPageTransitionTypePageBack    = @"back";
NSString *const FTPageTransitionTypeRoot        = @"root";
