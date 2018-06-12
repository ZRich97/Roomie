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
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func addTask(_ sender: Any) {
        addTaskToDatabase(date: Date(), description: textField.text!)
    }
    
    func addTaskToDatabase(date: Date, description: String)
    {
        ref.child("users").child(roomieUser.userID).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            do {
                var user = try FirebaseDecoder().decode(RoomieUser.self, from: value)
                if user.myTasks == nil
                {
                    user.myTasks = [RoomieEvent]()
                }
                user.myTasks.append(RoomieEvent(date: self.formatter.string(from: date), description: description))
                self.roomieUser.myTasks.append(RoomieEvent(date: self.formatter.string(from: date), description: description))
                let data = try! FirebaseEncoder().encode(user)
                self.ref.child("users").child(self.roomieUser.userID).setValue(data)
                self.tableView.reloadData()
                self.textField.text = ""
            } catch let error {
                print(error)
            }
        })
    }
    
    var googleUser: GIDGoogleUser!
    var roomieUser: RoomieUser!
    var ref: DatabaseReference!
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "MMMM dd yyyy"
        
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
        tableView.reloadData()
        nameLabel.text = "\(roomieUser.userName!)'s Tasks"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if roomieUser.myTasks == nil
        {
            roomieUser.myTasks = [RoomieEvent]()
        }
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
