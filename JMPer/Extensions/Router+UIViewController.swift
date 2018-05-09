//
//  Router+UIViewController.swift
//  JMPer
//
//  Created by 胡金友 on 2018/5/8.
//

import UIKit

public extension UIViewController {
    public func transitionWith(components: RouterComponents) -> Bool {
        guard let destination = components.destination else {
            return false
        }
        
        var dest: UIViewController?
        
        if let willTransitionInspector = Router.shared.willTransition {
            dest = willTransitionInspector(components, self)
        }
        
        if dest == nil, let cls = NSClassFromString(destination) as? UIViewController.Type {
            dest = cls.init()
        }
        
        guard let destPage = dest else {
            return false
        }
        
        
        
        var transitionType = components.transitionType
        
        if transitionType == .Default && !((self is UINavigationController) || self.navigationController != nil) {
            transitionType = .Present
        }
        
        let _ = destPage.merge(components: components, from: self)
        
        if transitionType == .Present {
            self.present(destPage, animated: true, completion: nil)
        } else {
            if let nav = (self as? UINavigationController ?? self.navigationController) {
                nav.pushViewController(destPage, animated: true)
            } else if transitionType == .Default {
                self.present(destPage, animated: true, completion: nil)
            } else {
                return false
            }
        }
        
        return true
    }
    
    public func backtrack(animated: Bool) -> Bool{
        if let nav = ((self as? UINavigationController) ?? self.navigationController), nav.viewControllers.count > 1 {
            nav.popViewController(animated: animated)
            return true
        }
        
        if let _ = self.presentedViewController {
            self.dismiss(animated: animated, completion: nil)
            return true
        }
        
        return false
    }
}
