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
    
    private let actionBtn = SectorMenuCircle()
    private let plusLayer   = CAShapeLayer()
    private var plusRotation: CGFloat = 0
    
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
    
    
    // MARK: public
    public func open() {
        // TODO: plusを回転させる
        
        let cells = cellArray()
        for cell in cells {
            insertCell(cell)
        }
        
        openingCell(cells)
        setNeedsDisplay()
    }
    
    public func close() {
        
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
    
    
    // MARK: private
    private func setup() {
        self.backgroundColor = UIColor.clearColor()
        userInteractionEnabled = true
        
        drawPlus(plusRotation)
        
        actionBtn.radius = self.frame.size.width * 0.5
        actionBtn.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        actionBtn.color = color
        actionBtn.circleLayer.addSublayer(plusLayer)
        addSubview(actionBtn)
    }
    
    private func didTaped() {
        if isClosed {
            open()
        } else {
            close()
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
    
    private func cellArray() -> [SectorMenuCell] {
        var result: [SectorMenuCell] = []
        if let source = dataSource {
            for i in 0..<source.numberOfCells(self) {
                result.append(source.cellForIndex(i))
            }
        }
        return result
    }
    
    private func insertCell(cell: SectorMenuCell) {
        cell.color  = self.color
        cell.radius = self.frame.width * cellRadiusRatio
        cell.center = CGPoint(x: self.center.x - self.frame.origin.x, y: self.center.y - self.frame.origin.y)
        cell.actionButton = self
        insertSubview(cell, belowSubview: actionBtn)
    }
    
    private func openingCell(cells: [SectorMenuCell]) {
        // TODO: cellを展開する
        for var i=1; i<=cells.count; i++ {
//            cells[i-1].frame.origin.y -= CGFloat(60 * i)
            UIView.animateWithDuration(1,
                animations: {() -> Void  in
                    cells[i-1].frame.origin.y -= CGFloat(60 * i)
            })
        }
        
        for cell in cells {
            cell.userInteractionEnabled = true
        }
    }
    
    
    
    // MARK: UIView
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        print("touchBegan")
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        color = originalColor
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
