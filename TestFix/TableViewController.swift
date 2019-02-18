//
//  TableViewController.swift
//  TestFix
//
//  Created by Max on 2019/2/18.
//  Copyright © 2019 Max Wang. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    open override var shouldAutorotate: Bool {
        let result = true
        debugPrint("Table是否允许旋转:\(result)")
        return result
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        let result: UIInterfaceOrientationMask = [.portrait]
        debugPrint("Table支持的方向:\(result)")
        return result
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        let result = UIInterfaceOrientation.portrait
        debugPrint("Table首选显示方向:\(result)")
        return result
    }

}
