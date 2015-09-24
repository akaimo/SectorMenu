//
//  SectorMenu.swift
//  SectorMenu
//
//  Created by akaimo on 2015/09/23.
//  Copyright © 2015年 akaimo. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

@IBDesignable
public class SectorMenu: UIView {

    private let internalRadiusRatio: CGFloat = 20.0 / 56.0
    public var cellRadiusRatio: CGFloat      = 0.38
//    public var animateStyle: LiquidFloatingActionButtonAnimateStyle = .Up {
//        didSet {
//            baseView.animateStyle = animateStyle
//        }
//    }
    public var enableShadow = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
//    public var delegate:   LiquidFloatingActionButtonDelegate?
//    public var dataSource: LiquidFloatingActionButtonDataSource?
    
    public var responsible = true
    public var isClosed: Bool {
        get {
            return plusRotation == 0
        }
    }
    
    @IBInspectable public var color: UIColor = UIColor(red: 82 / 255.0, green: 112 / 255.0, blue: 235 / 255.0, alpha: 1.0) {
        didSet {
//            baseView.color = color
        }
    }
    
    private let plusLayer   = CAShapeLayer()
    private let circleLayer = CAShapeLayer()
    
    private var touching = false
    private var plusRotation: CGFloat = 0
    
//    private var baseView = CircleLiquidBaseView()
    private let sectorMenuView = UIView()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    // MARK: draw icon
    public override func drawRect(rect: CGRect) {
        drawCircle()
        drawShadow()
        drawPlus(plusRotation)
    }
    
    private func drawCircle() {
        self.circleLayer.frame = CGRect(origin: CGPointZero, size: self.frame.size)
        self.circleLayer.cornerRadius = self.frame.width * 0.5
        self.circleLayer.masksToBounds = true
        if touching && responsible {
            self.circleLayer.backgroundColor = self.color.white(0.5).CGColor
        } else {
            self.circleLayer.backgroundColor = self.color.CGColor
        }
    }
    
    private func drawPlus(rotation: CGFloat) {
        plusLayer.frame = CGRect(origin: CGPointZero, size: self.frame.size)
        plusLayer.lineCap = kCALineCapRound
        plusLayer.strokeColor = UIColor.whiteColor().CGColor // TODO: customizable
        plusLayer.lineWidth = 3.0
        
        plusLayer.path = pathPlus(rotation).CGPath
    }
    
    private func pathPlus(rotation: CGFloat) -> UIBezierPath {
        let radius = self.frame.width * internalRadiusRatio * 0.5
        let center = self.center.minus(self.frame.origin)
        let points = [
            CGMath.circlePoint(center, radius: radius, rad: rotation),
            CGMath.circlePoint(center, radius: radius, rad: CGFloat(M_PI_2) + rotation),
            CGMath.circlePoint(center, radius: radius, rad: CGFloat(M_PI_2) * 2 + rotation),
            CGMath.circlePoint(center, radius: radius, rad: CGFloat(M_PI_2) * 3 + rotation)
        ]
        let path = UIBezierPath()
        path.moveToPoint(points[0])
        path.addLineToPoint(points[2])
        path.moveToPoint(points[1])
        path.addLineToPoint(points[3])
        return path
    }
    
    private func drawShadow() {
        if enableShadow {
            circleLayer.appendShadow()
        }
    }
    
    
    // MARK: private methods
    private func setup() {
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = false
        
//        baseView.setup(self)
//        addSubview(baseView)
        
//        liquidView.frame = baseView.frame
        sectorMenuView.frame = self.frame
        sectorMenuView.userInteractionEnabled = false
        addSubview(sectorMenuView)
        
//        liquidView.layer.addSublayer(circleLayer)
//        circleLayer.addSublayer(plusLayer)
    }

}
