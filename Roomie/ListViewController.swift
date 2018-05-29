//
//  ListViewController.swift
//  Roomie
//
//  Created by Zachary Richardson on 5/28/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController {

    @IBOutlet weak var tabBar: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swiftColor = UIColor(red: 0/255, green: 154/255, blue: 193/255, alpha: 1)
        self.view.backgroundColor = swiftColor;
    }

}
