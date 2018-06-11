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

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var googleUser: GIDGoogleUser!
    var roomieUser: RoomieUser!
    var roommates = [RoomieUser]()
    var ref: DatabaseReference!
    var myTasks = [RoomieEvent]()
    
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
        collectionView.allowsSelection = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        roommates.removeAll()
        loadUserData()
    }
    
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch  {
            print("Error Logging Out.")
        }
        GIDSignIn.sharedInstance().signOut()
    }
    
    func loadUserData()
    {
        ref.child("users").child(googleUser.userID).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            do {
                self.roomieUser = try FirebaseDecoder().decode(RoomieUser.self, from: value)
                self.updateUserView()
                if self.roomieUser.myTasks == nil
                {
                    self.roomieUser.myTasks = [RoomieEvent]()
                }
                self.myTasks = self.roomieUser.myTasks
                self.tableView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoommateSegue" {
            let selectedUser = sender as! Int
            let vc = segue.destination as! RoommateViewController
            print(roommates[selectedUser].email)
            vc.roomieUser = roommates[selectedUser]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  {
            myTasks.remove(at: indexPath.row)
            roomieUser.myTasks = myTasks
            let data = try! FirebaseEncoder().encode(roomieUser)
            self.ref.child("users").child(googleUser.userID).setValue(data)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
        else if editingStyle == .insert
        {
            print("inserting...")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTaskCell", for: indexPath)
        
        if indexPath.row >= myTasks.count
        {
            return cell
        }
        let thisTask = myTasks[indexPath.row]
        cell.textLabel?.text = thisTask.description!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roommates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! HomeCollectionViewCell
        let url = URL(string: roommates[indexPath.row].profilePictureURL)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.image.image = UIImage(data: data!)
                cell.layer.borderWidth = 1.0
                cell.layer.masksToBounds = false
                cell.layer.borderColor = UIColor.black.cgColor
                cell.layer.cornerRadius = 42.5
                cell.clipsToBounds = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "RoommateSegue", sender: indexPath.row)
    }
    
}
