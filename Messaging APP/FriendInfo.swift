//
//  FriendInfo.swift
//  LocationTalk
//
//  Created by 鄭宇翔 on 2016/12/29.
//  Copyright © 2016年 鄭宇翔. All rights reserved.
//

import UIKit
import Foundation

enum FriendState {
    case friends
    case invite
    case beInvited
    case none
}


struct FriendInfo {
    var email: String
    var username: String
    var state: FriendState
    
    init(_ info: Dictionary<String, Any>) {
        self.email = info[Constants.FirebaseKey.email] as! String
        self.username = info[Constants.FirebaseKey.username] as! String
        
        switch info[Constants.FirebaseKey.state] as! String {
        case "\(FriendState.friends)":
            self.state = .friends
            break
        case "\(FriendState.invite)":
            self.state = .invite
            break
        case "\(FriendState.beInvited)":
            self.state = .beInvited
            break
        default:
            self.state = .none
            break
        }
    }
    
    init(_ email: String, username: String, state: FriendState) {
        self.email = email
        self.username = username
        self.state = state
    }
    
    func context() -> Dictionary<String, Any> {
        
        let info = [Constants.FirebaseKey.email: self.email, Constants.FirebaseKey.username: self.username, Constants.FirebaseKey.state: "\(self.state)"]
        return info
    }
}
