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

    var ref: DatabaseReference!
    
    var myEvents = [RoomieEvent]()
    var googleUser: GIDGoogleUser!
    var roomieUser: RoomieUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            googleUser = GIDSignIn.sharedInstance().currentUser
        }
        ref = Database.database().reference()
        ref.keepSynced(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        loadUserData()
    }
    
    func loadUserData()
    {
        ref.child("users").child(googleUser.userID).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            do {
                self.roomieUser = try FirebaseDecoder().decode(RoomieUser.self, from: value)
                self.fetchEvents()
            } catch let error {
                print(error)
            }
        })
    }
    
    func fetchEvents()
    {
        myEvents.removeAll()
        ref.child("households").child(roomieUser.houseID).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            do {
                var house = try FirebaseDecoder().decode(RoomieHousehold.self, from: value)
                if house.eventList == nil
                {
                    house.eventList = [RoomieEvent]()
                }
                else
                {
                    for event in house.eventList {
                        self.myEvents.append(event)
                        self.tableView.reloadData()
                    }
                }
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  {
            myEvents.remove(at: indexPath.row)
            ref.child("households").child(roomieUser.houseID).observeSingleEvent(of: .value, with: { snapshot in
                guard let value = snapshot.value else { return }
                do {
                    var house = try FirebaseDecoder().decode(RoomieHousehold.self, from: value)
                    if house.eventList == nil
                    {
                        house.eventList = [RoomieEvent]()
                    }
                    else
                    {
                        house.eventList = self.myEvents
                    }
                    let data = try! FirebaseEncoder().encode(house)
                    self.ref.child("households").child((house.houseID)!).setValue(data)
                } catch let error {
                    print(error)
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            })
        } else if editingStyle == .insert {
            print("inserting...")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)

        if indexPath.row >= myEvents.count
        {
            return cell
        }
        let thisEvent = myEvents[indexPath.row]
        cell.textLabel?.text = thisEvent.description!
        cell.detailTextLabel?.text = thisEvent.date!
        return cell
    }

}
