//
//  Message.swift
//  LocationTalk
//
//  Created by 鄭宇翔 on 2017/1/9.
//  Copyright © 2017年 鄭宇翔. All rights reserved.
//

import Foundation

struct Message {
    var username: String
    var email: String
    var time: String
    var content: String
    
    init(email: String, username: String, time: String, content: String) {
        self.email = email
        self.username = username
        self.time = time
        self.content = content
    }
    
    init(message: Dictionary<String, String>) {
        self.email = message[Constants.FirebaseKey.email]!
        self.username = message[Constants.FirebaseKey.username]!
        self.time = message[Constants.FirebaseKey.time]!
        self.content = message[Constants.FirebaseKey.content]!
    }
    
    func generateDict() -> Dictionary<String, String> {
        
        let message = [Constants.FirebaseKey.email: self.email,
                       Constants.FirebaseKey.username: self.username,
                       Constants.FirebaseKey.time: self.time,
                       Constants.FirebaseKey.content: self.content]
        
        return message 
    }
}
