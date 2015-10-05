//
//  ViewController.swift
//  SectorMenu
//
//  Created by akaimo on 2015/09/23.
//  Copyright © 2015年 akaimo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SectorMenuDataSource, SectorMenuDelegate {
    
    var cells: [SectorMenuCell] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let circle: SectorMenuCircle = SectorMenuCircle(center: CGPoint(x: 100, y: 100), radius: 25, color: UIColor.blueColor())
        let img = UIImageView(image: UIImage(named: "Place"))
        img.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        circle.addSubview(img)
        self.view.addSubview(circle)
        
        let cell: SectorMenuCell = SectorMenuCell(icon: UIImage(named: "Place")!)
        cell.radius = 25
        cell.color = UIColor.blueColor()
        cell.frame = CGRect(x: 200, y: 200, width: 50, height: 50)
        self.view.addSubview(cell)
        
        let sectorMenu: SectorMenu = SectorMenu(frame: CGRect(x: 150, y: 300, width: 50, height: 50))
        sectorMenu.delegate = self
        sectorMenu.dataSource = self
        self.view.addSubview(sectorMenu)
        
        cells.append(SectorMenuCell(icon: UIImage(named: "Place")!))
        cells.append(SectorMenuCell(icon: UIImage(named: "Place")!))
        cells.append(SectorMenuCell(icon: UIImage(named: "Place")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: SectorMenuDataSource Delegate
    func numberOfCells(sectorMenu: SectorMenu) -> Int {
        return cells.count
    }
    
    func cellForIndex(index: Int) -> SectorMenuCell {
        return cells[index]
    }
    
    func sectorMenu(sectorMenu: SectorMenu, didSelectItemAtIndex index: Int) {
        print("did Tapped! \(index)")
    }
    
}

