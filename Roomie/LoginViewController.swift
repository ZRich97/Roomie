//
//  LoginViewController.swift
//  Roomie
//
//  Created by Zachary Richardson on 5/28/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var googleLogin: GIDSignInButton!
    @IBOutlet weak var myLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VIEWDIDLOAD")

        let swiftColor = UIColor(red: 0/255, green: 154/255, blue: 193/255, alpha: 1)
        self.view.backgroundColor = swiftColor;

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("ERROR: \(error)")
            return
        }
        
        print("SIGNING IN LOGIN")
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("ERROR: \(error)")
                return
            }
            // User is signed in
            
        }
    }

}
