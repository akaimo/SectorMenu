//
//  SectorMenuCircle.swift
//  SectorMenu
//
//  Created by akaimo on 2015/09/28.
//  Copyright © 2015年 akaimo. All rights reserved.
//

import Foundation
import UIKit

public class SectorMenuCircle: UIView {

    var points: [CGPoint] = []
    var radius: CGFloat {
        didSet {
            self.frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
            setup()
        }
    }
    var color: UIColor = UIColor.redColor() {
        didSet {
            setup()
        }
    }
    
    override public var center: CGPoint {
        didSet {
            self.frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
            setup()
        }
    }
    
    let circleLayer = CAShapeLayer()
    
    
    // MARK: init
    init(center: CGPoint, radius: CGFloat, color: UIColor) {
        let frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        self.radius = radius
        self.color = color
        super.init(frame: frame)
        setup()
        self.layer.addSublayer(circleLayer)
        self.opaque = false
    }
    
    init() {
        self.radius = 0
        super.init(frame: CGRectZero)
        setup()
        self.layer.addSublayer(circleLayer)
        self.opaque = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: private
    private func setup() {
        self.frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        drawCircle()
    }
    
    func drawCircle() {
        let bezierPath = UIBezierPath(ovalInRect: CGRect(origin: CGPointZero, size: CGSize(width: radius * 2, height: radius * 2)))
        draw(bezierPath)
    }
    
    func draw(path: UIBezierPath) -> CAShapeLayer {
        circleLayer.lineWidth = 3.0
        circleLayer.fillColor = self.color.CGColor
        circleLayer.path = path.CGPath
        return circleLayer
    }
    
    public override func drawRect(rect: CGRect) {
        drawCircle()
    }

}
