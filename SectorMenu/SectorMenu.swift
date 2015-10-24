//
//  SectorMenu.swift
//  SectorMenu
//
//  Created by akaimo on 2015/09/23.
//  Copyright © 2015年 akaimo. All rights reserved.
//

import UIKit

// SectorMenu DataSource methods
@objc public protocol SectorMenuDataSource {
    func numberOfCells(sectorMenu: SectorMenu) -> Int
    func cellForIndex(index: Int) -> SectorMenuCell
}

@objc public protocol SectorMenuDelegate {
    // selected method
    optional func sectorMenu(sectorMenu: SectorMenu, didSelectItemAtIndex index: Int)
}


public class SectorMenu: UIView {
    
    private let internalRadiusRatio: CGFloat = 20.0 / 56.0
    public var cellRadiusRatio: CGFloat      = 0.38
    private var cellCenter: CGPoint?
    public var ringRadius: CGFloat = 100
    public var distance: CGFloat = 100.0
    
    private let actionBtn = SectorMenuCircle()
    private let plusLayer   = CAShapeLayer()
    private var plusRotation: CGFloat = 0
    private var circleView: UIView?
    
    public var delegate:   SectorMenuDelegate?
    public var dataSource: SectorMenuDataSource?
    
    public var isClosed = true
    private var isPan = false
    private var panPointReference: CGPoint?
    
    public var color: UIColor = UIColor(red: 82/255.0, green: 112/255.0, blue: 235/255.0, alpha: 1.0)
    
