//
//  ArrayExtestion.swift
//  CalendarApp
//
//  Created by David on 2016/11/8.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

extension Array {
    
    /// You can get a random element in this array
    ///
    /// - Returns: any element in this array, return nil if this array doesn't have anything in it.
    func random() -> Element? {
        guard count > 0 else { return nil }
        let index = Int.random() % self.count
        return self[index]
    }
    
}
