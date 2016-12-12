//
//  UILabelExtension.swift
//  ColorgyCourse
//
//  Created by David on 2016/6/30.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func changeFontSize(_ size: CGFloat) -> Self {
        guard let font = self.font else { return self }
        self.font = UIFont.init(name: font.fontName, size: size)
        return self
    }
    
    func changeTextColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }
    
    func changeTextAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    func changeNumberOfLines(_ lines: Int) -> Self {
        self.numberOfLines = lines
        return self
    }
    
}
