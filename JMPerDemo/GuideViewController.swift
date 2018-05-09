//
//  GuideViewController.swift
//  JMPerDemo
//
//  Created by 胡金友 on 2018/5/8.
//

import UIKit
import JMPer

class GuidViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.random
        button.setTitle("Go Login", for: .normal)
        button.addTarget(self, action: Selector(("gologin")), for: .touchUpInside)
        self.view.addSubview(button)
        
        button.snp.makeConstraints { maker in
            maker.left.bottom.right.equalTo(self.view)
            maker.height.equalTo(100)
        }
    }
    
    func gologin() {
        Router.router(path: "account/login")
    }
}
