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
    
    func changeFont(to font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    func changeFontSize(to size: CGFloat) -> Self {
        guard let font = self.font else { return self }
        self.font = UIFont.init(name: font.fontName, size: size)
        return self
    }
    
    func changeTextColor(to color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    func changeTextAlignment(to alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    func changeNumberOfLines(to lines: Int) -> Self {
        self.numberOfLines = lines
        return self
    }
    
}
