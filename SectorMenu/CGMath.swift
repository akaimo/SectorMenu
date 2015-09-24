//
//  CGMath.swift
//  SectorMenu
//
//  Created by akaimo on 2015/09/24.
//  Copyright © 2015年 akaimo. All rights reserved.
//

import UIKit

class CGMath: NSObject {
    static func circlePoint(center: CGPoint, radius: CGFloat, rad: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(rad)
        let y = center.y + radius * sin(rad)
        return CGPoint(x: x, y: y)
    }
}
