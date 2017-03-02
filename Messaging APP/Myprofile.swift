//
//  Myprofile.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/3/1.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit

class MyProfile: NSObject {
    static let shared = MyProfile()
    var email:String = ""
    var username:String = ""
    
    func signIn(email:String,username:String){
         self.email = email
        self.username = username
    
    }
    func signOut(){
      self.email = ""
      self.username = ""
    
    }
}
