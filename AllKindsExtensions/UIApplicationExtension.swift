//
//  UIApplicationExtension.swift
//  AllKindsExtensions
//
//  Created by David on 2016/12/12.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        
        return topViewController
    }
    
}
