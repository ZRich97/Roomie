//
//  ListTableViewController.swift
//  Roomie
//
//  Created by Zachary Richardson on 5/29/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import CodableFirebase

class ListTableViewController: UITableViewController {

    var databaseRef: DatabaseReference!
    var refHandle: UInt!
    
    var myEvents = [RoomieEvent]()
    var user: GIDGoogleUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ListTableViewController::viewDidLoad")

        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            print("ListTableViewController::SignedIn")
            user = GIDSignIn.sharedInstance().currentUser
        }
        
        databaseRef = Database.database().reference()
        databaseRef.keepSynced(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        print("ListTableViewController::viewDidAppear")
        fetchEvents()
        tableView.reloadData()
    }
    
    func fetchEvents()
    {
        myEvents.removeAll()
        print("ListTableViewController::FetchEvents")
        databaseRef.child("events").child("\(user!.userID!)").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value else { return }
            do {
                let event = try FirebaseDecoder().decode(RoomieEvent.self, from: value)
                self.myEvents.append(event)
                self.tableView.reloadData()
            } catch let error {
                print(error)
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let thisEvent = myEvents[indexPath.row]
        cell.textLabel?.text = "\(String(describing: thisEvent.description!))"
        cell.detailTextLabel?.text = "\(String(describing: thisEvent.date!.description))"

        return cell
    }

}
