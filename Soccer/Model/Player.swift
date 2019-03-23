//
//  Player.swift
//  Soccer Stats
//
//  Created by User on 09/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

struct  Player: Hashable {
    
    var hashValue: Int {return identifier}
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    init?(a:String,b:String){
        self.identifier = Player.getUniqueID()
        firstName = a
        lastName = b
    }
    
    
    init?(playerId: String, playerInfo: [String : Any]) {
        self.identifier = Player.getUniqueID()

//        let dateFormater = DateFormatter()
 //       dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        
        // guard let player = Player(a: snap.value["firstName"] as? String ?? "", b: snap.value["lastName"] as? String ?? "") else {continue}


        guard let firstName = playerInfo["firstName"] as? String,
            let lastName = playerInfo["lastName"] as? String
            else { return nil }
        
        self.firstName = firstName
        self.lastName = lastName
    }
    
    private var identifier: Int

     let firstName: String
     let lastName: String
//    private let email: String
//    private let age: Int
    
   
    // MARK: - static methods 
    private static var playerId = 0
    
    private static func getUniqueID() -> Int{
        Player.playerId += 1
        return Player.playerId
    }
    
    
//    init(fName: String, lName: String, mail: String, age: Int) {
//        firstName = fName
//        lastName = lName
//        email = mail
//        self.age = age
//    }
}
