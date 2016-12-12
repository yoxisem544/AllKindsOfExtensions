//
//  NSObjectExtension.swift
//  AllKindsExtensions
//
//  Created by David on 2016/12/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
    
}
