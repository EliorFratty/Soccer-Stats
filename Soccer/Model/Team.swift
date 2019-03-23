//
//  Team.swift
//  Soccer Stats
//
//  Created by User on 09/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

struct Team: Hashable {
    
    // MARK - hash methods
    var hashValue: Int {return identifier}
    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    // MARK - uniq ID methods
    private var identifier: Int = 0
    private static var teamId = 0
    private static func getUniqueID() -> Int{
        Team.teamId += 1
        return Team.teamId
    }
    
    // MARK - props
    
    var name: String?
    var players = [Player]()
    var startingDate: Date = Date()

    // MARK - Init
    init (name: String){
        self.identifier = Team.getUniqueID()
        self.name = name
    }

    mutating func addPlayer(player: Player){
        players.append(player)
    }
}
