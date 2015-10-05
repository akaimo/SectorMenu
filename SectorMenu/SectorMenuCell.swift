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
    weak var actionButton: SectorMenu?
    
    // for implement responsible color
    var originalColor: UIColor
    
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
    
    
    func setup(image: UIImage, tintColor: UIColor = UIColor.whiteColor()) {
        imageView.image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imageView.tintColor = tintColor
        setupView(imageView)
    }
    
    func setupView(view: UIView) {
        userInteractionEnabled = false
        addSubview(view)
        resizeSubviews()
    }
    
    private func resizeSubviews() {
        let size = CGSize(width: frame.width * 0.5, height: frame.height * 0.5)
        imageView.frame = CGRect(x: frame.width - frame.width * internalRatio, y: frame.height - frame.height * internalRatio, width: size.width, height: size.height)
    }
    
    
    // MARK: UIView
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if responsible {
            originalColor = color
            let scale: CGFloat = 0.5
            let old = CGColorGetComponents(originalColor.CGColor)
            let newColor = UIColor(red: old[0] + (1.0 - old[0]) * scale, green: old[1] + (1.0 - old[1]) * scale, blue: old[2] + (1.0 - old[2]) * scale, alpha: 1.0)
            color = newColor
            setNeedsDisplay()
        }
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if responsible {
            color = originalColor
            setNeedsDisplay()
        }
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        color = originalColor
        actionButton?.didTappedCell(self)
    }

}
