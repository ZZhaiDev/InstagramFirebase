//
//  Post.swift
//  InstagramFirebase
//
//  Created by zijia on 11/15/18.
//  Copyright © 2018 cognitiveAI. All rights reserved.
//

import UIKit

struct Post {
    let imageUrl: String?
    
    init(dictionary: [String: Any]) {
        
        self.imageUrl = dictionary["imageUrl"] as? String
    }
}
