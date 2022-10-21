//
//  NSObject+FTRouterAssociated.m
//  Router
//
//  Created by 胡金友 on 2018/4/25.
//

#import "NSObject+FTRouterAssociated.h"
#import <objc/runtime.h>
#import "FTRouter.h"
#import "FTRouterComponents.h"

@interface _FTRouterWeakAssociatedObject : NSObject
@property (nonatomic, weak) id stored_transitionFrom;
@property (nonatomic, strong) NSDictionary *stored_parameters;
@property (nonatomic, copy) FTRouterCallBack stored_callback;
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

- (void)setTrans_from:(id)trans_from {
    [self ft_weakAssociatedObject].stored_transitionFrom = trans_from;
}

- (id)trans_from {
    return [self ft_weakAssociatedObject].stored_transitionFrom;
}

- (void)setTrans_params:(NSDictionary *)trans_params {
    [self ft_weakAssociatedObject].stored_parameters = trans_params;
}

- (NSDictionary *)trans_params {
    return [self ft_weakAssociatedObject].stored_parameters;
}

- (void)setTrans_callback:(FTRouterCallBack)trans_callback {
    [self ft_weakAssociatedObject].stored_callback = trans_callback;
}

- (FTRouterCallBack)trans_callback {
    return [self ft_weakAssociatedObject].stored_callback;
}

@end


@implementation NSObject (FTRouterMerger)

- (instancetype)mergeParamsFromComponents:(FTRouterComponents *)components {
    return [self mergeParamsFromComponents:components transitionFrom:nil];
}

- (instancetype)mergeParamsFromComponents:(FTRouterComponents *)components transitionFrom:(id)transitionFrom {
    self.trans_from = transitionFrom;
    self.trans_callback = [components.callback copy];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    if (components.queryParams) {
        [parameters addEntriesFromDictionary:components.queryParams];
    }
    
    if (components.additionalParams) {
        [parameters addEntriesFromDictionary:components.additionalParams];
    }
    
    self.trans_params = parameters.allKeys.count > 0 ? parameters : nil;

    return [self mergeParamsFromDictionary:parameters];
}

- (instancetype)mergeParamsFromDictionary:(NSDictionary *)paramsDictionary {
    if (paramsDictionary) {
        for (NSString *key in paramsDictionary) {
            objc_property_t property_t = class_getProperty([self class], key.UTF8String);
            if (property_t != NULL) {
                [self setValue:paramsDictionary[key] forKey:key];
            }
        }
    }
    
    return self;
}

@end
