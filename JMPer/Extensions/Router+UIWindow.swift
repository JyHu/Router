//
//  Router+UIWindow.swift
//  JMPer
//
//  Created by 胡金友 on 2018/5/8.
//

import UIKit

public extension UIWindow {
    public func topViewController() -> UIViewController? {
        return topViewController(except: nil)
    }
    
    public func topViewController(except: ((UIViewController) -> Bool)?) -> UIViewController? {
        var curVC: UIViewController?
        var rootVC: UIViewController? = self.rootViewController
        
        while rootVC != nil {
            if rootVC is UINavigationController {
                curVC = (rootVC as! UINavigationController).viewControllers.last
                rootVC = curVC?.presentedViewController
            } else if rootVC is UITabBarController {
                let tabVC = (rootVC as! UITabBarController)
                curVC = rootVC
                rootVC = tabVC.viewControllers?[tabVC.selectedIndex]
            } else {
                curVC = rootVC
                rootVC = rootVC?.presentedViewController
            }
            
            if let except = except, let tmpRoot = rootVC {
                if except(tmpRoot) {
                    rootVC = nil
                }
            }
        }
        
        return curVC
    }
    
    public func topViewController(excepts: [String]?) -> UIViewController? {
        return topViewController(except: { viewController -> Bool in
            return (excepts ?? []).contains(NSStringFromClass(object_getClass(viewController)!))
        })
    }
    
    public func changeRootWith(components: RouterComponents) -> Bool {
        
        var destPage: AnyObject?
        
        if let willTransitionInspectors = Router.shared.willTransition {
            destPage = willTransitionInspectors(components, nil)
        }
        
        if destPage == nil {
            destPage = components.destinationViewController
        }
        
        if let destPage = destPage as? UIViewController {
            self.rootViewController = destPage
            self.makeKeyAndVisible()
            return true
        }
        
        return false
    }
}
