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
    var profileUrl : String?
    
    init(anEmail: String, aUid: String, url : String? = nil) {
        email = anEmail
        uid = aUid
        profileUrl = url
    }
}
