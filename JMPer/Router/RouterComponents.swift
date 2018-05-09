//
//  RouterComponents.swift
//  JMPer
//
//  Created by 胡金友 on 2018/5/6.
//

import UIKit

public enum RouterTransitionType {
    case Default
    case Push
    case Present
    
    case Pageback
    case Root
}

public class RouterComponents: NSObject {
    
    public var scheme: String?
    public var originalURL: URL!
    public var host: String?
    public var path: String!
    public var pathComponents: [String]!
    public var queryParameters: Dictionary<String, String>?
    public var additionalParameters: Dictionary<String, Any>?
    public var followedURL: URL?
    
    public var destination: String?
    public var transitionType: RouterTransitionType = .Default
    public var callback: RouterCallback?
    
    public init(URL: URL, parameters: Dictionary<String, Any>?) {
        super.init()
        compile(URL: URL, parameters: parameters, defaultScheme: nil)
    }
    
    public init(URL: URL, parameters: Dictionary<String, Any>?, defaultScheme: String?) {
        super.init()
        compile(URL: URL, parameters: parameters, defaultScheme: defaultScheme)
    }
    
    private func compile(URL: URL, parameters: Dictionary<String, Any>?, defaultScheme: String?) {
        originalURL = URL
        additionalParameters = parameters
        scheme = _UNIFY_SCHEME_(URL.scheme ?? defaultScheme)
        
        guard var components = URLComponents(string: URL.absoluteString) else {
            return
        }
        
        if components.host != nil && Router.shared.alwaysTreatsHostAsPathComponent && host?.range(of: ".") == nil {
            if let host = components.percentEncodedHost {
                components.host = "/"
                components.percentEncodedPath = "\(host)\(components.percentEncodedPath)"
            }
        }
        
        if Router.shared.alwaysTreatsURLHostsAsRoot, let host = components.host, host.contains(".") {
            components.host = "/"
        }
        
        var path = components.percentEncodedPath
        
        if path.count > 0 && path.first == "/" {
            path.removeFirst()
        }
        
        if path.count > 0 && path.last == "/" {
            path.removeLast()
        }
        
        var pathComponents = path.split(separator: "/")
        
        if pathComponents.count > 0, let first = pathComponents.first?.lowercased() {
            switch first {
                case "push":
                    self.transitionType = .Push
                    break
                case "present":
                    self.transitionType = .Present
                    break
                case "back":
                    self.transitionType = .Pageback
                    break
                case "root":
                    self.transitionType = .Root
                    break
                default:
                    self.transitionType = .Default
            }
            
            if self.transitionType != .Default {
                pathComponents.removeFirst()
            }
        }
        
        self.pathComponents = pathComponents.map({ cmp -> String in
            return String(cmp)
        })
        
        self.path = pathComponents.joined(separator: "/")
        
        
        if let fragment = components.percentEncodedFragment {
            var fragmentComponents = URLComponents(string: fragment)
            if fragmentComponents?.scheme == nil {
                fragmentComponents?.scheme = self.scheme
            }
            self.followedURL = fragmentComponents?.url
        }
        
        self.queryParameters = components.queryParameters
    }
    
    public var destinationViewController: UIViewController? {
        guard let destination = self.destination else {
            return nil
        }
        
        guard let cls = NSClassFromString(destination) as? UIViewController.Type else {
            return nil
        }
        
        return cls.init().merge(components: self)
    }
    
    public override var description: String {
        
        var desc: String = ""
        
        desc.append("\n")
        desc.append("**********************************************************\n")
        desc.append("   RouterComponents\n")
        desc.append("----------------------------------------\n")
        desc.append("URL : \(self.originalURL)\n")
        
        if let scheme = scheme {
            desc.append("scheme : \(scheme)\n")
        }
        
        if let host = host {
            desc.append("host : \(host)")
        }
        
        if let path = path {
            desc.append("path : \(path)\n")
        }
        
        if let pathComponents = pathComponents {
            desc.append("pathComponents : \(pathComponents)\n")
        }
        
        desc.append("transitionType : \(transitionTypeString())\n")
        
        if let queryParameters = queryParameters {
            if queryParameters.count > 0 {
                desc.append("queryParams : \(queryParameters)\n")
            }
        }
        
        if let additionalParams = additionalParameters {
            if additionalParams.count > 0 {
                desc.append("additionalParams : \(additionalParams)\n")
            }
        }
        
        if let destination = destination {
            desc.append("destination : \(destination)\n")
        }
        
        if let callback = callback {
            desc.append("callback : \(callback)\n")
        }
        
        if let followedURL = followedURL {
            desc.append("followedURL : \(followedURL)\n")
        }
        
        desc.append("**********************************************************\n")
        
        return desc
    }
    
    private func transitionTypeString() -> String {
        switch self.transitionType {
            case .Present:  return "Present"
            case .Push:     return "Push"
            case .Pageback: return "Pageback"
            case .Root:     return "Root"
            default:        return "Default"
        }
    }
}
