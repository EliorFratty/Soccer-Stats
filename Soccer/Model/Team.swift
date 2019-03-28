//
//  Team.swift
//  Soccer Stats
//
//  Created by User on 09/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

struct Team {
    

    var name: String?
    var players = [Player]()
    var startingDate: Date = Date()

    mutating func addPlayer(player: Player){
        players.append(player)
    }
}
