//
//  FirebaseUtils.swift
//  InstagramFirebase
//
//  Created by Zijia Zhai on 12/4/18.
//  Copyright © 2018 cognitiveAI. All rights reserved.
//

import Foundation
import Firebase

extension Database{
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()){
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else {return}
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        }
    }
}
