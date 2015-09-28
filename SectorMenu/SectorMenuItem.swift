//
//  SectorMenuItem.swift
//  SectorMenu
//
//  Created by akaimo on 2015/09/23.
//  Copyright © 2015年 akaimo. All rights reserved.
//

import Foundation
import UIKit

public class SectorMenuItem: UIImageView {

    public var startPoint: CGPoint?
    public var endPoint: CGPoint?
    public var nearPoint: CGPoint?
    public var farPoint: CGPoint?
    
//    public weak var delegate: PathMenuItemDelegate!
    
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

}
