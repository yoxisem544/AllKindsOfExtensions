//
//  UIImageViewExtension.swift
//  CalendarApp
//
//  Created by David on 2016/8/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
	
	public func setImage(with string: String?) {
		if let url = string?.url {
            sd_setImage(with: url)
		}
	}
	
	public func setImage(with string: String?, placeholderImage: UIImage?) {
		if let url = string?.url {
            sd_setImage(with: url, placeholderImage: placeholderImage)
		}
	}
	
}
