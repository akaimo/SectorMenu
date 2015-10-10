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
        
        let btnFrame = CGRect(x: self.view.frame.size.width - 100, y: self.view.frame.size.height - 80, width: 50, height: 50)
//        let btnFrame = CGRect(x: self.view.center.x - 25, y: self.view.center.y - 25, width: 50, height: 50)
        let sectorMenu: SectorMenu = SectorMenu(frame: btnFrame)
        sectorMenu.delegate = self
        sectorMenu.dataSource = self
        self.view.addSubview(sectorMenu)
        
        cells.append(SectorMenuCell(icon: UIImage(named: "Place")!))
        cells.append(SectorMenuCell(icon: UIImage(named: "Place")!))
        cells.append(SectorMenuCell(icon: UIImage(named: "Place")!))
        cells.append(SectorMenuCell(icon: UIImage(named: "Place")!))
        cells.append(SectorMenuCell(icon: UIImage(named: "Place")!))
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

