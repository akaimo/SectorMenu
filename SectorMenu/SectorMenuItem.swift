//
//  SectorMenuItem.swift
//  SectorMenu
//
//  Created by akaimo on 2015/09/23.
//  Copyright © 2015年 akaimo. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol SectorMenuItemDelegate: NSObjectProtocol {
    func SectorMenuItemTouchesBegan(item: SectorMenuItem)
    func SectorMenuItemTouchesEnd(item:SectorMenuItem)
}

public class SectorMenuItem: UIImageView {

    public var startPoint: CGPoint?
    public var endPoint: CGPoint?
    public var nearPoint: CGPoint?
    public var farPoint: CGPoint?
    
    public weak var delegate: SectorMenuItemDelegate!
    
    private var _highlighted: Bool = false
    
    
    // MARK: init
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience override public init(image:UIImage!) {
        self.init(frame: CGRectZero)
        
        self.image = image
        self.userInteractionEnabled = true
    }
    
    
    private func ScaleRect(rect: CGRect, n: CGFloat) -> CGRect {
        let width = rect.size.width
        let height = rect.size.height
        return CGRectMake(CGFloat((width - width * n)/2), CGFloat((height - height * n)/2), CGFloat(width * n), CGFloat(height * n))
    }
    
    
    
    //MARK: UIView's methods
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if let image = self.image {
            self.bounds = CGRectMake(0, 0, image.size.width, image.size.height)
        }
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.highlighted = true
        if self.delegate.respondsToSelector("SectorMenuItemTouchesBegan:") {
            self.delegate.SectorMenuItemTouchesBegan(self)
        }
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location:CGPoint? = touch?.locationInView(self)
        if let loc = location {
            if (!CGRectContainsPoint(ScaleRect(self.bounds, n: 2.0), loc)) {
                self.highlighted = false
            }
        }
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.highlighted = false
        let touch = touches.first
        let location:CGPoint? = touch?.locationInView(self)
        if let loc = location {
            if (CGRectContainsPoint(ScaleRect(self.bounds, n: 2.0), loc)) {
                self.delegate.SectorMenuItemTouchesEnd(self)
            }
        }
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.highlighted = false
    }
}
