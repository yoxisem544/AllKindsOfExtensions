//
//  SwiftyJSONExtension.swift
//  ColorgyAPI
//
//  Created by David on 2016/4/8.
//  Copyright © 2016年 David. All rights reserved.
//

import SwiftyJSON

extension JSON {
	
	/// To check if this json is an array.
	var isArray: Bool {
		return self.type == SwiftyJSON.Type.array
	}
	
	/// To check if this json is an unknown type.
	var isUnknownType: Bool {
		if self.type == SwiftyJSON.Type.unknown {
			return true
		}
		return false
	}
    
}
