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
        // Do any additional setup after loading the view, typically from a nib.
        
//        let place = UIImage(named: "Place")
//        let starMenuItem1: SectorMenuItem = SectorMenuItem(image: place)
//        starMenuItem1.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
//        starMenuItem1.backgroundColor = UIColor.blueColor()
//        
//        self.view.addSubview(starMenuItem1)
        
        let circle: SectorMenuCircle = SectorMenuCircle()
        circle.radius = 25
        circle.frame = CGRect(x: 50, y: 50, width: 50, height: 50)
        let img = UIImageView(image: UIImage(named: "Place"))
        img.frame = CGRect(x: 12.5, y: 12.5, width: 25, height: 25)
        circle.addSubview(img)
        self.view.addSubview(circle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

