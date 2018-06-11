//
//  RoommateViewController.swift
//  Roomie
//
//  Created by Zachary Richardson on 6/10/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import UIKit

class RoommateViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addTask(_ sender: Any) {
    }
    
    var user: RoomieUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(user.firstName)
        let url = URL(string: user.profilePictureURL)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.profilePic.image = UIImage(data: data!)
                self.profilePic.layer.borderWidth = 1.0
                self.profilePic.layer.masksToBounds = false
                self.profilePic.layer.borderColor = UIColor.black.cgColor
                self.profilePic.layer.cornerRadius = 50
                self.profilePic.clipsToBounds = true
            }
        }
    }
}
