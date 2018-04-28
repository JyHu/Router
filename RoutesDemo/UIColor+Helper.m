//
//  UIColor+Helper.m
//  RoutesDemo
//
//  Created by 胡金友 on 2018/4/27.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random_uniform(256) / 255.0
                           green:arc4random_uniform(256) / 255.0
                            blue:arc4random_uniform(256) / 255.0
                           alpha:1];
}

@end
