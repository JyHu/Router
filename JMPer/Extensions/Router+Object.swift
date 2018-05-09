//
//  Router+Object.swift
//  JMPer
//
//  Created by 胡金友 on 2018/5/8.
//

import UIKit

fileprivate class _RouterWeakAssociatedObject: NSObject {
    weak var stored_transitionFrom: AnyObject?
    var stored_parameters: Dictionary<String, Any>?
    var stored_callback: RouterCallback?
}

private let weakAssociatedKey: String = "com.auu.weakassocaitedKey"

public extension NSObject {
    private var _weakAssociatedObject: _RouterWeakAssociatedObject {
        if let associatedObject = objc_getAssociatedObject(self, weakAssociatedKey) as? _RouterWeakAssociatedObject {
            return associatedObject
        }
        
        let associatedObj = _RouterWeakAssociatedObject()
        objc_setAssociatedObject(self, weakAssociatedKey, associatedObj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return associatedObj
    }
    
    public weak var trans_from: AnyObject? {
        get {
            return self._weakAssociatedObject.stored_transitionFrom
        }
        set {
            self._weakAssociatedObject.stored_transitionFrom = newValue
        }
    }
    
    public var trans_parameters: Dictionary<String, Any>? {
        get {
            return self._weakAssociatedObject.stored_parameters
        }
        set {
            self._weakAssociatedObject.stored_parameters = newValue
        }
    }
    
    public var trans_callback: RouterCallback? {
        get {
            return self._weakAssociatedObject.stored_callback
        }
        set {
            self._weakAssociatedObject.stored_callback = newValue
        }
    }
    
    public func merge(components: RouterComponents) -> Self {
        return merge(components: components, from: nil)
    }
    
    public func merge(components: RouterComponents, from: AnyObject?) -> Self {
        self.trans_from = from
        self.trans_callback = components.callback
        
        var parameters: Dictionary<String, Any> = [:]
        
        if let query = components.queryParameters {
            parameters.merge(query) { (current, new) -> Any in
                return new
            }
        }
        
        if let param = components.additionalParameters {
            parameters.merge(param) { (current, new) -> Any in
                return new
            }
        }
        
        self.trans_parameters = parameters.count > 0 ? parameters : nil
        
        return merge(parameters)
    }
    
    // 此处的merge方法暂无解决办法
    private func merge(_ dictionary: Dictionary<String, Any>?) -> Self {
        if let parameters = dictionary {
//            for (key, value) in parameters {
//                if let ivar = class_getInstanceVariable(object_getClass(self), key) {
//                    object_setIvar(self, ivar, value)
//                }
//            }
            let ivar_count_p = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
            if let ivar_list = class_copyIvarList(object_getClass(self), ivar_count_p) {
                let ivar_count = Int(ivar_count_p[0])
                for i in 0..<ivar_count {
                    let ivar_t = ivar_list[i]
                    if let ivar_name = ivar_getName(ivar_t) {
                        let name = String.init(cString: ivar_name)
                        if let value = parameters[name] {
                            object_setIvar(self, ivar_t, value)
                        }
                    }
                }
            }
        }
        return self
    }
}
