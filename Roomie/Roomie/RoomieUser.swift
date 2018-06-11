//
//  RoomieUser.swift
//  Roomie
//
//  Created by Zachary Richardson on 6/6/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import Foundation

struct RoomieUser : Codable {
    var userName: String!
    var houseID: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var profilePictureURL: String!
    var myTasks: [RoomieEvent]!
    
    init(userName: String, houseID: String, firstName: String, lastName: String, email: String, profilePictureURL: String, myTasks: [RoomieEvent]) {
        self.userName = userName
        self.houseID = houseID
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profilePictureURL = profilePictureURL
        self.myTasks = myTasks
    }
}
