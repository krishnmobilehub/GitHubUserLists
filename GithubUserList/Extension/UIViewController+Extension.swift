//
//  UIViewController+Extension.swift
//  GithubUserList
//

import Foundation
import UIKit

enum ButtonTag: Int {
    case left = 0
    case right = 1
}

typealias AlertBlock = (_ tag: ButtonTag) -> Void

extension UIViewController {
    func showAlert(withMessage message: String, title: String = Constants.Alert.title, leftButton: String? = nil, rightButton: String, rightButtonColor: UIColor? = .black, completion: @escaping(AlertBlock)) {
        let alertController = UIAlertController(title: message == Constants.Alert.noInternetMessage ? Constants.Alert.noInternetTitle : title, message: message, preferredStyle: UIAlertController.Style.alert)
        if let left = leftButton {
            let leftAction = UIAlertAction(title: left, style: .default, handler: { _ in
                completion(.left)
            })
            alertController.addAction(leftAction)
        }
        
        let rightAction = UIAlertAction(title: rightButton, style: .default, handler: { _ in
            completion(.right)
        })
        alertController.addAction(rightAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}
