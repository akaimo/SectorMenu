//
//  SectorMenu.swift
//  SectorMenu
//
//  Created by akaimo on 2015/09/23.
//  Copyright © 2015年 akaimo. All rights reserved.
//

import UIKit

public class SectorMenu: UIView {
    
    public enum State {
        case Close
        case Expand
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience public init(frame: CGRect!, startItem: SectorMenuItem?, optionMenus aMenusArray:[SectorMenuItem]?) {
        
        self.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
//        self.timeOffset = kPathMenuDefaultTimeOffset
//        self.rotateAngle = kPathMenuDefaultRotateAngle
//        self.menuWholeAngle = kPathMenuDefaultMenuWholeAngle
//        self.startPoint = CGPointMake(kPathMenuDefaultStartPointX, kPathMenuDefaultStartPointY)
//        self.expandRotation = kPathMenuDefaultExpandRotation
//        self.closeRotation = kPathMenuDefaultCloseRotation
//        self.animationDuration = kPathMenuDefaultAnimationDuration
//        self.expandRotateAnimationDuration = kPathMenuDefaultExpandRotateAnimationDuration
//        self.closeRotateAnimationDuration = kPathMenuDefaultCloseRotateAnimationDuration
//        self.startMenuAnimationDuration = kPathMenuStartMenuDefaultAnimationDuration
//        self.rotateAddButton = true
//        
//        self.nearRadius = kPathMenuDefaultNearRadius
//        self.endRadius = kPathMenuDefaultEndRadius
//        self.farRadius = kPathMenuDefaultFarRadius
//        
//        self.menusArray = aMenusArray!
//        self.motionState = State.Close
//        
//        self.startButton = startItem!
//        self.startButton.delegate = self
//        self.startButton.center = self.startPoint
//        self.addSubview(self.startButton)
    }

}
