//
//  RouterTools.swift
//  JMPer
//
//  Created by 胡金友 on 2018/5/6.
//

import UIKit

func _IS_VALIDATE_STRING_(_ str: String?) -> Bool {
    if let str = str {
        if str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0 {
            return true
        }
    }
    
    return false
}

func _UNIFY_SCHEME_(_ scheme: String?) -> String? {
    if let scheme = scheme {
        if _IS_VALIDATE_STRING_(scheme) {
            return scheme.lowercased()
        }
    }
    return nil
}

func _UNIFY_PATH_(_ path: String?) -> String? {
    if let path = path {    
        if _IS_VALIDATE_STRING_(path) {
            if let first = path.first {
                if first == "/" {
                    return _UNIFY_PATH_(path.from(1)!)
                }
            }
            return path
        }
    }
    return nil
}

class RouterTools: NSObject {
    class func debugLog(_ info: String) {
        if Router.shared.debugLogEnable {
            print(info)
        }
    }
}
