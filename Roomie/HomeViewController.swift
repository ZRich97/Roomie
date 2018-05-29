//
//  HomeViewController.swift
//  Roomie
//
//  Created by Zachary Richardson on 5/28/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import UIKit
import GoogleSignIn

class HomeViewController: UIViewController {

    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user: GIDGoogleUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeViewController::viewDidLoad...")
        let swiftColor = UIColor(red: 0/255, green: 154/255, blue: 193/255, alpha: 1)
        self.view.backgroundColor = swiftColor;
    
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            print("HomeViewController::SignedIn...")
            user = GIDSignIn.sharedInstance().currentUser
            
            // Asynchronously Download Weather Icon
            DispatchQueue.global(qos: .userInitiated).async {
                let responseData = try? Data(contentsOf: (self.user?.profile.imageURL(withDimension: 200))!)
                let downloadedImage = UIImage(data: responseData!)
                DispatchQueue.main.async {
                    self.profileImage.image = downloadedImage
                }
            }
            nameLabel.text = "Hello \(user?.profile.name! ?? "Non Logged-In User")"
        }
        
        

    
    }
    
    
    

}
