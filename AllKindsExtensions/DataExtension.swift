//
//  DataExtension.swift
//  CalendarApp
//
//  Created by David on 2016/8/9.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

extension Data {
	
	public static func archive(dictionary: [String : Any]) -> Data {
		return NSKeyedArchiver.archivedData(withRootObject: dictionary)
	}
	
	public func unarchiveDataToDictionary() -> [String : Any]? {
		return NSKeyedUnarchiver.unarchiveObject(with: self) as? [String : Any]
	}
	
	public func unarchiveToDictionary(with data: Data) -> [String : Any]? {
		return data.unarchiveDataToDictionary()
	}
	
}
