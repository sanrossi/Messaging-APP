//
//  AddFriend.swift
//  LocationTalk
//
//  Created by 鄭宇翔 on 2016/12/30.
//  Copyright © 2016年 鄭宇翔. All rights reserved.
//

import Foundation
import Firebase

protocol AddFriendDelegate: class {
    func didSearchFriend(email: String?, username: String?) 
    func didCheckThisEmail(result: FriendState)
}


class AddFriend: AccountProtocol {
    let ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    weak var delagate: AddFriendDelegate?
    
    init() {
        self.ref = FIRDatabase.database().reference()
    }
    
    
    func searchFriends(_ target: String) {
        let friendNode = self.emailToNode(target)
        _refHandle = ref.child(friendNode).observe(.value, with: { [weak self] (snapshot) in
            guard let strongSelf = self else {return}
            if (snapshot.exists()) {
                let userInfo = snapshot.value as! Dictionary<String, Any>
                   strongSelf.delagate?.didSearchFriend(email: userInfo[Constants.FirebaseKey.email] as? String, username: userInfo[Constants.FirebaseKey.username] as? String)
                
            } else {
                 strongSelf.delagate?.didSearchFriend(email: nil, username: nil)
                
            }
            strongSelf.ref.child(friendNode).removeObserver(withHandle: strongSelf._refHandle)
            
        })
    
        
    }
    
    func check(_ email: String) {
        
        var availed: Bool = true
        
        let myState = MyState.sharedInstance
        if (myState.email! == email) {
            availed = false
        }
        
        let myNode = self.emailToNode(myState.email!)
        let friendNode = self.emailToNode(email)
        _refHandle = ref.child("\(myNode)/friend").observe(.value, with: { [weak self](snapshot) in
            guard let strongSelf = self else {return}
            strongSelf.ref.child("\(myNode)/friend").removeObserver(withHandle: strongSelf._refHandle)
            if (snapshot.exists()) {
                let infos = snapshot.value as! Dictionary<String, Any>
                for (k, v) in infos {
                    if (k == friendNode) {
                        let friendInfo = FriendInfo.init(v as! Dictionary<String, Any>)
                        strongSelf.delagate?.didCheckThisEmail(result: friendInfo.state)
                        availed = false
                    }
                }
            }
            if (availed) {
                strongSelf.delagate?.didCheckThisEmail(result: .none)
            }
        })
        
    }
    
    func invite(_ email: String, username: String) {
        let friendNode = self.emailToNode(email)
        let myState = MyState.sharedInstance
        let myNode = self.emailToNode(myState.email!)
        
        let friendInfo = FriendInfo.init(email, username: username, state: .invite)
        ref.child("\(myNode)/friend/\(friendNode)").setValue(friendInfo.context())
        
        let myInfo = FriendInfo.init(myState.email!, username: myState.username!, state: .beInvited)
        ref.child("\(friendNode)/friend/\(myNode)").setValue(myInfo.context())
        
    }
    
    func accept(_ info: FriendInfo) {
        let friendNode = self.emailToNode(info.email)
        let myState = MyState.sharedInstance
        let myNode = self.emailToNode(myState.email!)
        
        var newFriendInfo = FriendInfo.init(info.context())
        newFriendInfo.state = .friends
        ref.child("\(myNode)/friend/\(friendNode)").setValue(newFriendInfo.context())

        let newMyInfo = FriendInfo.init(myState.email!, username: myState.username!, state: .friends)
        ref.child("\(friendNode)/friend/\(myNode)").setValue(newMyInfo.context())
    }
    
    func decline(_ info: FriendInfo) {
        let friendNode = self.emailToNode(info.email)
        let myState = MyState.sharedInstance
        let myNode = self.emailToNode(myState.email!)
        
        let emptyInfo = Dictionary<String, Any>.init()
        ref.child("\(myNode)/friend/\(friendNode)").setValue(emptyInfo)
        ref.child("\(friendNode)/friend/\(myNode)").setValue(emptyInfo)
    }
    
    deinit {
        print("AddFriend deinit")
    }
    
}

extension AddFriendDelegate {
    func didSearchFriend(email: String?, username: String?) {
        
    }
    func didCheckThisEmail(result: FriendState) {
        
    }
}


//觀察節點是否更變 做加好友的動作

