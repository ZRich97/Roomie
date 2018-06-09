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
        
        print(" checkFields")
        doesHouseholdExist(name: usernameField.text!, houseID: houseIDField.text!, housePassword: houseIDPasswordField.text!)
    }
    
    func isUserRegistered(name: String)
    {
            ref.child("users").child(name).observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists() {
                    print("  User Exists")
                    self.errorLabel.text = "* Username is taken *"
                    self.errorLabel.isHidden = false
                } else {
                    print("  User Doesn't Exist")
                    self.createUser()
                    self.performSegue(withIdentifier: "UserCreated", sender: nil)
                }
            }
    }
    
    func createUser()
    {
        let user = RoomieUser(userName: usernameField.text!, houseID: houseIDField.text!, firstName: firstName, lastName: lastName, email: email, profilePictureURL: profilePicURL)
        let data = try! FirebaseEncoder().encode(user)
        ref.child("users").child(user.userName!).setValue(data)
    }
    
    func doesHouseholdExist(name: String, houseID: String, housePassword: String)
    {
        ref.child("households").child(houseID).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                print("  Household Exists")
                if self.ref.child("households").child(housePassword).key == housePassword
                {
                    print("    Password Correct: \(self.ref.child("households").child(housePassword).key) and \(housePassword)")
                    self.addToHousehold(name: name, houseID: houseID)
                    self.isUserRegistered(name: self.usernameField.text!)
                }
                else
                {
                    print("    Password Incorrect")
                    self.errorLabel.text = "* Invalid HouseID Password *"
                    self.errorLabel.isHidden = false
                }
            } else {
                print("  Household Doesn't Exist")
                self.createHousehold(name: name, houseID: houseID, housePassword: housePassword)
                self.isUserRegistered(name: self.usernameField.text!)
            }
        }
    }
    
    func createHousehold(name: String, houseID: String, housePassword: String)
    {
        var users = [String]()
        users.append(name)
        let house = RoomieHousehold(houseID: houseID, housePassword: housePassword, userList: users)
        let data = try! FirebaseEncoder().encode(house)
        ref.child("households").child(houseID).setValue(data)
    }
    
    func addToHousehold(name: String, houseID: String)
    {
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
