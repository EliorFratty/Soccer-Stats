//
//  Player.swift
//  Soccer Stats
//
//  Created by User on 09/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

struct Player {

    var id: String?
     var fullName: String
     var email: String
     var profileImageUrl: String

    
    init() {
        id = ""
        fullName = ""
        email = ""
        profileImageUrl = ""
    }

init(id: String ,fullName:String, email:String, ProfileUrl:String){
    self.id = id
    self.fullName = fullName
    self.email = email
    profileImageUrl = ProfileUrl
}
    

}
