//
//  ReUsableView.swift
//  GithubUserList
//

import Foundation
import UIKit

public protocol ReusableView: AnyObject {
    static var reuseIdentity: String { get }
}

extension ReusableView where Self: UIView {
    public static var reuseIdentity: String {
        return String(describing: self)
    }
}
