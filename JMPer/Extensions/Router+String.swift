//
//  Router+String.swift
//  JMPer
//
//  Created by 胡金友 on 2018/5/8.
//

import UIKit

public extension String {
    public subscript(range:NSRange) -> String? {
        get {
            if range.location + range.length <= self.count {
                return String(self[self.index(self.startIndex, offsetBy: range.location) ..< self.index(self.startIndex, offsetBy: range.location + range.length)])
            }
            return nil
        }
    }
    
    public var first: String? {
        if self.count > 0 {
            return self[NSMakeRange(0, 1)]
        }
        
        return nil
    }
    
    public var last: String? {
        if self.count > 0 {
            return self[NSMakeRange(self.count - 1, 1)]
        }
        return nil
    }
    
    public func from(_ ind: Int) -> String? {
        if ind < self.count {
            return self[NSMakeRange(ind, self.count - ind)]
        }
        return nil
    }
    
    public func to(_ ind: Int) -> String? {
        if ind < self.count {
            return self[NSMakeRange(0, ind + 1)]
        }
        return nil
    }
}

public extension String {
    public func routerURL() -> URL? {
        return routerURL(nil)
    }
    
    public func routerURL(_ withParameters: Dictionary<String, Any>?) -> URL? {
        return URLComponents(string: self)?.url
    }
}
