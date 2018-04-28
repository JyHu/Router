//
//  NSObject+FTRouterAssociated.m
//  Router
//
//  Created by 胡金友 on 2018/4/25.
//

#import "NSObject+FTRouterAssociated.h"
#import <objc/runtime.h>
#import "FTRouterComponents.h"

@interface _FTRouterWeakAssociatedObject : NSObject
@property (nonatomic, weak) id transitionFrom;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, copy) FTRouterCallBack callback;
@end
@implementation _FTRouterWeakAssociatedObject
@end

@implementation NSObject (FTRouterAssociated)

- (_FTRouterWeakAssociatedObject *)ft_weakAssociatedObject {
    _FTRouterWeakAssociatedObject *associatedObject = objc_getAssociatedObject(self, @selector(ft_weakAssociatedObject));
    if (associatedObject == nil) {
        associatedObject = [[_FTRouterWeakAssociatedObject alloc] init];
        objc_setAssociatedObject(self, @selector(ft_weakAssociatedObject), associatedObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return associatedObject;
}

- (void)setTransitionFrom:(id)transitionFrom {
    [self ft_weakAssociatedObject].transitionFrom = transitionFrom;
}

- (id)transitionFrom {
    return [self ft_weakAssociatedObject].transitionFrom;
}

- (void)setParameters:(NSDictionary *)parameters {
    [self ft_weakAssociatedObject].parameters = parameters;
}

- (NSDictionary *)parameters {
    return [self ft_weakAssociatedObject].parameters;
}

- (void)setCallback:(FTRouterCallBack)callback {
    [self ft_weakAssociatedObject].callback = callback;
}

- (FTRouterCallBack)callback {
    return [self ft_weakAssociatedObject].callback;
}

@end


@implementation NSObject (FTRouterMerger)

- (void)mergeParamsFromComponents:(FTRouterComponents *)components {
    [self mergeParamsFromComponents:components transitionFrom:nil];
}

- (void)mergeParamsFromComponents:(FTRouterComponents *)components transitionFrom:(id)transitionFrom {
    self.transitionFrom = transitionFrom;
    self.callback = [components.callback copy];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    if (components.queryParams) {
        [parameters addEntriesFromDictionary:components.queryParams];
    }
    
    if (components.additionalParams) {
        [parameters addEntriesFromDictionary:components.additionalParams];
    }
    
    [self mergeParamsFromDictionary:parameters];
    
    self.parameters = parameters.allKeys.count > 0 ? parameters : nil;
}

- (void)mergeParamsFromDictionary:(NSDictionary *)paramsDictionary {
    if (paramsDictionary) {
        for (NSString *key in paramsDictionary) {
            objc_property_t property_t = class_getProperty([self class], key.UTF8String);
            if (property_t != NULL) {
                [self setValue:paramsDictionary[key] forKey:key];
            }
        }
    }
}

@end
