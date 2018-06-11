//
//  RoommateViewController.swift
//  Roomie
//
//  Created by Zachary Richardson on 6/10/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CodableFirebase
import GoogleSignIn

class RoommateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addTask(_ sender: Any) {
    }
    
    var googleUser: GIDGoogleUser!
    var roomieUser: RoomieUser!
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            googleUser = GIDSignIn.sharedInstance().currentUser
        }
        else
        {
            //TODO: ERROR WITH GOOGLE LOGIN, SEND BACK
        }
        
        ref = Database.database().reference()
        ref.keepSynced(true)
        tableView.delegate = self
        tableView.dataSource = self
        
        let url = URL(string: roomieUser.profilePictureURL)
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  {
        roomieUser.myTasks.remove(at: indexPath.row)
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
        return roomieUser.myTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoommateTask", for: indexPath)
        
        if indexPath.row >= roomieUser.myTasks.count
        {
            return cell
        }
        let thisTask = roomieUser.myTasks[indexPath.row]
        cell.textLabel?.text = thisTask.description!
        return cell
    }
    
    
    

}
