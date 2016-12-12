# 各式各樣的extension

## Chaining Style and Arrangement
因為在以前的時候我們常常需要一個一個設定style跟位置
```swift
let label = UILabel()
label.font = UIFont.systemFont(ofSize: 14)
label.textColor = .red
label.numberOfLines = 3
label.textAlignment = .center
label.center = view.center
view.addSubview(label)
```

如果用了以下的擴展，就會變得像：
```swift
let label = UILabel()
label
  .anchor(to: view)
  .changeFontSize(to: 14)
  .changeTextColor(to: .red)
  .changeNumberOfLines(to: 3)
  .changeTextAlignment(to: .center)
  .centerX(inside: view)
  .centerY(inside: view)
```

## UIApplication
### 取得最上層的 view controller

```swift
import UIKit

extension UIApplication {
    
    var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        
        return topViewController
    }
    
}
```

## UIAlertController
```swift
import UIKit

extension UIAlertController {
    
    convenience init(title: String?, message: String?) {
        self.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    }
    
    func addAction(title: String?, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(action)
        return self
    }
    
    func addActionWithTextFields(title: String, style: UIAlertActionStyle = .default, handler: ((UIAlertAction, [UITextField]) -> Void)? = nil) -> Self {
        let okAction = UIAlertAction(title: title, style: style) { [weak self] action in
            handler?(action, self?.textFields ?? [])
        }
        addAction(okAction)
        return self
    }
    
    func addTextField(handler: @escaping (UITextField) -> Void) -> Self {
        addTextField(configurationHandler: handler)
        return self
    }
    
    func presnet(completion: ((Void) -> Void)? = nil) {
        UIApplication.shared.topViewController?.asyncPresent(self, animated: true, completion: completion)
    }
    
}
```

## 取得 class name
```swift
extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
    
}
```

## Safe Indexing
```swift
extension Collection {
    
    /// Safe indexing of a collection type
    /// Will return a optional type of _Element of a collection.
    subscript(safe index: Index) -> _Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
    
}
```

用法：

```swift
let array = [1,2,3,4]
array[safe: 1] // optional(2)
array[safe: 10] // nil
```

## UITableView Register cell
```swift
extension UITableView {
    
    func register<T: UITableViewCell>(cellType: T.Type) {
        let className = cellType.className
        if Bundle.main.path(forResource: className, ofType: "nib") != nil {
            // register for nib
            let nib = UINib(nibName: className, bundle: nil)
            register(nib, forCellReuseIdentifier: className)
        } else {
            // register for class
            register(cellType, forCellReuseIdentifier: className)
        }
    }
    
    func register<T: UITableViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { register(cellType: $0) }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
    
}
```

## UICollectionView Register Cell
```swift
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
    
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        let className = cellType.className
        if Bundle.main.path(forResource: className, ofType: "nib") != nil {
            // register for nib
            let nib = UINib(nibName: className, bundle: nil)
            register(nib, forCellWithReuseIdentifier: className)
        } else {
            // register for class
            register(cellType, forCellWithReuseIdentifier: className)
        }
    }
    
    func register<T: UICollectionViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { register(cellType: $0) }
    }
    
    func register<T: UICollectionReusableView>(reusableViewType: T.Type, of kind: String = UICollectionElementKindSectionHeader) {
        let className = reusableViewType.className
        if Bundle.main.path(forResource: className, ofType: "nib") != nil {
            // register for nib
            let nib = UINib(nibName: className, bundle: nil)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
        } else {
            // register for class
            register(reusableViewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
        }
    }
    
    func register<T: UICollectionReusableView>(reusableViewTypes: [T.Type], of kind: String = UICollectionElementKindSectionHeader) {
        reusableViewTypes.forEach { register(reusableViewType: $0, of: kind) }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }
    
    func dequeueReusableView<T: UICollectionReusableView>(with type: T.Type, for indexPath: IndexPath, of kind: String = UICollectionElementKindSectionHeader) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.className, for: indexPath) as! T
    }
    
}
```

## 隨機拿陣列中的一個值
```swift
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
```

