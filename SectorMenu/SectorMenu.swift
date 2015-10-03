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

public class SectorMenu: SectorMenuCircle {
    
    public var delegate:   SectorMenuDelegate?
    public var dataSource: SectorMenuDataSource?
    
    public var isClosed = true
    
    // MARK: init
    override init(center: CGPoint, radius: CGFloat, color: UIColor) {
        super.init(center: center, radius: radius, color: color)
        setup()
    }
    
    public init(frame: CGRect) {
        super.init()
        setup()
        self.frame = frame
        self.radius = frame.width * 0.5
        self.color = UIColor.redColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: public
    public func open() {
        
    }
    
    public func close() {
        
    }
    
    
    // MARK: private
    private func setup() {
        userInteractionEnabled = true
    }
    
    private func didTaped() {
        if isClosed {
            open()
        } else {
            close()
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

}
