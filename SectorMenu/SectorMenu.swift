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
    
    private let actionBtn = SectorMenuCircle()
    private let plusLayer   = CAShapeLayer()
    private var plusRotation: CGFloat = 0
    private var circleView: UIView?
    
    public var delegate:   SectorMenuDelegate?
    public var dataSource: SectorMenuDataSource?
    
    public var isClosed = true
    
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
        
        openingCell(cells)
        setNeedsDisplay()
    }
    
    public func close() {
        self.plusLayer.addAnimation(plusKeyframe(false), forKey: "plusRot")
        self.plusRotation = 0
        
        let cells = cellArray()
        closingCell(cells)
        circleView?.removeFromSuperview()
        setNeedsDisplay()
    }
    
    private func insertCell(cell: SectorMenuCell) {
        cell.color  = self.color
        cell.radius = self.frame.width * cellRadiusRatio
        cell.center = cellCenter!
        cell.actionButton = self
        insertSubview(cell, belowSubview: actionBtn)
    }
    
    private func openingCell(cells: [SectorMenuCell]) {
        let distance: CGFloat = 100.0
        let radi = M_PI_2 * 1/4
        
        for var i=0; i<cells.count; i++ {
            // TODO: リファクタリング
            let startPoint: CGPoint = cells[i].layer.position
            let firstTime = 0.15
            
            let first = CABasicAnimation(keyPath: "position")
            first.fromValue = [startPoint.x, startPoint.y]
            first.toValue = [startPoint.x - distance, startPoint.y]
            first.duration = firstTime
            first.removedOnCompletion = true
            first.fillMode = kCAFillModeForwards
            
            
            let anim = CAKeyframeAnimation(keyPath: "position")
            let animTime = 0.4
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
        
        for cell in cells {
            cell.userInteractionEnabled = true
        }
        
        isClosed = false
    }
    
    private func closingCell(cells: [SectorMenuCell]) {
        // TODO: cellを閉じるアニメーションをつける
        for var i=1; i<=cells.count; i++ {
            UIView.animateWithDuration(0.2,
                animations: {() -> Void  in
                    cells[i-1].center = self.cellCenter!
            })
        }
        
        for cell in cells {
            cell.userInteractionEnabled = false
//            cell.removeFromSuperview() // TODO: アニメーション完了後に削除するよに
        }
        
        isClosed = true
    }
    
    private func ringLayer(circleView: UIView) {
        let circleCenter = CGPointMake(circleView.frame.width/2, circleView.frame.height/2)
        let bigRadius = (ringRadius * 2 + bounds.width) / 2
        let minRadius = bigRadius - 50
        let bigColor = UIColor(red: 67/225, green: 135/225, blue: 233/225, alpha: 0.5)
        let minColor = UIColor.whiteColor()
        
        let bigPath: UIBezierPath = UIBezierPath()
        bigPath.moveToPoint(circleCenter)
        bigPath.addArcWithCenter(circleCenter, radius: bigRadius, startAngle: 0.0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        let bigLayer = CAShapeLayer()
        bigLayer.fillColor = bigColor.CGColor
        bigLayer.path = bigPath.CGPath
        
        let minPath: UIBezierPath = UIBezierPath()
        minPath.moveToPoint(circleCenter)
        minPath.addArcWithCenter(circleCenter, radius: minRadius, startAngle: 0.0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        let minLayer = CAShapeLayer()
        minLayer.fillColor = minColor.CGColor
        minLayer.path = minPath.CGPath
        
        bigLayer.addSublayer(minLayer)
        circleView.layer.addSublayer(bigLayer)
    }
    
    
    
    // MARK: plus
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
        anim.delegate = self
        return anim
    }
    
    
    
    // MARK: UIView
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let scale: CGFloat = 0.5
        let old = CGColorGetComponents(color.CGColor)
        let newColor = UIColor(red: old[0] + (1.0 - old[0]) * scale, green: old[1] + (1.0 - old[1]) * scale, blue: old[2] + (1.0 - old[2]) * scale, alpha: 1.0)
        actionBtn.color = newColor
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        actionBtn.color = color
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        actionBtn.color = color
        didTaped()
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
        
        return super.hitTest(point, withEvent: event)
    }

}
