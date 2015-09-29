//
//  SectorMenuCell.swift
//  SectorMenu
//
//  Created by akaimo on 2015/09/29.
//  Copyright © 2015年 akaimo. All rights reserved.
//

import Foundation
import UIKit

public class SectorMenuCell: SectorMenuCircle {
    
    let internalRatio: CGFloat = 0.75
    
    public var responsible = true
    public var imageView = UIImageView()
//    weak var actionButton: LiquidFloatingActionButton?
    
    // for implement responsible color
    private var originalColor: UIColor
    
    public override var frame: CGRect {
        didSet {
            resizeSubviews()
        }
    }
    
    
    // MARK: init
    init(center: CGPoint, radius: CGFloat, color: UIColor, icon: UIImage) {
        self.originalColor = color
        super.init(center: center, radius: radius, color: color)
        setup(icon)
    }
    
    init(center: CGPoint, radius: CGFloat, color: UIColor, view: UIView) {
        self.originalColor = color
        super.init(center: center, radius: radius, color: color)
        setupView(view)
    }
    
    public init(icon: UIImage) {
        self.originalColor = UIColor.clearColor()
        super.init()
        setup(icon)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
