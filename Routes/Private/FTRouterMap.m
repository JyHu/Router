//
//  FTRouterMap.m
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/28.
//

#import "FTRouterMap.h"
#import "_FTRouterTools.h"

@interface FTRouterMap()

@property (nonatomic, readwrite, copy) NSString *scheme;

@property (nonatomic, readwrite, strong) NSMutableDictionary <NSString *, NSString *> *destinationsMap;

@end

@implementation FTRouterMap

+ (instancetype)mapWithScheme:(NSString *)scheme {
    scheme = _FT_UNIFY_SCHEME_(scheme);
    if (scheme) {
        FTRouterMap *routerMap = [[FTRouterMap alloc] init];
        routerMap.scheme = scheme;
        return routerMap;
    }
    return nil;
}

- (NSMutableDictionary<NSString *,NSString *> *)destinationsMap {
    if (!_destinationsMap) {
        _destinationsMap = [[NSMutableDictionary alloc] init];
    }
    return _destinationsMap;
}

@end
