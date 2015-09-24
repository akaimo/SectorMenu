//
//  CGPointEx.swift
//  SectorMenu
//
//  Created by akaimo on 2015/09/24.
//  Copyright © 2015年 akaimo. All rights reserved.
//

import UIKit

extension CGPoint {
    
    // 足し算
    func plus(point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + point.x, y: self.y + point.y)
    }
    
    // 引き算
    func minus(point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - point.x, y: self.y - point.y)
    }
    
    func minusX(dx: CGFloat) -> CGPoint {
        return CGPoint(x: self.x - dx, y: self.y)
    }
    
    func minusY(dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x, y: self.y - dy)
    }
    
    // 掛け算
    func mul(rhs: CGFloat) -> CGPoint {
        return CGPoint(x: self.x * rhs, y: self.y * rhs)
    }
    
    // 割り算
    func div(rhs: CGFloat) -> CGPoint {
        return CGPoint(x: self.x / rhs, y: self.y / rhs)
    }
    
    // 長さ
    func length() -> CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }
    
    // 正規化
    func normalized() -> CGPoint {
        return self.div(self.length())
    }
    
    // 内積
    func dot(point: CGPoint) -> CGFloat {
        return self.x * point.x + self.y * point.y
    }
    
    // 外積
    func cross(point: CGPoint) -> CGFloat {
        return self.x * point.y - self.y * point.x
    }
    
    func split(point: CGPoint, ratio: CGFloat) -> CGPoint {
        return self.mul(ratio).plus(point.mul(1.0 - ratio))
    }
    
    func mid(point: CGPoint) -> CGPoint {
        return split(point, ratio: 0.5)
    }
}
