//
//  ListTableViewController.swift
//  Roomie
//
//  Created by Zachary Richardson on 5/29/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import UIKit
import Firebase

class ListTableViewController: UITableViewController {

    var databaseRef: DatabaseReference!
    var myEvents : RoomieData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        
        
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (myEvents?.events.count) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastDayCell", for: indexPath)
        
        let thisEvent = myEvents?.events[indexPath.row]
        
        // Configure the cell...
        cell.textLabel?.text = "\(String(describing: thisEvent?.description))"
        cell.detailTextLabel?.text = "\(String(describing: thisEvent?.date?.description))"

        return cell
    }

}
