# 各式各樣的extension
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