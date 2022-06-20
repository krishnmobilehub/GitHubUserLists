//
//  UIColor+Extension.swift
//  GithubUserList
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 57, 255, 20)
            debugPrint("INVALID Color, Hex value is incorrect!!")
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    convenience init(red255: CGFloat, green255: CGFloat, blue255: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: red255 / 255.0, green: green255 / 255.0, blue: blue255 / 255.0, alpha: alpha)
    }
    
    convenience init(name: String) {
        if UIColor(named: name) == nil {
            debugPrint("INVALID Color with name: \(name)")
        }
        
        self.init(named: name)!
    }
    
    public static var appColor: UIColor { return UIColor(name: "appColor") }
}

