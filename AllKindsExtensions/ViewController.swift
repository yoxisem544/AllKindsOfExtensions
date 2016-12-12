//
//  ViewController.swift
//  AllKindsExtensions
//
//  Created by David on 2016/12/12.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let aview = UIView()
        
        aview
            .move(10, pointBelow: view)
            .move(10, pointBelow: view)
            .centerX(to: view)
            .centerY(to: view)
        
        let label = UILabel()
        
        label
            .changeFontSize(14)
            .changeTextColor(.red)
            .changeNumberOfLines(3)
            .changeTextAlignment(.center)
            .centerX(inside: view)
            .centerY(inside: view)
        
        
    }

}

