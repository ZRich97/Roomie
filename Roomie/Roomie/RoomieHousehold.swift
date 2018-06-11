//
//  RoomieHousehold.swift
//  Roomie
//
//  Created by Zachary Richardson on 6/7/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import Foundation

struct RoomieHousehold : Codable {
    var houseID: String!
    var housePassword: String!
    var userList: [String]!
    var eventList: [RoomieEvent]!
    
    init(houseID: String, housePassword: String, userList: [String], eventList: [RoomieEvent]) {
        self.houseID = houseID
        self.housePassword = housePassword
        self.userList = userList
        self.eventList = eventList
    }
}
