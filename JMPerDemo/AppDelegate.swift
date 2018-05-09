//
//  AppDelegate.swift
//  JMPerDemo
//
//  Created by 胡金友 on 2018/5/7.
//

import UIKit
import JMPer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UIViewController()
        self.window?.rootViewController?.view.backgroundColor = UIColor.white
        
        self.registerRouters()
        let _ = Router.router(path: "root/guide")
        
        return true
    }
    
    // warning - options
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Router.router(URL: url, parameters: nil)
    }
    
    func registerRouters() {
        Router.shared.debugLogEnable = true
        
        Router.shared.defaultScheme = "jmp"
        
        let _ = RouterPath.register(path: "ft://contract/apperance", destination: "ApperanceSettingViewController")
        let _ = RouterPath.register(path: "order/res", destination: "ResViewController")
        let _ = RouterPath.register(path: "contract/risk", destination: "RiskSettingViewController")
        let _ = RouterPath.register(path: "guide", destination: "GuidViewController")
        let _ = RouterPath.register(path: "account/login", destination: "LoginViewController")
        let _ = RouterPath.registerPlist(Bundle.main.path(forResource: "rt", ofType: "plist")!)
        
        Router.shared.keyWindow = self.window
        
        func willTransition(components: URLComponents, topVC: UIViewController) -> UIViewController? {
            return nil
        }
        
        Router.register { (components, topVC) -> UIViewController? in
            if components.transitionType == .Present || components.transitionType == .Root {
                guard let destination = components.destination else {
                    return nil
                }
                
                guard let cls = NSClassFromString(destination) as? UIViewController.Type else {
                    return nil
                }
                
                return UINavigationController(rootViewController: cls.init().merge(components: components, from: topVC))
            }
            
            return nil
        }
    }
}

