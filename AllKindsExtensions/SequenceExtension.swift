//
//  CollectionExtension.swift
//  CalendarApp
//
//  Created by David on 2016/12/6.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Safe indexing of a collection type
    /// Will return a optional type of _Element of a collection.
    subscript(safe index: Index) -> _Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
    
}
