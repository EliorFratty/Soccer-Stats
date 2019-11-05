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
    let players = Database.database().reference().child("Players")
    let teamOfUser = Database.database().reference().child("user-teams")
    let playersInTeam = Database.database().reference().child("team-players")
    let games = Database.database().reference().child("games")
    let playersInGame = Database.database().reference().child("players-game")

    let storageRef = Storage.storage().reference().child("image")
    
    
    func checkIfUserIsLoggedIn() -> Bool {
        return Auth.auth().currentUser?.uid == nil
    }
    
    func getUserDetailes(completion: @escaping (User) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {print("Error") ; return }
        
        DBService.shared.users.child(uid).observeSingleEvent(of:.value) { (snapshot) in
            
            if let dict = snapshot.value as? [String:Any] {
                
                let player = User(id: snapshot.key, dict: dict)
                completion(player)
                
            }
        }
    }
    
    func getPlayerDetailes(userName:String, completion: @escaping (Player) -> ()) {
        
        DBService.shared.players.child(userName).observeSingleEvent(of:.value) { (snapshot) in
            
            if let dict = snapshot.value as? [String:Any] {
                
                let player = Player(snapDict: dict)
                completion(player)
                
            }
        }
    }
    
    func reciveTeamsFromDB(completion: @escaping ([Team]) -> ()) {
        
        guard let uid = Auth.auth().currentUser?.uid else {print("Error to get uid") ; return }
        var teamsFromDB = [Team]()
        
        DBService.shared.teamOfUser.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            if let teamsName = snapshot.value as? [String:Any] {
                
                for teamName in teamsName {
                    self.getUserTeamDetailesFromDB(teamName: teamName.key, completion: { (team) in
                        teamsFromDB.append(team)
                        completion(teamsFromDB)
                    })
                }
            }
        }
    }
    
    func getUserTeamDetailesFromDB(teamName: String, completion: @escaping (Team) -> () ) {
        
        DBService.shared.allTeams.child(teamName).observe(.value, with: { (snapshot) in
            
            guard let snapDict = snapshot.value as? [String : Any] else {return}
            
            let team = Team(snapDict: snapDict)
            
            completion(team)
            
        })
    }

}
