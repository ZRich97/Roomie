//
//  HomeCollectionViewCell.swift
//  Roomie
//
//  Created by Zachary Richardson on 6/9/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBAction func imageClicked(_ sender: Any) {
        print("clicked")
    }
}
