//
//  FTRouterURLCoder.m
//  RoutesDemo
//
//  Created by 胡金友 on 2018/5/4.
//

#import "FTRouterURLCoder.h"
#import "FTRouterTools.h"

@implementation FTRouterURLCoder

@end

@implementation NSURL (FTRouterURLCoder)

+ (instancetype)URLWithString:(NSString *)URLString parameters:(NSDictionary *)paramters {
    return _FT_IS_VALIDATE_STRING_(URLString) ? [[NSURL URLWithString:URLString] appendParameters:paramters] : nil;
}

- (instancetype)appendParameters:(NSDictionary *)parameters {
    return [[NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO] appendParameters:parameters].URL;
}

@end

@implementation NSString (FTRouterURLCoder)

- (NSURL *)routerURL {
    return [self routerURLWithParameters:nil];
}

- (NSURL *)routerURLWithParameters:(NSDictionary *)parameters {
    return [[NSURLComponents componentsWithString:self] appendParameters:parameters].URL;
}

@end

@implementation NSURLComponents (FTRouterURLCoder)

- (instancetype)appendParameters:(NSDictionary *)parameters {
    if (parameters) {
        NSMutableArray *queryItems = [[NSMutableArray alloc] init];
        for (NSString *key in parameters) {
            id value = parameters[key];
            value = [value isKindOfClass:[NSString class]] ? value : [NSString stringWithFormat:@"%@", value];
            [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:value]];
        }
        self.queryItems = queryItems;
    }
    
    return self;
}

- (NSDictionary *)queryParameters {
    NSMutableDictionary *queryParams = [NSMutableDictionary dictionary];
    if (self.queryItems) {
        for (NSURLQueryItem *item in self.queryItems) {
            if (item.value == nil) {
                continue;
            }
            if (queryParams[item.name] == nil) {
                queryParams[item.name] = item.value;
            }
        }
    }
    
    return queryParams.allKeys.count > 0 ? queryParams : nil;
}

@end
