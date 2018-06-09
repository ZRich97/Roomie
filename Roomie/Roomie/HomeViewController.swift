//
//  HomeViewController.swift
//  Roomie
//
//  Created by Zachary Richardson on 5/28/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import CodableFirebase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! HomeCollectionViewCell
        return cell
    }

    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: GIDGoogleUser!
    var myUser: RoomieUser!
    var roommates: [RoomieUser]!
    var databaseRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            print("HomeViewController::SignedIn")
            user = GIDSignIn.sharedInstance().currentUser
            DispatchQueue.global(qos: .userInitiated).async {
                let responseData = try? Data(contentsOf: (self.user?.profile.imageURL(withDimension: 100))!)
                let downloadedImage = UIImage(data: responseData!)
                DispatchQueue.main.async {
                    self.profileImage.image = downloadedImage
                    self.profileImage.layer.borderWidth = 1.0
                    self.profileImage.layer.masksToBounds = false
                    self.profileImage.layer.borderColor = UIColor.black.cgColor
                    self.profileImage.layer.cornerRadius = 50
                    self.profileImage.clipsToBounds = true
                }
            }
            nameLabel.text = "Hello \(user?.profile.givenName! ?? "Non Logged-In User")"
        }
        databaseRef = Database.database().reference()
        databaseRef.keepSynced(true)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        databaseRef.child("events").child("\(user!.userID!)").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value else { return }
            do {
                let event = try FirebaseDecoder().decode(RoomieEvent.self, from: value)
            } catch let error {
                print(error)
            }
        })
    }
    
}