## UIViewController
```swift
public extension UIViewController {
    
	/// Async present a view controller. 
    /// Will be executed in main thread.
	///
	/// - Parameters:
	///   - viewControllerToPresent: a view controller to present.
	///   - animated: determine whetehr present it with animation.
	///   - completion: a completion call back, default is nil.
	public func asyncPresent(_ viewControllerToPresent: UIViewController?, animated: Bool, completion: (() -> Void)? = nil) {
		Queue.main {
			if let viewControllerToPresent = viewControllerToPresent {
				self.present(viewControllerToPresent, animated: animated, completion: completion)
			}
		}
	}
	
    /// Async dismiss a view controller.
    /// Will be executed in main thread.
	///
	/// - Parameters:
	///   - animated: determine whetehr dismiss it with animation.
	///   - completion: a completion call back, default is nil.
	public func asyncDismiss(_ animated: Bool, completion: (() -> Void)? = nil) {
		Queue.main {
			self.dismiss(animated: animated, completion: {
                // after dismiss, set transitioning delegate to nil to avoid crash.
				self.transitioningDelegate = nil
				completion?()
			})
		}
	}
	
	/// Hide keyboard showing on view controller
	public func hideKeyboard() {
		view.endEditing(true)
	}
    
    /// Dismiss modal stack and return to root view controller
    /// **Caution**: Will dismiss all view controllers that are presented in modal style.
    ///
    /// - Parameters:
    ///   - animated: dismiss with animation.
    ///   - completion: completion call back, default is nil.
    public func dismissModalStackAndReturnToRoot(animated: Bool, completion: (() -> Void)? = nil) {
        var vc = self.presentingViewController
        // find the view controller that is presenting current view controller.
        while vc?.presentingViewController != nil {
            // try to find the previous view controller.
            vc = vc?.presentingViewController!
        }
        vc?.asyncDismiss(animated, completion: completion)
        if vc == nil {
            completion?()
        }
    }
    
    /// Dismiss modal stack.
    /// **Caution**: Will dismiss all view controllers that are presented in modal style.
    ///
    /// - Parameters:
    ///   - animated: dismiss with animation.
    ///   - completion: completion call back, default is nil.
    public func dismissModalStack(animated: Bool, completion: (() -> Void)? = nil) {
        var vc = self.presentedViewController
        // find the view controller that current view controller had presented.
        while vc?.presentedViewController != nil {
            vc = vc?.presentedViewController!
        }
        vc?.dismissModalStackAndReturnToRoot(animated: animated, completion: completion)
        if vc == nil {
            completion?()
        }
    }
    
}
```
## UIView 
```swift
import UIKit

extension UIView {
	
	/// Can anchor self to a view
	///
	/// A reverse thought of adding a subview
	@discardableResult func anchor(to view: UIView?) -> Self {
		view?.addSubview(self)
        return self
	}
    
    /// Anchor view to a view and below a subview on the view.
    ///
    /// - Parameters:
    ///   - view: a view to anchor on to
    ///   - below: a subview on the view
    @discardableResult func anchor(to view: UIView?, below: UIView) -> Self {
        view?.insertSubview(self, belowSubview: below)
        return self
    }
    
    /// Anchor view to a view and above a subview on the view.
    ///
    /// - Parameters:
    ///   - view: a view to anchor on to
    ///   - above: a subview on the view
    @discardableResult func anchor(to view: UIView?, above: UIView) -> Self {
        view?.insertSubview(self, aboveSubview: above)
        return self
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
	
}

extension UIView {

	/// Move below given point and view
	@discardableResult func move(_ point: CGFloat, pointBelow view: UIView) -> Self {
		self.frame.origin.y = point.point(below: view)
        return self
	}
	
	/// Move below given point and view
	@discardableResult func move(_ point: CGFloat, pointTopOf view: UIView) -> Self {
		self.frame.origin.y = view.frame.origin.y - self.bounds.height - point
        return self
	}
	
	/// Center x inside given view
	@discardableResult func centerX(inside view: UIView) -> Self {
		self.center.x = view.bounds.midX
        return self
	}
	
	/// Center y inside given view
	@discardableResult func centerY(inside view: UIView) -> Self {
		self.center.y = view.bounds.midY
        return self
	}
	
	@discardableResult func centerX(to view: UIView) -> Self {
		self.center.x = view.center.x
        return self
	}
	
	@discardableResult func centerY(to view: UIView) -> Self {
		self.center.y = view.center.y
        return self
	}
	
	/// Move view in view to its right
	/// This is used when you want to arrange a view to the right side inside the view.
	@discardableResult func move(_ point: CGFloat, pointsTrailingToAndInside view: UIView) -> Self {
		self.frame.origin.x = view.bounds.width - self.bounds.width - point
        return self
	}
	
	@discardableResult func move(_ point: CGFloat, pointsBottomToAndInside view: UIView) -> Self {
		self.frame.origin.y = view.bounds.height - self.bounds.height - point
        return self
	}
    
    @discardableResult func move(_ point: CGFloat, pointsTopToAndInside view: UIView) -> Self {
        self.frame.origin.y = point
        return self
    }
	
	/// Move view in view's right
	/// This is used to move to a view's right, not inside the view.
	@discardableResult func move(_ point: CGFloat, pointsRightFrom view: UIView) -> Self {
		self.frame.origin.x = view.frame.maxX + point
        return self
	}
	
	@discardableResult func move(_ point: CGFloat, pointsLeftFrom view: UIView) -> Self {
		self.frame.origin.x = view.frame.origin.x - self.bounds.width - point
        return self
	}
    
}

extension UIView {
	
	/// Get super view's view controller
	var superViewController: UIViewController? {
		return self.superview?.next as? UIViewController
	}
    
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    func screenShot(width: CGFloat) -> UIImage? {
        let imageBounds = CGRect(origin: CGPoint.zero,
                                 size: CGSize(width: width, height: bounds.size.height * (width / bounds.size.width)))
        
        UIGraphicsBeginImageContextWithOptions(imageBounds.size, true, 0)
        drawHierarchy(in: imageBounds, afterScreenUpdates: true)
        
        var image: UIImage?
        guard let contextImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        guard let cgImage = contextImage.cgImage else { return nil }
        
        image = UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: contextImage.imageOrientation)
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func screenShot() -> UIImage? {
        return screenShot(width: bounds.width)
    }
    
}
```

