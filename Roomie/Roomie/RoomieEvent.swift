//
//  RoomieEvent.swift
//  Roomie
//
//  Created by Zachary Richardson on 5/29/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import Foundation

struct RoomieEvent : Codable {
    var date: String?
    var description: String?

    init() {
        self.date = "N/A"
        self.description = "N/A"
    }
    
    init(date: Date, description: String) {
        self.date = date.description
        self.description = description
    }
}
