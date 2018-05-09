//
//  FTRouterTools.h
//  JMPme
//
//  Created by 胡金友 on 2018/5/9.
//

#import <Foundation/Foundation.h>
#import "FTRouterDefinition.h"

#define _FT_IS_VALIDATE_STRING_(str) [FTRouterTools isValidateString:str]
#define _FT_UNIFY_SCHEME_(scheme) [FTRouterTools unifyScheme:scheme]
#define _FT_UNIFY_PATH_(path) [FTRouterTools unifyPath:path]

/**
 输出调试内容
 */
void _FTRouterDebugLog(NSString *fmt, ...);

@interface FTRouterTools : NSObject

/**
 用于判断是否是有效的字符串对象
 */
+ (BOOL)isValidateString:(NSString *)string;

/**
 处理`scheme`，会将所有的大写字母全都转为小写字母。
 
 如果最后没有有效的`path`，会返回nil
 */
+ (NSString *)unifyScheme:(NSString *)scheme;

/**
 处理`path`，如果开头有`/`会被删除掉。
 
 如果最后没有有效的`path`，会返回nil
 */
+ (NSString *)unifyPath:(NSString *)path;

@end


@interface NSURL (FTRouterTools)

/**
 根据给定的参数处理`path`
 
 @param treatHostAsPath
 - YES   会将有效的host(不是`/`、`localhost`，并且不是URL)拼接进`path`中
 - NO    直接拿`path`
 
 @return 处理过的开头不带`/`的路径
 */
- (NSString *)routerPathWithTreatsHostAsPath:(BOOL)treatHostAsPath;

@end

@interface NSURLComponents (FTRouterTools)

/**
 根据给定的参数处理`path`
 
 @param treatHostAsPath
 - YES   会将有效的host(不是`/`、`localhost`，并且不是URL)拼接进`path`中
 - NO    直接拿`path`
 
 @return 处理过的开头不带`/`的路径
 */
- (NSString *)routerPathWithTreatsHostAsPath:(BOOL)treatHostAsPath;

@end