## UILabel
```swift
extension UILabel {
    
    func changeFont(to font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    func changeFontSize(to size: CGFloat) -> Self {
        guard let font = self.font else { return self }
        self.font = UIFont.init(name: font.fontName, size: size)
        return self
    }
    
    func changeTextColor(to color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    func changeTextAlignment(to alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    func changeNumberOfLines(to lines: Int) -> Self {
        self.numberOfLines = lines
        return self
    }
    
}
```

## UIImage
```swift
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
```

## UIColor
```swift
// Important: CoreImage is requried to import in this situation.
import CoreImage
import UIKit

extension UIColor {
    
	func withAlpha(_ alpha: CGFloat) -> UIColor {
		guard let CIColor = self.coreImageColor else { return self }
		
		let r = CIColor.red
		let g = CIColor.green
		let b = CIColor.blue
		
		return UIColor(red: r, green: g, blue: b, alpha: alpha)
	}
	
	var coreImageColor: CoreImage.CIColor? {
		return CoreImage.CIColor(color: self)
	}
	
	/// Init with hex string
    /// e.g. #ffffff or 03f7c4
	///
	/// - Parameter hexString: a string represent a color
	convenience init(hexString: String) {
		let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		let scanner = Scanner(string: hexString)
		
		if (hexString.hasPrefix("#")) {
			scanner.scanLocation = 1
		}
		
		var color:UInt32 = 0
		scanner.scanHexInt32(&color)
		
		let mask = 0x000000FF
		let r = Int(color >> 16) & mask
		let g = Int(color >> 8) & mask
		let b = Int(color) & mask
		
		let red   = CGFloat(r) / 255.0
		let green = CGFloat(g) / 255.0
		let blue  = CGFloat(b) / 255.0
		
		self.init(red:red, green:green, blue:blue, alpha:1)
	}
	
	/// Get a hex string of the color
	///
	/// - Returns: a hex string of the color
	func hexString() -> String {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0
		
		getRed(&r, green: &g, blue: &b, alpha: &a)
		
		let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
		
		return String(format: "#%06x", rgb)
	}
    
}
```

## SwiftyJSON
```swift
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
```

