//
//  Player.swift
//  Soccer
//
//  Created by User on 09/10/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

struct Player {
    
    var allPlayersRanked: Double = 0
    
    var games: Int = 0
    var goals: Int = 0
    var asists: Int = 0
    var wins: Int = 0
    var tie: Int = 0
    var lose: Int = 0
    
    var speed: Double = 0
    var shoot: Double = 0
    var drible: Double = 0
    var tackle: Double = 0
    var pass: Double = 0
    var goalKeeper: Double = 0
    
    var didRank: Bool = false
    var didManager: Bool = false
    
    func avgGoals() -> Double{
        return Double(goals/games)
    }
    
    func avgAsists() -> Double{
        return Double(asists/games)
    }
    
    init(snapDict: [String : Any]) {
        games      = snapDict["games"]      as! Int
        goals      = snapDict["goals"]      as! Int
        asists     = snapDict["asists"]     as! Int
        wins       = snapDict["wins"]       as! Int
        lose       = snapDict["lose"]       as! Int
        tie        = snapDict["tie"]        as! Int
        speed      = snapDict["speed"]      as! Double
        shoot      = snapDict["shoot"]      as! Double
        drible     = snapDict["drible"]     as! Double
        tackle     = snapDict["tackle"]     as! Double
        pass       = snapDict["pass"]       as! Double
        goalKeeper = snapDict["goalKeeper"] as! Double
        allPlayersRanked = snapDict["allPlayersRanked"] as! Double
        
        if snapDict["didRank"] as! String == "false" {
            didRank = false
        } else  {
            didRank = true
        }
        
        if snapDict["didManager"] as! String == "false" {
            didManager = false
        }else  {
            didManager = true
        }
    }

    init(game:Int,goals:Int,asists:Int,wins:Int,lose:Int,tie:Int,speed:Double,shoot:Double,
         drible:Double,tackle:Double,pass:Double,goalKeeper:Double) {
        self.games      = game
        self.goals      = goals
        self.asists     = asists
        self.wins       = wins
        self.lose       = lose
        self.tie        = tie
        self.speed      = speed
        self.shoot      = shoot
        self.drible     = drible
        self.tackle     = tackle
        self.pass       = pass
        self.goalKeeper = goalKeeper
    }
    
    
}
