//
//  ViewController.swift
//  RoomieDataTester
//
//  Created by Zachary Richardson on 6/3/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class ViewController: UIViewController {

    var db: Firestore!
    var users = [User]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings

        
        saveData()
        
        loadData()
        
        
        
    }

    func loadData()
    {
        db.collection("Users").getDocuments() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                self.users = querySnapshot!.documents.flatMap({User(dictionary: $0.data(), householdID: <#String#>)})
                print(users)
            }
        }
    }
    
    func saveData()
    {
        let zack = User(userName: "ZRich", householdID: "252Sandercock", userID: "820980923", firstName: "Zack", lastName: "Richardson", email: "zackrichardson97@gmail.com", profilePictureURL: "zack.com")
        
        let luke = User(userName: "Luke7", householdID: "9865KraftAve", userID: "28309230", firstName: "Luke", lastName: "Richardson", email: "lr202@flhsemail.org", profilePictureURL: "luke.com")
        
        let ryan = User(userName: "Ryan", householdID: "252Sandercock", userID: "203902930", firstName: "Ryan", lastName: "Golmassian", email: "rgolmass@calpoly.edu", profilePictureURL: "ryan.com")
        
        users.append(zack)
        users.append(ryan)
        users.append(luke)
        
        
        var ref:DocumentReference? = nil
        
        for user in users
        {
            ref = self.db.collection("Users/zdrichar").addDocument(data: user.dictionary)
            {
                error in
                
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

