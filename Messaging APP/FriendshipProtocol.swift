//
//  FriendshipProtocol.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/3/2.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import Foundation
import Firebase

protocol FriendshipDelegate:class {
    func friendshipDidGetList(friends friendsArray:[FriendInfo],beInvite beIvitedArray:[FriendInfo])
    func friendshipDidSearch(email:String?,username:String?)
    func friendshipDidCheckRelationship(result:FriendState)
}


protocol FriendshipProtocol {
    weak var delegate :FriendshipDelegate?{get set}
    
    func getFriendListFrom(_ email:String)
    func search(_ email:String)
    func checkRelationshipBy(email:String)
    func invite(email:String ,username:String)
    func accept(_ info:FriendInfo)
    func decline(_ info:FriendInfo)
    
}
extension FriendshipDelegate{
    func friendshipDidGetList(friends friendsArray:[FriendInfo],beInvite beIvitedArray:[FriendInfo]){
    }
    func friendshipDidSearch(email:String?,username:String?){
    }
    func friendshipDidCheckRelationship(result:FriendState){
    }



}
