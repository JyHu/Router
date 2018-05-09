//
//  RouterMap.swift
//  JMPer
//
//  Created by 胡金友 on 2018/5/6.
//

import UIKit

public class RouterMap: NSObject {

    /**
     缓存的`scheme`，此处的`scheme`为小写字母的字符串
     */
    private var _scheme: String!
    public var scheme: String! {
        return self._scheme
    }
    
    /**
     类方法，用于创建一个`FTRouterMap`对象
     
     - param scheme 存储的时候会自动的转为小写字母的形式
     */
    public init(scheme: String) {
        self._scheme = scheme
    }
    
    /**
     缓存的路由地址信息， {路由地址 : 目标类名}
     */
    public var maps: Dictionary<String, String> = [:]
}
