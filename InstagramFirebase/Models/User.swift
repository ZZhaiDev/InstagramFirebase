//
//  User.swift
//  InstagramFirebase
//
//  Created by Zijia Zhai on 12/4/18.
//  Copyright © 2018 cognitiveAI. All rights reserved.
//

import UIKit

class User: NSObject {
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
