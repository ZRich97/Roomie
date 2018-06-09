//
//  CreateUserViewController.swift
//  Roomie
//
//  Created by Zachary Richardson on 6/5/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GoogleSignIn
import FirebaseAuth
import CodableFirebase

class CreateUserViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var houseIDField: UITextField!
    @IBOutlet weak var houseIDPasswordField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    
    var ref: DatabaseReference!
    var googleUser: GIDGoogleUser!
    var firstName: String!
    var lastName: String!
    var email: String!
    var profilePicURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameField.delegate = self
        self.houseIDField.delegate = self
        self.houseIDPasswordField.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        ref = Database.database().reference()
        
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            googleUser = GIDSignIn.sharedInstance().currentUser
            firstName = googleUser.profile.givenName
            lastName = googleUser.profile.familyName
            email = googleUser.profile.email
            profilePicURL = googleUser.profile.imageURL(withDimension: 200).absoluteString
        }
        else
        {
            print("*** Google Login Invalid ***")
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        checkFields()
    }
    
    func checkFields()
    {
        errorLabel.text = ""
        errorLabel.isHidden = true
        if usernameField.text! == ""
        {
            errorLabel.text = "* Username Is Required *"
            errorLabel.isHidden = false
        } else if houseIDField.text! == ""
        {
            errorLabel.text = "* HouseID Is Required *"
            errorLabel.isHidden = false
        } else if houseIDPasswordField.text! == ""
        {
            errorLabel.text = "* HouseID Password Is Required *"
            errorLabel.isHidden = false
        }
        else
        {
            isUserRegistered()
        }
        
        print(" checkFields")
        
        
    }
    
    func isUserRegistered()
    {
        ref.child("users").child(usernameField.text!).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                print("  User Exists")
                self.errorLabel.text = "* Username is taken *"
                self.errorLabel.isHidden = false
            } else {
                print("  User Doesn't Exist")
                self.doesHouseholdExist()
            }
        }
    }
    
    func doesHouseholdExist()
    {
        ref.child("households").child(houseIDField.text!).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                print("  Household Exists")
                self.ref.child("households").child(self.houseIDField.text!).child("housePassword").observeSingleEvent(of: .value, with: { (snapshot) in
                    let password = snapshot.value! as? String
                    if password == self.houseIDPasswordField.text!
                    {
                        print("    Password Correct: \(self.ref.child("households").child("housePassword").key) and \(self.houseIDPasswordField.text!)")
                        self.createUser()
                        self.addToHousehold()
                        self.performSegue(withIdentifier: "UserCreated", sender: nil)
                    }
                    else
                    {
                        print("    Password Incorrect")
                        self.errorLabel.text = "* Invalid HouseID Password *"
                        self.errorLabel.isHidden = false
                    }
                    
                })
                
            } else {
                print("  Household Doesn't Exist")
                self.createHousehold()
                self.createUser()
                self.performSegue(withIdentifier: "UserCreated", sender: nil)
            }
        }
    }
    
    func createHousehold()
    {
        var users = [String]()
        users.append(usernameField.text!)
        let house = RoomieHousehold(houseID: houseIDField.text!, housePassword: houseIDPasswordField.text!, userList: users)
        let data = try! FirebaseEncoder().encode(house)
        ref.child("households").child(houseIDField.text!).setValue(data)
    }
    
    func createUser()
    {
        let user = RoomieUser(userName: usernameField.text!, houseID: houseIDField.text!, firstName: firstName, lastName: lastName, email: email, profilePictureURL: profilePicURL)
        let data = try! FirebaseEncoder().encode(user)
        ref.child("users").child(user.userName!).setValue(data)
    }
    
    func addToHousehold()
    {
        ref.child("households").child(houseIDField.text!).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            do {
                var house = try FirebaseDecoder().decode(RoomieHousehold.self, from: value)
                house.userList.append(self.usernameField.text!)
                let data = try! FirebaseEncoder().encode(house)
                self.ref.child("households").child(self.houseIDField.text!).setValue(data)
            } catch let error {
                print(error)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserCreated" {
     //       if let selectedSchool = sender as? School {
       //         let destVC = segue.destination as! DetailViewController
            //destVC.school = selectedSchool
            //}
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
}
