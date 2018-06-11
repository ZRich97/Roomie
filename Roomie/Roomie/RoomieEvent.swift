//
//  RoomieEvent.swift
//  Roomie
//
//  Created by Zachary Richardson on 5/29/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import Foundation

struct RoomieEvent : Codable {
    var date: String!
    var description: String!
    
    init(date: String, description: String) {
        self.date = date
        self.description = description
    }
}
