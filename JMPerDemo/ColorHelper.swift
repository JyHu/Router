//
//  ColorHelper.swift
//  JMPerDemo
//
//  Created by 胡金友 on 2018/5/8.
//

import UIKit

extension UIColor {
    class var random: UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0,
                       green: CGFloat(arc4random_uniform(256)) / 255.0,
                       blue: CGFloat(arc4random_uniform(256)) / 255.0,
                       alpha: 1)
    }
}
