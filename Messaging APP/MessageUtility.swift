//
//  MessageSender.swift
//  LocationTalk
//
//  Created by 鄭宇翔 on 2017/1/9.
//  Copyright © 2017年 鄭宇翔. All rights reserved.
//

import UIKit
import Firebase

class MessageUtility: AccountProtocol {

    let ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    init() {
        self.ref = FIRDatabase.database().reference()
    }
    
    func send(message: Message) {
        let friendNode = self.emailToNode(message.email)
        let myState = MyState.sharedInstance
        let myNode = self.emailToNode(myState.email!)
        
        // On my side
        ref.child("\(myNode)/send").childByAutoId().setValue(message.generateDict())
        
        // On friend's side
        var receiveMessage = Message.init(message: message.generateDict())
        receiveMessage.email = myState.email!
        receiveMessage.username = myState.username!
        ref.child("\(friendNode)/receive").childByAutoId().setValue(receiveMessage.generateDict())
    }
    
    
}
