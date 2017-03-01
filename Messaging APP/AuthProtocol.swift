//
//  AuthProtocol.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/3/1.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import Foundation

protocol  AuthDelegate:class{
    func authDidLogin(error:Error?)
    func authDidSignUp(error:Error?)
}

protocol AuthProtocol {
    weak var delegate:AuthDelegate?{get set}
    
    func currentUser() -> MyUser?
    func login(email:String,password:String)
    func signUp(email:String,password:String,username:String)
    func inputErrorAlert()
}

extension AuthDelegate{
    func authDidLogin(error:Error?){
        
    }
    func authDidSignUp(error:Error?){
        
    }



}
