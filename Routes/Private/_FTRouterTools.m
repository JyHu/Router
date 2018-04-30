//
//  _FTRouterTools.m
//  Router
//
//  Created by 胡金友 on 2018/4/25.
//

#import "_FTRouterTools.h"
#import "FTRouter.h"

void _FTRouterDebugLog(NSString *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    if ([FTRouter shared].debugLogEnable) {
        printf("[Router Debug Log] %s\n", [[[NSString alloc] initWithFormat:fmt arguments:args] UTF8String]);
    }
    va_end(args);
}

@implementation _FTRouterTools

+ (BOOL)isValidateString:(NSString *)string {
    if (string == nil || string == NULL || [string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    if ([string isKindOfClass:[NSString class]]) {
        return [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 ? NO : YES;
    }
    
    return NO;
}

+ (NSString *)unifyScheme:(NSString *)scheme {
    if ([self isValidateString:scheme]) {
        return [scheme lowercaseString];
    }
    return nil;
}

+ (NSString *)unifyPath:(NSString *)path {
    if ([self isValidateString:path]) {
        if ([path characterAtIndex:0] == '/') {
            return [self unifyPath:[path substringFromIndex:1]];
        }
        return path;
    }
    
    return nil;
}

@end


@implementation NSURL (_FTRouterTools)

- (NSString *)routerPathWithTreatsHostAsPath:(BOOL)treatHostAsPath {
    if (treatHostAsPath && ![self.host isEqualToString:@"/"] &&
        ![self.host isEqualToString:@"localhost"] &&
        [self.host rangeOfString:@"."].location == NSNotFound) {
        return [NSString stringWithFormat:@"%@%@", self.host, self.path];
    } else {
        return self.path;
    }
}

@end

@implementation NSURLComponents (_FTRouterTools)

- (NSString *)routerPathWithTreatsHostAsPath:(BOOL)treatHostAsPath {
    if (treatHostAsPath && ![self.host isEqualToString:@"/"] &&
        ![self.host isEqualToString:@"localhost"] &&
        [self.host rangeOfString:@"."].location == NSNotFound) {
        return [NSString stringWithFormat:@"%@%@", self.host, self.path];
    } else {
        return self.path;
    }
}

@end
