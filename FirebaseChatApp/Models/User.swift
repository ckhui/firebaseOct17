//
//  User.swift
//  FirebaseChatApp
//
//  Created by Max Jala on 09/11/2017.
//  Copyright © 2017 Max Jala. All rights reserved.
//

import Foundation

class User {
    var email : String = ""
    var uid : String = ""
    
    init(anEmail: String, aUid: String) {
        email = anEmail
        uid = aUid
    }
}
