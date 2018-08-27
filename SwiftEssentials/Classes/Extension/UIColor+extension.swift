//
//  UIColor+extension.swift
//  SwiftEssentials
//
//  Created by Anil Santo on 27/08/18.
//  Copyright © 2018 Anil Santo. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    convenience init(hexString: String) {
        var hex = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if (hex.hasPrefix("#")) {
            hex.remove(at: hex.startIndex)
        }
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
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    convenience init(r: Float,g: Float,b: Float,a:Float) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a))
    }
    
    static func imageWithBackgroundColor(image: UIImage, bgColor: UIColor) -> UIColor {
        let size = CGSize(width: 70, height: 70)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        
        let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        context!.setFillColor(bgColor.cgColor)
        context!.addRect(rectangle)
        context!.drawPath(using: .fill)
        context!.draw(image.cgImage!, in: rectangle)
        
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: img!)
        
    }
}
