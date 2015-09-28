//
//  ViewController.swift
//  SectorMenu
//
//  Created by akaimo on 2015/09/23.
//  Copyright © 2015年 akaimo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let circle: SectorMenuCircle = SectorMenuCircle(center: CGPoint(x: 100, y: 100), radius: 25, color: UIColor.blueColor())
        let img = UIImageView(image: UIImage(named: "Place"))
        img.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        circle.addSubview(img)
        self.view.addSubview(circle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

