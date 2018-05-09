//
//  Router+URLComponents.swift
//  JMPer
//
//  Created by 胡金友 on 2018/5/8.
//

import UIKit

public extension URLComponents {
    public func routerPath(_ treatsHostAsPath: Bool) -> String? {
        if treatsHostAsPath, let host = self.host, host != "/", host != "localhost", host.range(of: ".") == nil {
            return "\(host)\(self.path)"
        }
        return self.path
    }
    
    public mutating func append(_ queryParameters: Dictionary<String, Any>?) -> URLComponents {
        if let parameters = queryParameters {
            var queryItems = [URLQueryItem]()
            for (name, value) in parameters {
                queryItems.append(URLQueryItem(name: name, value: (value is String ? value as! String : "\(value)")))
            }
            self.queryItems = queryItems
        }
        return self
    }
    
    public var queryParameters: Dictionary<String, String>? {
        var queryParams: Dictionary<String, String> = [:]
        if let items = self.queryItems {
            for item in items {
                if let value = item.value {
                    queryParams[item.name] = value
                }
            }
        }
        return queryParams.keys.count > 0 ? queryParams : nil
    }
}
