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
            .anchor(to: view)
            .changeFontSize(to: 14)
            .changeTextColor(to: .red)
            .changeNumberOfLines(to: 3)
            .changeTextAlignment(to: .center)
            .centerX(inside: view)
            .centerY(inside: view)
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .red
        label.numberOfLines = 3
        label.textAlignment = .center
        label.center = view.center
        view.addSubview(label)
        
        let labels = [UILabel(),UILabel(),UILabel(),UILabel(),UILabel()]
        labels.forEach {
            $0
            .anchor(to: view)
            .changeFontSize(to: 14)
            .changeTextColor(to: .red)
            .changeNumberOfLines(to: 3)
            .changeTextAlignment(to: .center)
            .centerX(inside: view)
            .centerY(inside: view)
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let a = UIAlertController(title: "hi", message: "hello")
            .addAction(title: "ok")
            .addAction(title: "cancel")
        a.presnet()
    }

}

