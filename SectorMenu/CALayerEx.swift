//
//  CALayerEx.swift
//  SectorMenu
//
//  Created by akaimo on 2015/09/24.
//  Copyright © 2015年 akaimo. All rights reserved.
//

import UIKit

extension CALayer {
    func appendShadow() {
        shadowColor = UIColor.blackColor().CGColor
        shadowRadius = 2.0
        shadowOpacity = 0.1
        shadowOffset = CGSize(width: 4, height: 4)
        masksToBounds = false
    }
    
    func eraseShadow() {
        shadowRadius = 0.0
        shadowColor = UIColor.clearColor().CGColor
    }
}
