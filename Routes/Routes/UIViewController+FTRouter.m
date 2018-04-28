//
//  UIViewController+FTRouter.m
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/27.
//

#import "UIViewController+FTRouter.h"
#import "FTRouterComponents.h"
#import "_FTRouterTools.h"
#import "FTRouter.h"
#import "NSObject+FTRouterAssociated.h"

@implementation UIViewController (FTRouter)

- (BOOL)transitionWithRouterComponents:(FTRouterComponents *)components {
    
    if (_FT_IS_VALIDATE_STRING_(components.destination)) {
        Class cls = NSClassFromString(components.destination);
        if (cls) {
            id dest = [[cls alloc] init];
            if ([dest isKindOfClass:[UIViewController class]]) {
                
                [dest mergeParamsFromComponents:components transitionFrom:self];
                
                FTRouterTransitionType transitionType = components.transitionType;
                if (transitionType == FTRouterTransitionTypeDefault &&
                    !([self isKindOfClass:[UINavigationController class]] || self.navigationController)) {
                    transitionType = FTRouterTransitionTypePresent;
                }
                
                if ([FTRouter shared].willTransitionInspector) {
                    dest = [FTRouter shared].willTransitionInspector(components.transitionType, dest);
                    
                    if (![dest isKindOfClass:[UIViewController class]]) {
                        return NO;
                    }
                }
                
                if ([self conformsToProtocol:@protocol(FTTransitionDelegate)] &&
                    [self respondsToSelector:@selector(pageWillTransitionTo:withURL:)]) {
                    [(id<FTTransitionDelegate>)self pageWillTransitionTo:dest withURL:components.originalURL];
                }
                
                if (transitionType == FTRouterTransitionTypePresent) {
                    [self presentViewController:dest animated:YES completion:nil];
                } else {
                    if ([self isKindOfClass:[UINavigationController class]]) {
                        [(UINavigationController *)self pushViewController:dest animated:YES];
                    } else if (self.navigationController != nil) {
                        [self.navigationController pushViewController:dest animated:YES];
                    } else {
                        if (transitionType == FTRouterTransitionTypeDefault) {
                            [self presentViewController:dest animated:YES completion:nil];
                        } else {
                            NSString *errorInfo = [NSString stringWithFormat:@"从<%@>跳转到<%@>失败，URL<%@>", self, dest, components.originalURL];
                            return [self _transitionWithErrorInfo:errorInfo desitination:dest URL:components.originalURL];
                        }
                    }
                }
                
                if ([self conformsToProtocol:@protocol(FTTransitionDelegate)] &&
                    [self respondsToSelector:@selector(pageDidTransitionTo:withURL:)]) {
                    [(id<FTTransitionDelegate>)self pageDidTransitionTo:dest withURL:components.originalURL];
                }
                
            } else {
                NSString *errorInfo = [NSString stringWithFormat:@"跳转的类不是`UIViewController`的子类"];
                return [self _transitionWithErrorInfo:errorInfo desitination:nil URL:components.originalURL];
            }
        } else {
            NSString *errorInfo = [NSString stringWithFormat:@"跳转的类<%@>不是一个有效的类名", components.destination];
            return [self _transitionWithErrorInfo:errorInfo desitination:nil URL:components.originalURL];
        }
    } else {
        NSString *errorInfo = [NSString stringWithFormat:@"没有注册[%@]对应的类", components.originalURL];
        return [self _transitionWithErrorInfo:errorInfo desitination:nil URL:components.originalURL];
    }
    
    return YES;
}

- (BOOL)_transitionWithErrorInfo:(NSString *)errorInfo desitination:(id)dest URL:(NSURL *)URL {
    if ([self conformsToProtocol:@protocol(FTTransitionDelegate)] &&
        [self respondsToSelector:@selector(pageTransitionTo:withURL:failedWithError:)]) {
        NSError *error = [NSError errorWithDomain:FTRouterDomain code:FTTransitionErrorCode userInfo:@{@"error" : errorInfo}];
        [(id <FTTransitionDelegate>)self pageTransitionTo:dest withURL:URL failedWithError:error];
    }
    
    return NO;
}

@end
