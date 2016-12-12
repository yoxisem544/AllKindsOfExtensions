//
//  UIViewExtension.swift
//  ColorgyCourse
//
//  Created by David on 2016/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

extension UIView {
	
	/// Can anchor self to a view
	///
	/// A reverse thought of adding a subview
	func anchor(to view: UIView?) {
		view?.addSubview(self)
	}
    
    /// Anchor view to a view and below a subview on the view.
    ///
    /// - Parameters:
    ///   - view: a view to anchor on to
    ///   - below: a subview on the view
    func anchor(to view: UIView?, below: UIView) {
        view?.insertSubview(self, belowSubview: below)
    }
    
    /// Anchor view to a view and above a subview on the view.
    ///
    /// - Parameters:
    ///   - view: a view to anchor on to
    ///   - above: a subview on the view
    func anchor(to view: UIView?, above: UIView) {
        view?.insertSubview(self, aboveSubview: above)
    }
	
	/// Hide view
	func hide() {
		self.isHidden = true
	}
	
	/// Show view
	func show() {
		self.isHidden = false
	}
	
	/// Show border 
	func showGreenBorder() {
		self.layer.borderWidth = 1.0
		self.layer.borderColor = UIColor.green.cgColor
	}
	
	/// Show border
	func showRedBorder() {
		self.layer.borderWidth = 1.0
		self.layer.borderColor = UIColor.red.cgColor
	}
	
	/// Show border
	func showBlueBorder() {
		self.layer.borderWidth = 1.0
		self.layer.borderColor = UIColor.blue.cgColor
	}
	
	/// To check if cgpoint is inside the view
	func containsPoint(_ point: CGPoint) -> Bool {
		return self.bounds.contains(point)
	}
	
	/// Make a view center horizontally to superview.
	///
	/// Only works if the view has a superview
	func centerHorizontallyInsideSuperview() {
		if let superview = self.superview {
			self.center.x = superview.bounds.midX
		}
	}
	
	/// Get bounds' center x.
	/// Its different from center.x, because center.x is according to frame
	var centerXOfBounds: CGFloat {
		return bounds.midX
	}
    
    /// Get bounds' center y.
    /// Its different from center.y, because center.y is according to frame
    var centerYOfBounds: CGFloat {
        return bounds.midY
    }
	
	/// Move below given point and view
	func move(_ point: CGFloat, pointBelow view: UIView) {
		self.frame.origin.y = point.point(below: view)
	}
	
	/// Move below given point and view
	func move(_ point: CGFloat, pointTopOf view: UIView) {
		self.frame.origin.y = view.frame.origin.y - self.bounds.height - point
	}
	
	/// Center x inside given view
	func centerX(inside view: UIView) {
		self.center.x = view.bounds.midX
	}
	
	/// Center y inside given view
	func centerY(inside view: UIView) {
		self.center.y = view.bounds.midY
	}
	
	func centerX(to view: UIView) {
		self.center.x = view.center.x
	}
	
	func centerY(to view: UIView) {
		self.center.y = view.center.y
	}
	
	/// Move view in view to its right
	/// This is used when you want to arrange a view to the right side inside the view.
	func move(_ point: CGFloat, pointsTrailingToAndInside view: UIView) {
		self.frame.origin.x = view.bounds.width - self.bounds.width - point
	}
	
	func move(_ point: CGFloat, pointsBottomToAndInside view: UIView) {
		self.frame.origin.y = view.bounds.height - self.bounds.height - point
	}
    
    func move(_ point: CGFloat, pointsTopToAndInside view: UIView) {
        self.frame.origin.y = point
    }
	
	/// Move view in view's right
	/// This is used to move to a view's right, not inside the view.
	func move(_ point: CGFloat, pointsRightFrom view: UIView) {
		self.frame.origin.x = view.frame.maxX + point
	}
	
	func move(_ point: CGFloat, pointsLeftFrom view: UIView) {
		self.frame.origin.x = view.frame.origin.x - self.bounds.width - point
	}
	
	/// Get super view's view controller
	var superViewController: UIViewController? {
		return self.superview?.next as? UIViewController
	}
    
}
