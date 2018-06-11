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
        return roommates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! HomeCollectionViewCell
        let url = URL(string: roommates[indexPath.row].profilePictureURL)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.button.setImage(UIImage(data: data!), for: UIControlState.normal)
                cell.layer.borderWidth = 1.0
                cell.layer.masksToBounds = false
                cell.layer.borderColor = UIColor.black.cgColor
                cell.layer.cornerRadius = 42.5
                cell.clipsToBounds = true
            }
        }
        cell.user = roommates[indexPath.row]
        return cell
    }
    
    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var googleUser: GIDGoogleUser!
    var roomieUser: RoomieUser!
    var roommates = [RoomieUser]()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
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
        
        loadUserData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //TODO: updates
    }
    
    func loadUserData()
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
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data!)
                self.profileImage.layer.borderWidth = 1.0
                self.profileImage.layer.masksToBounds = false
                self.profileImage.layer.borderColor = UIColor.black.cgColor
                self.profileImage.layer.cornerRadius = 50
                self.profileImage.clipsToBounds = true
                self.updateRoommateView()
            }
        }
    }
    
    func updateRoommateView()
    {
        print(roomieUser.houseID)
        ref.child("households").child(roomieUser.houseID).child("userList").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                self.loadRoommateData(userID: snap.value! as! String)
            }
        })
    }
    
    func loadRoommateData(userID: String)
    {
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            do {
                let user = try FirebaseDecoder().decode(RoomieUser.self, from: value)
                self.roommates.append(user)
                self.collectionView.reloadData()
            } catch let error {
                print(error)
            }
        })
    }
    
    func updateListView()
    {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoommate" {
            let destVC = segue.destination as! RoommateViewController
            destVC.user = roomieUser
        }
    }
    
    
}
