//
//  Router.swift
//  JMPer
//
//  Created by 胡金友 on 2018/5/6.
//

import UIKit

public typealias RouterCallback = ((AnyObject, Any) -> AnyObject)

public class Router: NSObject {
    
    private var routerMaps: Dictionary<String, RouterMap> = [:]
    
    public var debugLogEnable: Bool = false
    public var alwaysTreatsHostAsPathComponent = true
    public var alwaysTreatsURLHostsAsRoot = false
    public var keyWindow: UIWindow?
    
    public var handler: ((RouterComponents) -> Bool)?
    public var shouldAutoTransition: ((RouterComponents) -> Bool)?
    var willTransition:((RouterComponents, UIViewController?) -> UIViewController?)?
    
    public var defaultScheme: String?
    
    private static let _shared = Router()
    private override init() { }

    public class var shared: Router {
        return _shared
    }
    
    public class func register(willTransitionInspector: @escaping (RouterComponents, UIViewController?) -> UIViewController?) {
        Router.shared.willTransition = willTransitionInspector
    }
}

public extension Router {
    public class func unregisterAllRouters() {
        Router.shared.routerMaps.removeAll()
    }

    public class func unregister(scheme: String) {
        if let scheme = _UNIFY_SCHEME_(scheme) {
            Router.shared.routerMaps.removeValue(forKey: scheme)
        }
    }
    
    public class func register(scheme: String) -> Bool {
        if let scheme = _UNIFY_SCHEME_(scheme) {
            return self._register(map: RouterMap(scheme: scheme))
        }
        return false
    }
    
    public class func register(schemes: [String]) {
        for scheme in schemes {
            let _ = self.register(scheme: scheme)
        }
    }
    
    public class func isRegisterd(_ scheme: String?) -> Bool {
        guard let scheme = _UNIFY_SCHEME_(scheme) else {
            return false
        }
        
        return Router.shared.routerMaps.keys.contains(scheme)
    }
    
    fileprivate class func _register(map: RouterMap?) -> Bool {
        if let map = map {
            if Router.shared.routerMaps[map.scheme] == nil {
                Router.shared.routerMaps[map.scheme] = map
            }
            return true
        }
        
        return false
    }
    
}

public extension Router {
    public class func destinationFor(path: String) -> String? {
        return destinationFor(components: URLComponents(string: path))
    }
    
    public class func destinationFor(path: String, scheme: String?) -> String? {
        guard var components = URLComponents(string: path) else {
            return nil
        }
        
        if let scheme = _UNIFY_SCHEME_(scheme) {
            components.scheme = scheme
        }
        
        return destinationFor(components: components)
    }
    
    private class func destinationFor(components: URLComponents?) -> String? {
        guard
            let components = components,
            let scheme = _UNIFY_SCHEME_(components.scheme ?? Router.shared.defaultScheme),
            let map = Router.shared.routerMaps[scheme],
            let path = _UNIFY_PATH_(components.routerPath(Router.shared.alwaysTreatsHostAsPathComponent))
                else {
            return nil
        }
        
        return map.maps[path]
    }
}

public extension Router {
    public class func router(path: String) -> Bool {
        return router(URL: URL(string: path))
    }
    
    public class func router(path: String, parameters: Dictionary<String, Any>?) -> Bool {
        return router(URL: URL(string: path), parameters: parameters)
    }
    
    public class func router(path: String, callback: RouterCallback?) -> Bool {
        return router(URL: URL(string: path), callback: callback)
    }
    
    public class func router(path: String, parameters: Dictionary<String, Any>?, callback: RouterCallback?) -> Bool {
        return router(URL: URL(string: path), parameters: parameters, callback: callback)
    }
    
    public class func router(URL: URL?) -> Bool {
        return router(URL: URL, parameters: nil)
    }
    
    public class func router(URL: URL?, parameters: Dictionary<String, Any>?) -> Bool {
        return router(URL: URL, parameters: parameters, callback: nil)
    }
    
    public class func router(URL: URL?, callback: RouterCallback?) -> Bool {
        return router(URL: URL, parameters: nil, callback: callback)
    }
    
    public class func router(URL: URL?, parameters: Dictionary<String, Any>?, callback: RouterCallback?) -> Bool {
        guard
            let URL = URL,
            let scheme = _UNIFY_SCHEME_(URL.scheme ?? Router.shared.defaultScheme)
                else {
            return false
        }
        
        guard Router.isRegisterd(scheme) else {
            return false
        }
        
        let components = RouterComponents(URL: URL, parameters: parameters, defaultScheme: Router.shared.defaultScheme)
        
        components.destination = destinationFor(path: components.path, scheme: components.scheme)
        components.callback = callback
        
        RouterTools.debugLog("router \n\(components)")
        
        if let handler = Router.shared.handler {
            return handler(components)
        }
        
        guard let keyWindow = Router.shared.keyWindow else {
            return false
        }
        
        let inspector = Router.shared.shouldAutoTransition
        if inspector == nil || inspector!(components) {
            if components.transitionType == .Root {
                return keyWindow.changeRootWith(components: components)
            } else {
                if let topViewController = keyWindow.topViewController() {
                    if components.transitionType == .Pageback {
                        return topViewController.backtrack(animated: true)
                    }
                    
                    return topViewController.transitionWith(components: components)
                }
            }
        }
        
        return false
    }
}

extension Router {
    class func mapWith(scheme: String?) -> RouterMap? {
        if let scheme = _UNIFY_SCHEME_(scheme) {
            return Router.shared.routerMaps[scheme]
        }
        return nil
    }
    
    class func mapWithAutoRegistered(scheme: String) -> RouterMap? {
        guard let scheme = _UNIFY_SCHEME_(scheme) else {
            return nil
        }
        
        if let routerMap = Router.shared.routerMaps[scheme] {
            return routerMap
        }
        
        let map = RouterMap(scheme: scheme)
        let _ = Router._register(map: map)
        return map
    }
}
