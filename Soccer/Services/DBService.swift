//
//  DBService.swift
//  Soccer Stats
//
//  Created by User on 14/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation
import Firebase

class DBService {
 
    static let shared = DBService()

    private init() {}
    
    let allTeams = Database.database().reference().child("Teams")
    let users = Database.database().reference().child("users")
    let teamOfUser = Database.database().reference().child("user-teams")
    let playersInTeam = Database.database().reference().child("team-players")
    let games = Database.database().reference().child("games")
    let playersInGame = Database.database().reference().child("players-game")

    let storageRef = Storage.storage().reference().child("image")

}
