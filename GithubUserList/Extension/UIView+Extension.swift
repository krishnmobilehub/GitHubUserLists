//
//  UIView+Extension.swift
//  GithubUserList
//

import Foundation
import UIKit

extension UIView {
    func cornerViewWithShadow(isShadow: Bool = true, cornerRadius: CGFloat = 2.0, borderColor: UIColor = .appColor, shadowColor: UIColor = .black) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 2.0
        self.clipsToBounds = true
        
        if isShadow {
            self.layer.masksToBounds = false
            self.layer.shadowRadius = 2
            self.layer.shadowOpacity = 0.8
            self.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
}

extension UIApplication {

  class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

