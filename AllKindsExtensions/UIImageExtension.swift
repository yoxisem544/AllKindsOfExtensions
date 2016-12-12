//
//  UIImageExtension.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
	
	var base64String: String? {
		return UIImagePNGRepresentation(self)?.base64EncodedString(options: .lineLength64Characters)
	}
	
	/// Generate a color filled image.
	///
	/// - Parameter color: color you want.
	/// - Returns: a image filled with requried color.
	class func with(color: UIColor) -> UIImage? {
		let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
		UIGraphicsBeginImageContext(rect.size)
		guard let content = UIGraphicsGetCurrentContext() else { return nil }
		content.setFillColor(color.cgColor)
		content.fill(rect)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
	}
	
}
