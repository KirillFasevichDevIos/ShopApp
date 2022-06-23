//
//  User.swift
//  ShopAppProj
//
//  Created by admin on 21.06.2022.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(user: Firebase.User) {
        self.uid = user.uid
        self.email = user.email ?? ""
    }
    
}
