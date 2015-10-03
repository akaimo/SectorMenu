//
//  SectorMenu.swift
//  SectorMenu
//
//  Created by akaimo on 2015/09/23.
//  Copyright © 2015年 akaimo. All rights reserved.
//

import UIKit

public class SectorMenu: SectorMenuCell {
    
    // MARK: init
    override init(center: CGPoint, radius: CGFloat, color: UIColor, icon: UIImage) {
        super.init(center: center, radius: radius, color: color, icon: icon)
        setup()
    }
    
    override init(center: CGPoint, radius: CGFloat, color: UIColor, view: UIView) {
        super.init(center: center, radius: radius, color: color, view: view)
        setup()
    }
    
    public init(frame: CGRect, icon: UIImage) {
        super.init(icon: icon)
        setup()
        self.frame = frame
        self.radius = frame.width * 0.5
        self.color = UIColor.redColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: private
    private func setup() {
        userInteractionEnabled = true
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
        color = originalColor
    }

}
