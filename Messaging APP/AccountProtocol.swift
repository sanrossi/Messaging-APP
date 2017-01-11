//
//  AccountProtocol.swift
//  Firebase_ShareDiary
//
//  Created by 鄭宇翔 on 2016/12/23.
//  Copyright © 2016年 鄭宇翔. All rights reserved.
//

import Foundation
import Firebase

protocol AccountProtocol {
    func errorAlert(title: String, message: String, onViewController: UIViewController)
//    func signIn(_ user: FIRUser?, withSegue: String ,onViewController: UIViewController)
    func emailToNode(_ email: String) -> String
}


extension AccountProtocol {
    func errorAlert(title: String, message: String, onViewController: UIViewController) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        onViewController.present(alert, animated: true, completion: nil)
    }
    
    func emailToNode(_ email: String) -> String {
        var node: String = "\(email)"
        
        if (node.contains("@")) {
            node = node.replacingOccurrences(of: "@", with: "")
        }
        
        if (node.contains(".")) {
            node = node.replacingOccurrences(of: ".", with: "")
        }

        return node
    }
}
