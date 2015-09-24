//
//  UIColorEx.swift
//  SectorMenu
//
//  Created by akaimo on 2015/09/24.
//  Copyright © 2015年 akaimo. All rights reserved.
//

import UIKit

extension UIColor {
    var red: CGFloat {
        get {
            let components = CGColorGetComponents(self.CGColor)
            return components[0]
        }
    }
    
    var green: CGFloat {
        get {
            let components = CGColorGetComponents(self.CGColor)
            return components[1]
        }
    }
    
    var blue: CGFloat {
        get {
            let components = CGColorGetComponents(self.CGColor)
            return components[2]
        }
    }
    
    var alpha: CGFloat {
        get {
            return CGColorGetAlpha(self.CGColor)
        }
    }
    
    func alpha(alpha: CGFloat) -> UIColor {
        return UIColor(red: self.red, green: self.green, blue: self.blue, alpha: alpha)
    }
    
    func white(scale: CGFloat) -> UIColor {
        return UIColor(
            red: self.red + (1.0 - self.red) * scale,
            green: self.green + (1.0 - self.green) * scale,
            blue: self.blue + (1.0 - self.blue) * scale,
            alpha: 1.0
        )
    }
}