## Numbers
```swift
import UIKit

extension CGFloat {
    
	/// Double of a CGFloat
	var double: Double {
		return Double(self)
	}

    /// Int of a CGFloat
	var int: Int {
		return Int(self)
	}
    
    func point(below view: UIView) -> CGFloat {
        return view.frame.maxY + self
    }
    
}

extension Double {
    
	/// CGFloat of Double
	var cgFloat: CGFloat {
		return CGFloat(self)
	}
	
	/// Radian of Double.
	var radian: Double {
		return (M_PI * self / 180.0)
	}
    
}

extension Int {
    
	var double: Double {
		return Double(self)
	}
	
	var string: String {
		return String(self)
	}
	
	var cgFloat: CGFloat {
		return CGFloat(self)
	}
	
	func times(_ block: @escaping (_ index: Int) -> Void) {
		guard self >= 0 else { return }
		for index in 0..<self {
			autoreleasepool {
				block(index)
			}
		}
	}
	
	var int32: Int32 {
		return Int32(self)
	}
    
    /// Get a Random number.
    /// Don't call arc4random. 
    /// Will have 50% crash chance on 32bit device.
    ///
    /// - Returns: random Int
    static func random() -> Int {
        return Int(arc4random() / 2)
    }
    
    /// Get the y point below a view
    func point(below view: UIView) -> CGFloat {
        return view.frame.maxY + self.cgFloat
    }
    
    /// Get a x point right from a view
    func pointRight(from view: UIView) -> CGFloat {
        return view.frame.maxX + self.cgFloat
    }
    
}

extension Int32 {
    
	var int: Int {
		return Int(self)
	}
    
}
```

## String
```swift
import UIKit

extension String {
	
	/// To check if this is a valid url string
	var isValidURLString: Bool {
		return (URL(string: self) != nil)
	}
	
	/// To get a Int value from this string
	var int: Int? {
		return Int(self)
	}
	
	/// Encode the string, will return a utf8 encoded string.
	/// 
	/// If fail to generate a encoded string, will return a uuid string
	var uuidEncode: String {
		if let data = self.data(using: String.Encoding.utf8, allowLossyConversion: true) {
			return ("\(data)").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "")
		} else {
			return UUID().uuidString
		}
	}
    
    /// If the url does have unicode charaters, you will have to encode it first.
    var encodedURL: String? {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
	
	/// Check if this string is an valid email string
	var isValidEmail: Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: self)
	}
	
	/// Check if this string is an valid TW mobile number
	var isTaiwanMobileNumber: Bool {
		let mobileRegex = "^\\+?886\\d{9}"
		let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
		return mobileTest.evaluate(with: self)
	}
	
	func toTaiwanMobileNumber() -> String? {
		if self.isTaiwanMobileNumber {
			if self.characters.first == "+" {
				return "0" + self.substring(from: self.characters.index(self.startIndex, offsetBy: 4))
			} else {
				return "0" + self.substring(from: self.characters.index(self.startIndex, offsetBy: 3))
			}
		} else {
			return nil
		}
	}
	
	/// Check if this string is an valid mobile number string
	var isValidMobileNumber: Bool {
		let mobileRegex = "09\\d{8}"
		let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
		return mobileTest.evaluate(with: self)
	}
	
	/// Return a NSURL if the string is a valid url string
	var url: URL? {
		return URL(string: self)
	}
	
	/// Get charater at index
	func charaterAtIndex(_ index: Int) -> String? {
		guard index < self.characters.count else { return nil }
		let startIndex = self.characters.index(self.startIndex, offsetBy: index)
		let range = startIndex...startIndex
		return self[range]
	}

	/// get preferred text width by given font size
	func preferredTextWidth(constraintByFontSize size: CGFloat) -> CGFloat {
		let attrString = NSAttributedString(string: self, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: size)])
		let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: size)
		let boundingBox = attrString.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
		return ceil(boundingBox.width)
	}
	
	/// Get preferred text height by given width
	func preferredTextHeight(withConstrainedWidth width: CGFloat, andFontSize size: CGFloat) -> CGFloat {
		let attrString = NSAttributedString(string: self, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: size)])
		let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
		let boundingBox = attrString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
		return ceil(boundingBox.height)
	}
	
	/// Get preferred text width by given height
	func preferredTextWidth(withConstrainedHeight height: CGFloat, andFontSize size: CGFloat) -> CGFloat {
		let attrString = NSAttributedString(string: self, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: size)])
		let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
		let boundingBox = attrString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
		return ceil(boundingBox.width)
	}
    
    func bounds(for width: CGFloat, fontSize: CGFloat) -> CGRect {
        let defaultFont = UIFont.systemFont(ofSize: fontSize)
        return bounds(for: width, font: defaultFont)
    }
    
    func bounds(for width: CGFloat, font: UIFont) -> CGRect {
        let nsString = (self as NSString)
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin]
        let attributes: [String : Any] = [NSFontAttributeName: font]
        return nsString.boundingRect(with: size,
                                     options: options,
                                     attributes: attributes,
                                     context: nil)
    }
    
	/// Transform string into secret dot text
	var dottedString: String {
		let count = self.characters.count
		var dottedString = ""
		for _ in 1...count {
			dottedString += "●"
		}
		return dottedString
	}
	
}
```

