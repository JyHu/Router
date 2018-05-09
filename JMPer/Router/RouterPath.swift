//
//  RouterPath.swift
//  JMPer
//
//  Created by 胡金友 on 2018/5/8.
//

import UIKit

public class RouterPath: NSObject {
    public class func register(path: String, destination: String) -> Bool {
        return _register(components: URLComponents(string: path), destination: destination)
    }
    
    public class func register(path: String, scheme: String, destination: String) -> Bool {
        if var components = URLComponents(string: scheme) {
            components.scheme = scheme
            return _register(components: components, destination: destination)
        }
        return false
    }
    
    private class func _register(components: URLComponents?, destination: String?) -> Bool {
        guard
            let components = components,
            let destination = destination else {
                return false
        }
        
        guard let scheme = _UNIFY_SCHEME_(components.scheme ?? Router.shared.defaultScheme) else {
                return false
        }
        
        guard let map = Router.mapWithAutoRegistered(scheme: scheme) else {
            return false
        }
        
        guard let path = components.routerPath(Router.shared.alwaysTreatsHostAsPathComponent) else {
            return false
        }
        
        map.maps[path] = destination
        
        RouterTools.debugLog("Register --> [Router `\(scheme)` : <`\(path)` - `\(destination)`>]")
        
        return true
    }
    
    public class func unregister(URLString: String?) {
        if let URLString = URLString {
            _unregister(URLComponents(string: URLString))
        }
    }
    
    public class func unregister(path: String, scheme: String) {
        if var components = URLComponents(string: path) {
            components.scheme = scheme
            _unregister(components)
        }
    }
    
    fileprivate class func _unregister(_ components: URLComponents?) {
        guard
            let components = components,
            let scheme = _UNIFY_SCHEME_(components.scheme),
            let path = _UNIFY_PATH_(components.routerPath(Router.shared.alwaysTreatsHostAsPathComponent))
            else {
                return
        }
        
        guard let map = Router.mapWith(scheme: scheme) else {
            return
        }
        
        map.maps.removeValue(forKey: path)
    }
    
    public class func registerPlist(_ plistFile: String?) -> Bool {
        if let plist = plistFile {
            return registerDictionary(NSDictionary(contentsOfFile: plist) as? Dictionary<String, String>)
        }
        return false
    }
    
    public class func registerJSON(_ JSONFile: String?) -> Bool {
        if let json = JSONFile {
            return registerDictionary(try! JSONSerialization.jsonObject(with: Data(contentsOf: URL(string: json)!), options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String, String>)
        }
        return false
    }
    
    public class func registerDictionary(_ dict: Dictionary<String, String>?) -> Bool {
        guard let dict = dict else {
            return false
        }
        
        for (path, value) in dict {
            let _ = register(path: path, destination: value)
        }
        
        return true
    }
}
