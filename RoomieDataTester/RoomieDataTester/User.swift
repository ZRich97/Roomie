//
//  User.swift
//  RoomieDataTester
//
//  Created by Zachary Richardson on 6/3/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}

struct User {
    let userName: String
    let householdID: String
    let userID: String
    let firstName: String
    let lastName: String
    let email: String
    let profilePictureURL: String
    
    var dictionary:[String:Any] {
        return [
            "userName": userName,
            "householdID": householdID,
            "userID": userID,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "profilePictureURL": profilePictureURL
        ]
    }
}
