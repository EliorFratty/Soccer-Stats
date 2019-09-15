//
//  Team.swift
//  Soccer Stats
//
//  Created by User on 09/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

struct Team {
    
    var date: String?
    var name: String?
    var teamImoji: String?
    var teamSummary: String?
    
    init(snapDict: [String : Any]) {
        name = snapDict["name"] as? String
        date = snapDict["date"] as? String
        teamSummary = snapDict["summary"] as? String
        teamImoji = snapDict["imoji"] as? String ?? "A"
    }
    
    init() {
        date = ""
        name = ""
        teamImoji = ""
        teamSummary = ""
    }

}
