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
    
    var googleUser: GIDGoogleUser!
    var roomieUser: RoomieUser!
    var roommates: [RoomieUser]!
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            print("HomeViewController::SignedIn")
            googleUser = GIDSignIn.sharedInstance().currentUser
            nameLabel.text = "Hello \(googleUser?.profile.givenName! ?? "Non Logged-In User")"
        }
        else
        {
            //TODO: ERROR WITH GOOGLE LOGIN, SEND BACK
        }
        
        ref = Database.database().reference()
        ref.keepSynced(true)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadUserDate()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //TODO: updates
    }
    
    func loadUserDate()
    {
        ref.child("users").child(googleUser.userID).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            do {
                self.roomieUser = try FirebaseDecoder().decode(RoomieUser.self, from: value)
                self.updateUserView()
            } catch let error {
                print(error)
            }
        })
    }
    
    func updateUserView()
    {
        let url = URL(string: roomieUser.profilePictureURL)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data!)
                self.profileImage.layer.borderWidth = 1.0
                self.profileImage.layer.masksToBounds = false
                self.profileImage.layer.borderColor = UIColor.black.cgColor
                self.profileImage.layer.cornerRadius = 50
                self.profileImage.clipsToBounds = true
            }
        }
    }
    
    func updateRoommateView()
    {
        
    }
    
    func updateListView()
    {
        
    }
    
    
}
