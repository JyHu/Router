//
//  Router+URL.swift
//  JMPer
//
//  Created by 胡金友 on 2018/5/8.
//

import UIKit

extension URL {
    func routerPath(_ treatsHostAsPath: Bool) -> String? {
        if let component = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            return component.routerPath(treatsHostAsPath)
        }
        return self.path
    }
}

public extension URL {
    public func append(_ queryParams: Dictionary<String, Any>?) -> URL {
        guard let params = queryParams else {
            return self
        }
        
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        
        return components.append(params).url ?? self
    }
}
