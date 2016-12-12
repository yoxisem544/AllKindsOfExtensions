//
//  UITableViewExtension.swift
//  AllKindsExtensions
//
//  Created by David on 2016/12/12.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(cellType: T.Type) {
        let className = cellType.className
        if Bundle.main.path(forResource: className, ofType: "nib") != nil {
            // register for nib
            let nib = UINib(nibName: className, bundle: nil)
            register(nib, forCellReuseIdentifier: className)
        } else {
            // register for class
            register(cellType, forCellReuseIdentifier: className)
        }
    }
    
}
