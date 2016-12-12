//
//  UICollectionViewExtension.swift
//  CalendarApp
//
//  Created by David on 2016/12/6.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    /// Deselect all selected items of a collection view.
    /// You should need to reload data after this.
    /// Wont update ui for you.
    public func deselectSelectedItems() {
        guard let selectedIndexPaths = indexPathsForSelectedItems else { return }
        for indexPath in selectedIndexPaths {
            deselectItem(at: indexPath, animated: false)
        }
    }
    
}
