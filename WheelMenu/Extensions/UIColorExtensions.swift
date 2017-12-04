//
//  UIColorExtensions.swift
//  WheelMenu
//
//  Created by Roger Serentill Gené on 1/12/17.
//  Copyright © 2017 Roger Serentil. All rights reserved.
//

import UIKit

/* Source: https://medium.com/ios-os-x-development/ios-extend-uicolor-with-custom-colors-93366ae148e6 */

extension UIColor {
    
    // MARK: - Initializers
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(hex:Int, alpha: CGFloat = 1) {
        
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff, alpha: alpha)
    }
    
    
    // MARK: - Custom colors
    
    static let lightBlue = UIColor(hex: 0x77d1ff)
    
    static let middleBlue = UIColor(hex: 0x3393c4)
    
    static let darkBlue = UIColor(hex: 0x213946)
}
