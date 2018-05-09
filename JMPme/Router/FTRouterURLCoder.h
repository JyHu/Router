//
//  FTRouterURLCoder.h
//  RoutesDemo
//
//  Created by 胡金友 on 2018/5/4.
//

#import <Foundation/Foundation.h>


/*
 使用`NSURLComponents`来处理传递参数为中文时乱码的问题
 */


@interface FTRouterURLCoder : NSObject

@end

@interface NSURL (FTRouterURLCoder)

+ (instancetype)URLWithString:(NSString *)URLString parameters:(NSDictionary *)paramters;
- (instancetype)appendParameters:(NSDictionary *)parameters;

@end


@interface NSString (FTRouterURLCoder)

- (NSURL *)routerURL;
- (NSURL *)routerURLWithParameters:(NSDictionary *)parameters;

@end

@interface NSURLComponents (FTRouterURLCoder)

- (instancetype)appendParameters:(NSDictionary *)parameters;

@property (nonatomic, strong, readonly) NSDictionary *queryParameters;

@end