## Date
```swift
extension Date {
	
	public static func ==(lhs: Date, rhs: Date) -> Bool {
		if lhs.day == rhs.day && lhs.month == rhs.month && lhs.year == rhs.year {
			// 年月日一樣即相等
			return true
		}
		return false
	}
	
}

extension Date {
	public static func calendarStartDate() -> Date {
		return Date.create(dateOnYear: 2010, month: 1, day: 1)!
	}
	
	public static func calendarEndDate() -> Date {
		return Date.create(dateOnYear: 2030, month: 12, day: 31)!
	}
	
	public func daysToDate(_ date: Date) -> Int {
		let seconds = self.timeIntervalSince(date)
		let secondsPerDay: TimeInterval = 86400
		// 60 * 60 * 24 seconds per day = 86400
		return Int(ceil(seconds / secondsPerDay))
	}
	
	public static func get50000DaysStartingFrom1970() -> [Date] {
		var dates = [Date]()
		guard let baseDate = Date.create(dateOnYear: 1970, month: 1, day: 1) else { return [] }
		for days in 0...49999 {
			if let date = baseDate.dateByAddingDay(days) {
				dates.append(date)
			}
		}
		return dates
	}

	public var rruleFormatString: String {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone(abbreviation: "UTC")
		formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
		return formatter.string(from: self)
	}
	
	public static func dateFromRRuleString(_ rruleString: String) -> Date? {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone(abbreviation: "UTC")
		formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
		return formatter.date(from: rruleString)
	}
	
	public func isBefore(_ date: Date) -> Bool {
		return compare(date) == .orderedAscending
	}
	
	public func isSame(with date: Date) -> Bool {
		return compare(date) == .orderedSame
	}
	
	public func isSameDay(with date: Date) -> Bool {
		return year == date.year && month == date.month && day == date.day
	}
	
	public func isAfter(_ date: Date) -> Bool {
		return compare(date) == .orderedDescending
	}
	
	public func isAfterOrSame(with date: Date) -> Bool {
		return isSame(with: date) || isAfter(date)
	}
	
	public func isBeforeOrSame(with date: Date) -> Bool {
		return isSame(with: date) || isBefore(date)
	}
	
	public func isBetween(date a: Date, and b: Date) -> Bool {
		let from = a.isBefore(b) ? a : b
		let to = b.isAfterOrSame(with: a) ? b : a
		return self.isAfterOrSame(with: from) && self.isBeforeOrSame(with: to)
	}

	public var iso8601String: String {
		let formatter = DateFormatter()
		let currentLocale = Locale.current
		formatter.locale = currentLocale
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
		return formatter.string(from: self)
	}
	
	public static func dateFrom(iso8601 iso8601String: String?) -> Date? {
		guard let iso8601String = iso8601String else { return nil }
		let formatter = DateFormatter()
		let currentLocale = Locale.current
		formatter.locale = currentLocale
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
		return formatter.date(from: iso8601String)
	}

	public func isEqual(_ object: Any?) -> Bool {
		if let date = object as? Date {
			if date.day == self.day && date.month == self.month && date.year == self.year {
				// 年月日一樣即相等
				return true
			}
		}
		return false
	}
	
	/// Creating a specific date.
	///
	/// year, month, day is required, and must larger than 0. If not, will fail to create.
	///
	/// Creating date like 1970 10 32 0 0 0, will create date like 1970 11 2 0 0 0
	///
	/// **You should not pass in 0 to year, month, day.**
	static func create(dateOnYear year: Int, month: Int, day: Int) -> Date? {
		return create(dateOnYear: year, month: month, day: day, hour: 0, minute: 0, second: 0)
	}
	
	/// Creating a specific date.
	///
	/// year, month, day is required, and must larger than 0. If not, will fail to create.
	///
	/// Creating date like 1970 10 32 0 0 0, will create date like 1970 11 2 0 0 0
	///
	/// **You should not pass in 0 to year, month, day.**
	static func create(dateOnYear year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date? {
		
		guard year > 0 else { return nil }
		guard month > 0 else { return nil }
		guard day > 0 else { return nil }
		
		var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day
		components.hour = hour
		components.minute = minute
		components.second = second
		return Calendar.current.date(from: components)
	}
	
	/// Create a max date of calendar.
	///
	/// Value is 2030/12/31 23:59:59
	static func createMaxDate() -> Date {
		return Date.create(dateOnYear: 2030, month: 12, day: 31, hour: 23, minute: 59, second: 59)!
	}
	
	var daysInItsMonth: Int {
		return (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self).length
	}
	
	var tomorrow: Date? {
		var component = (Calendar.current as NSCalendar).components([.year, .month, .day, .hour], from: self)
		guard component.day != nil else { return nil }
		component.day! += 1
		return Calendar.current.date(from: component)
	}
	
	var yesterday: Date? {
		var component = (Calendar.current as NSCalendar).components([.year, .month, .day, .hour], from: self)
		guard component.day != nil else { return nil }
		component.day! -= 1
		return Calendar.current.date(from: component)
	}
	
	var beginingDateOfItsMonth: Date? {
		var component = (Calendar.current as NSCalendar).components([.year, .month, .day, .hour], from: self)
		component.day = 1
		return Calendar.current.date(from: component)
	}
	
	var endDateOfItsMonth: Date? {
		var component = (Calendar.current as NSCalendar).components([.year, .month, .day, .hour], from: self)
		guard component.month != nil else { return nil }
		component.month! += 1
		component.day = 0
		return Calendar.current.date(from: component)
	}
	
	var year: Int {
		return (Calendar.current as NSCalendar).components(NSCalendar.Unit.year, from: self).year!
	}
	
	var month: Int {
		return (Calendar.current as NSCalendar).components(NSCalendar.Unit.month, from: self).month!
	}
	
	var day: Int {
		return (Calendar.current as NSCalendar).components(NSCalendar.Unit.day, from: self).day!
	}
	
	var hour: Int {
		return (Calendar.current as NSCalendar).components(NSCalendar.Unit.hour, from: self).hour!
	}
	
	var minute: Int {
		return (Calendar.current as NSCalendar).components(NSCalendar.Unit.minute, from: self).minute!
	}
	
	var second: Int {
		return (Calendar.current as NSCalendar).components(NSCalendar.Unit.second, from: self).second!
	}
	
	func dateByAddingYear(_ year: Int) -> Date? {
		var components = DateComponents()
		components.year = year
		return (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: [])
	}
	
	func dateBySubtractingYear(_ year: Int) -> Date? {
		return self.dateByAddingYear(-year)
	}
	
	func dateByAddingMonth(_ month: Int) -> Date? {
		var components = DateComponents()
		components.month = month
		return (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: [])
	}
	
	func dateBySubtractingMonth(_ month: Int) -> Date? {
		return self.dateByAddingMonth(-month)
	}
	
	func dateByAddingWeek(_ week: Int) -> Date? {
		var components = DateComponents()
		components.weekOfYear = week
		return (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: [])
	}
	
	func dateBySubtractingWeek(_ week: Int) -> Date? {
		return self.dateByAddingWeek(-week)
	}
	
	func dateByAddingDay(_ day: Int) -> Date? {
		var components = DateComponents()
		components.day = day
		return (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: [])
	}
	
	func dateBySubtractingDay(_ day: Int) -> Date? {
		return self.dateByAddingDay(-day)
	}
	
	func dateByAddingHour(_ hour: Int) -> Date? {
		var components = DateComponents()
		components.hour = hour
		return (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: [])
	}
	
	func dateBySubtractingHour(_ hour: Int) -> Date? {
		return self.dateByAddingHour(-hour)
	}
	
	func dateByAddingMinute(_ minute: Int) -> Date? {
		var components = DateComponents()
		components.minute = minute
		return (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: [])
	}
	
	func dateBySubtractingMinute(_ minute: Int) -> Date? {
		return self.dateByAddingMinute(-minute)
	}
}
```

## UIImageView
```swift
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
```

## Data
```swift
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
```