    // MARK: init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    public override func drawRect(rect: CGRect) {
        drawPlus(plusRotation)
    }
    
    
    // MARK: private
    private func setup() {
        self.backgroundColor = UIColor.clearColor()
        userInteractionEnabled = true
        
        cellCenter = CGPoint(x: self.center.x - self.frame.origin.x, y: self.center.y - self.frame.origin.y)
        
        actionBtn.radius = self.frame.size.width * 0.5
        actionBtn.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        actionBtn.color = color
        actionBtn.circleLayer.addSublayer(plusLayer)
        addSubview(actionBtn)
    }
    
    private func cellArray() -> [SectorMenuCell] {
        var result: [SectorMenuCell] = []
        if let source = dataSource {
            for i in 0..<source.numberOfCells(self) {
                result.append(source.cellForIndex(i))
            }
        }
        return result
    }
    
    
    
    //MARK: tapAction
    private func didTaped() {
        if isClosed {
            open()
        } else {
            close()
        }
        
    }
    
    public func didTappedCell(target: SectorMenuCell) {
        if let _ = dataSource {
            let cells = cellArray()
            for i in 0..<cells.count {
                let cell = cells[i]
                if target === cell {
                    delegate?.sectorMenu!(self, didSelectItemAtIndex: i)
                }
            }
        }
    }
    
    internal func panGesture(sender: UIPanGestureRecognizer){
        // TODO: no action in no area of cell
        let currentPoint = sender.translationInView(self)
        if let _ = panPointReference {
        } else if sender.state == .Began {
            panPointReference = currentPoint
        }
        
        if sender.state == .Ended {
            if let point = panPointReference {
                if currentPoint.y > point.y {   // down
                    counterclockwise()
                } else {                        // up
                    clockwise()
                }
            }
            panPointReference = nil
        }
    }
    
    
    // MARK: cell animation
    public func open() {
        self.plusLayer.addAnimation(plusKeyframe(true), forKey: "plusRot")
        self.plusRotation = CGFloat(M_PI * 0.25) // 45 degree
        
        let cells = cellArray()
        for cell in cells {
            insertCell(cell)
        }
        
        circleView = UIView(frame: CGRectMake(-1 * ringRadius, -1 * ringRadius, ringRadius * 2 + bounds.width , ringRadius * 2 + bounds.height))
        circleView!.backgroundColor = UIColor.clearColor()
        ringLayer(circleView!)
        insertSubview(circleView!, atIndex: 0)
        
        let pan = UIPanGestureRecognizer(target: self, action: "panGesture:")
        circleView?.addGestureRecognizer(pan)
        
        openingCell(cells)
        setNeedsDisplay()
    }
    
    public func close() {
        self.plusLayer.addAnimation(plusKeyframe(false), forKey: "plusRot")
        self.plusRotation = 0
        
        let cells = cellArray()
        closingCell(cells)
        setNeedsDisplay()
    }
    
    public func close(index: Int) {
        self.plusLayer.addAnimation(plusKeyframe(false), forKey: "plusRot")
        self.plusRotation = 0
        
        let cells = cellArray()
        closingCell(cells, index: index)
        setNeedsDisplay()
    }
    
    private func insertCell(cell: SectorMenuCell) {
        cell.color  = self.color
        cell.alpha = 1.0
        cell.radius = self.frame.width * cellRadiusRatio
        cell.center = cellCenter!
        cell.actionButton = self
        insertSubview(cell, belowSubview: actionBtn)
    }
    
    private func openingCell(cells: [SectorMenuCell]) {
        // TODO: start left side animation
        let radi = M_PI_2 * 1/4
        let firstTime = 0.15
        let animTime = 0.4
        
        for var i=0; i<cells.count; i++ {
            // TODO: refactoing
            let startPoint: CGPoint = cells[i].layer.position
            
            let first = CABasicAnimation(keyPath: "position")
            first.fromValue = [startPoint.x, startPoint.y]
            first.toValue = [startPoint.x - distance, startPoint.y]
            first.duration = firstTime
            first.removedOnCompletion = true
            first.fillMode = kCAFillModeForwards
            
            
            let anim = CAKeyframeAnimation(keyPath: "position")
            var endPoint: CGPoint = CGPointMake(startPoint.x - distance, startPoint.y)
            var value: [Array<CGFloat>] = [[startPoint.x - distance, startPoint.y]]
            for var j=1; j<=i; j++ {
                let count = Double(j) * 2.0
                value.append([
                    startPoint.x - distance * CGFloat(cos(radi * (count - 1.0))),
                    startPoint.y - distance * CGFloat(sin(radi * (count - 1.0)))
                    ])
                value.append([
                    startPoint.x - distance * CGFloat(cos(radi * count)),
                    startPoint.y - distance * CGFloat(sin(radi * count))
                    ])
                endPoint = CGPointMake(
                    startPoint.x - distance * CGFloat(cos(radi * count)),
                    startPoint.y - distance * CGFloat(sin(radi * count))
                )
            }
            anim.values = value
            anim.beginTime = firstTime
            anim.duration = animTime
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            anim.removedOnCompletion = true
            anim.fillMode = kCAFillModeForwards
            
            
            let group = CAAnimationGroup()
            group.animations = [first, anim]
            group.duration = firstTime + animTime
            group.removedOnCompletion = true
            group.fillMode = kCAFillModeForwards
            
            cells[i].layer.position = endPoint
            cells[i].layer.addAnimation(group, forKey: nil)
        }
        
        circleView?.alpha = 0.0
        UIView.animateWithDuration(firstTime + animTime,
            animations: {() -> Void  in
                self.circleView?.alpha = 1.0
        })
        
        
        for cell in cells {
            cell.userInteractionEnabled = true
        }
        
        isClosed = false
    }
    
    private func closingCell(cells: [SectorMenuCell]) {
        // TODO: cell close animation
        let duration = 0.3
        for var i=1; i<=cells.count; i++ {
            let cell = cells[i-1]
            cell.userInteractionEnabled = false
            UIView.animateWithDuration(duration,
                animations: {() -> Void  in
                    cell.center = self.cellCenter!
                    cell.alpha = 0.0
                }, completion: {(Bool) -> Void in
                    cell.removeFromSuperview()
            })
        }
        
        UIView.animateWithDuration(duration,
            animations: {() -> Void  in
                self.circleView?.alpha = 0.0
            }, completion: {(Bool) -> Void in
                self.circleView?.removeFromSuperview()
        })
        
        isClosed = true
    }
    
    private func closingCell(cells: [SectorMenuCell], index: Int) {
        let duration = 0.3
        for var i=1; i<=cells.count; i++ {
            let cell = cells[i-1]
            cell.userInteractionEnabled = false
            if i-1 == index {
                let circle = CABasicAnimation(keyPath: "path")
                circle.toValue = CGPathCreateWithEllipseInRect(CGRectInset(cell.bounds, -25, -25), nil)
                circle.duration = duration
                circle.removedOnCompletion = true
                circle.fillMode = kCAFillModeForwards
                
                let fade = CABasicAnimation(keyPath: "opacity")
                fade.toValue = 0.0
                fade.duration = duration
                fade.removedOnCompletion = true
                fade.fillMode = kCAFillModeForwards
                
                let group = CAAnimationGroup()
                group.animations = [circle, fade]
                group.duration = duration
                group.removedOnCompletion = false
                group.fillMode = kCAFillModeForwards
                group.delegate = self
                
                cell.circleLayer.addAnimation(group, forKey: "didTapedClose")
            } else {
                UIView.animateWithDuration(duration,
                    animations: {() -> Void  in
                        cell.center = self.cellCenter!
                        cell.alpha = 0.0
                    }, completion: {(Bool) -> Void in
                        cell.removeFromSuperview()
                })
            }
        }
        
        UIView.animateWithDuration(duration,
            animations: {() -> Void  in
                self.circleView?.alpha = 0.0
            }, completion: {(Bool) -> Void in
                self.circleView?.removeFromSuperview()
        })
        
        isClosed = true
    }
    
    private func clockwise() {
        // TODO: unify clockwise() and counterclockwise()
        guard let btnPoint = cellCenter else {
            return
        }
        
        let cells = cellArray()
        for var i=0; i<cells.count; i++ {
            let startPoint = cells[i].layer.position
            let anim = CAKeyframeAnimation(keyPath: "position")
            let atan: Double = Double(atan2(btnPoint.x - startPoint.x, btnPoint.y - startPoint.y))
            let endPoint: CGPoint = CGPointMake(btnPoint.x + distance * CGFloat(cos(atan)),
                                                btnPoint.y - distance * CGFloat(sin(atan)))
            let value: [Array<CGFloat>] = [
                [
                    startPoint.x,
                    startPoint.y
                ],
                [
                    btnPoint.x + distance * CGFloat(cos(atan + M_PI_4 * 5/3)),
                    btnPoint.y - distance * CGFloat(sin(atan + M_PI_4 * 5/3))
                ],
                [
                    btnPoint.x + distance * CGFloat(cos(atan + M_PI_4 * 4/3)),
                    btnPoint.y - distance * CGFloat(sin(atan + M_PI_4 * 4/3))
                ],
                [
                    btnPoint.x + distance * CGFloat(cos(atan + M_PI_4)),
                    btnPoint.y - distance * CGFloat(sin(atan + M_PI_4))
                ],
                [
                    btnPoint.x + distance * CGFloat(cos(atan + M_PI_4 * 2/3)),
                    btnPoint.y - distance * CGFloat(sin(atan + M_PI_4 * 2/3))
                ],
                [
                    btnPoint.x + distance * CGFloat(cos(atan + M_PI_4 * 1/3)),
                    btnPoint.y - distance * CGFloat(sin(atan + M_PI_4 * 1/3))
                ],
                [
                    btnPoint.x + distance * CGFloat(cos(atan)),
                    btnPoint.y - distance * CGFloat(sin(atan))
                ]
            ]
            anim.values = value
            anim.duration = 0.5
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            anim.removedOnCompletion = true
            
            cells[i].layer.position = endPoint
            cells[i].layer.addAnimation(anim, forKey: nil)
        }
    }
    
    private func counterclockwise() {
        guard let btnPoint = cellCenter else {
            return
        }
        
        let cells = cellArray()
        for var i=0; i<cells.count; i++ {
            let startPoint = cells[i].layer.position
            let anim = CAKeyframeAnimation(keyPath: "position")
            let atan: Double = Double(atan2(startPoint.x - btnPoint.x, startPoint.y - btnPoint.y))
            let endPoint: CGPoint = CGPointMake(btnPoint.x + distance * CGFloat(cos(atan)),
                                                btnPoint.y - distance * CGFloat(sin(atan)))
            let value: [Array<CGFloat>] = [
                [
                    startPoint.x,
                    startPoint.y
                ],
                [
                    btnPoint.x + distance * CGFloat(cos(atan - M_PI_4 * 5/3)),
                    btnPoint.y - distance * CGFloat(sin(atan - M_PI_4 * 5/3))
                ],
                [
                    btnPoint.x + distance * CGFloat(cos(atan - M_PI_4 * 4/3)),
                    btnPoint.y - distance * CGFloat(sin(atan - M_PI_4 * 4/3))
                ],
                [
                    btnPoint.x + distance * CGFloat(cos(atan - M_PI_4)),
                    btnPoint.y - distance * CGFloat(sin(atan - M_PI_4))
                ],
                [
                    btnPoint.x + distance * CGFloat(cos(atan - M_PI_4 * 2/3)),
                    btnPoint.y - distance * CGFloat(sin(atan - M_PI_4 * 2/3))
                ],
                [
                    btnPoint.x + distance * CGFloat(cos(atan - M_PI_4 * 1/3)),
                    btnPoint.y - distance * CGFloat(sin(atan - M_PI_4 * 1/3))
                ],
                [
                    btnPoint.x + distance * CGFloat(cos(atan)),
                    btnPoint.y - distance * CGFloat(sin(atan))
                ]
            ]
            anim.values = value
            anim.duration = 0.5
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            anim.removedOnCompletion = true
            
            cells[i].layer.position = endPoint
            cells[i].layer.addAnimation(anim, forKey: nil)
        }
    }
    
    
    
    // MARK: layer
    private func drawPlus(rotation: CGFloat) {
        plusLayer.frame = CGRect(origin: CGPointZero, size: self.frame.size)
        plusLayer.lineCap = kCALineCapRound
        plusLayer.strokeColor = UIColor.whiteColor().CGColor // TODO: customizable
        plusLayer.lineWidth = 3.0
        
        plusLayer.path = pathPlus(rotation).CGPath
    }
    
    private func pathPlus(rotation: CGFloat) -> UIBezierPath {
        let radius = self.frame.width * internalRadiusRatio * 0.5
        let center = CGPoint(x: self.center.x - self.frame.origin.x, y: self.center.y - self.frame.origin.y)
        let points = [
            circlePoint(center, radius: radius, rad: rotation),
            circlePoint(center, radius: radius, rad: CGFloat(M_PI_2) + rotation),
            circlePoint(center, radius: radius, rad: CGFloat(M_PI_2) * 2 + rotation),
            circlePoint(center, radius: radius, rad: CGFloat(M_PI_2) * 3 + rotation)
        ]
        let path = UIBezierPath()
        path.moveToPoint(points[0])
        path.addLineToPoint(points[2])
        path.moveToPoint(points[1])
        path.addLineToPoint(points[3])
        return path
    }
    
    private func circlePoint(center: CGPoint, radius: CGFloat, rad: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(rad)
        let y = center.y + radius * sin(rad)
        return CGPoint(x: x, y: y)
    }
    
    private func plusKeyframe(closed: Bool) -> CAKeyframeAnimation {
        let paths = closed ? [
            pathPlus(CGFloat(M_PI * 0)),
            pathPlus(CGFloat(M_PI * 0.125)),
            pathPlus(CGFloat(M_PI * 0.25)),
            ] : [
                pathPlus(CGFloat(M_PI * 0.25)),
                pathPlus(CGFloat(M_PI * 0.125)),
                pathPlus(CGFloat(M_PI * 0)),
        ]
        let anim = CAKeyframeAnimation(keyPath: "path")
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.values = paths.map { $0.CGPath }
        anim.duration = closed ? 0.5 : 0.2
        anim.removedOnCompletion = true
        anim.fillMode = kCAFillModeForwards
        return anim
    }
    
    private func ringLayer(circleView: UIView) {
        let lineWidth = frame.size.width
        let side = ringRadius * 2 + bounds.width - lineWidth
        let lineColor = UIColor(red: 67/225, green: 135/225, blue: 233/225, alpha: 0.5) // TODO: customizable
        let centerColor = UIColor.whiteColor()
        
        let ringLayer = CAShapeLayer()
        ringLayer.path = UIBezierPath(ovalInRect: CGRect(x: lineWidth / 2, y: lineWidth / 2, width: side, height: side)).CGPath
        ringLayer.lineWidth = lineWidth
        ringLayer.strokeColor = lineColor.CGColor
        ringLayer.fillColor = centerColor.CGColor
        ringLayer.name = "ring"
        
        circleView.layer.addSublayer(ringLayer)
    }
    
    
    
    // MARK: UIView
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !isPan {
            let scale: CGFloat = 0.5
            let old = CGColorGetComponents(color.CGColor)
            let newColor = UIColor(red: old[0] + (1.0 - old[0]) * scale, green: old[1] + (1.0 - old[1]) * scale, blue: old[2] + (1.0 - old[2]) * scale, alpha: 1.0)
            actionBtn.color = newColor
        }
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if !isPan {
            actionBtn.color = color
        }
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        actionBtn.color = color
        if !isPan {
            didTaped()
        }
    }
    
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        for cell in cellArray() {
            let pointForTargetView = cell.convertPoint(point, fromView: self)
            
            if (CGRectContainsPoint(cell.bounds, pointForTargetView)) {
                if cell.userInteractionEnabled {
                    return cell.hitTest(pointForTargetView, withEvent: event)
                }
            }
        }
        
        let circlViewPoint = circleView?.convertPoint(point, fromView: self)
        if let circle = circlViewPoint {
            if CGRectContainsPoint((circleView?.bounds)!, circlViewPoint!) {
                isPan = true
                if CGRectContainsPoint(actionBtn.bounds, point) {   // close button tap
                    isPan = false
                }
                return circleView?.hitTest(circle, withEvent: event)
            }
        }
        
        return super.hitTest(point, withEvent: event)
    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        let cells = cellArray()
        for cell in cells {
            if anim == cell.circleLayer.animationForKey("didTapedClose") {
                cell.circleLayer.removeAnimationForKey("didTapedClose")
                cell.removeFromSuperview()
            }
        }
    }

}
