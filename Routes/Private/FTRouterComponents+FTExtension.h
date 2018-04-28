//
//  FTRouterComponents+FTExtension.h
//  Router
//
//  Created by 胡金友 on 2018/4/26.
//

#import "Router.h"

/**
 
 FTRouterComponents的extension，用于添加一些私有的属性(公开的时候是只读状态)。
 
 */

@interface FTRouterComponents ()

@property (nonatomic, readwrite, copy) NSString *destination;
@property (nonatomic, readwrite, copy) FTRouterCallBack callback;

@end
