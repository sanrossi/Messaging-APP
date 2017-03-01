//
//  FirebaseAuth.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/3/1.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import Foundation
import Firebase

//class FirebaseAuth: MyFirebase,AccountProtocol,AuthProtocol{
//
//
//    weak var delagate: AuthDelegate?
//    
//    deinit {
//        print("Authentication deinit")
//    }
//    
//    func currentUser() -> MyUser? {
//        if let user = FIRAuth.auth()?.currentUser {
//            let myUser = MyUser.init(email: user.email!, username: user.displayName!)
//            return myUser
//        }
//        return nil
//    }
//    
//    func login(email: String, password: String) {
//        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
//            guard let strongSelf = self else {return}
//            strongSelf.delagate?.authDidLogin(error: error)
//        })
//    }
//    
//    func signUp(email: String, password: String, username: String) {
//        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
//            guard let strongSelf = self else {return}
//            if error == nil {
//                strongSelf.setDisplayName(user!, displayname: username)
//                let userInfo = [Constants.FirebaseKey.email: email, Constants.FirebaseKey.password: password, Constants.FirebaseKey.username: username]
//                let node = strongSelf.emailToNode(email)
//                strongSelf.ref.child(node).setValue(userInfo)
//            }
//            strongSelf.delagate?.authDidSignUp(error: error)
//        })
//    }
//    
//    func setDisplayName(_ user: FIRUser, displayname: String) {
//        let changeRequest = user.profileChangeRequest()
//        changeRequest.displayName = displayname
//        changeRequest.commitChanges(){ (error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//        }
//    }
//    
//    func signOut() {
//        do {
//            try FIRAuth.auth()?.signOut()
//            MyProfile.shared.signedOut()
//        } catch  {
//            print("Error signing out: \(error.localizedDescription)")
//        }
//    }
//    
//    func inputErrorAlert() {
//        // Called upon signup error to let the user know signup didn't work.
//        let alert = UIAlertController(title: Constants.ErrorAlert.alertTitle, message: Constants.ErrorAlert.loginMissingMessage, preferredStyle: UIAlertControllerStyle.alert)
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(action)
//        if let vc = self.delagate as? UIViewController {
//            vc.present(alert, animated: true, completion: nil)
//        }
//    }    weak var delagate: AuthDelegate?
//    
//    deinit {
//        print("Authentication deinit")
//    }
//    
//    func currentUser() -> MyUser? {
//        if let user = FIRAuth.auth()?.currentUser {
//            let myUser = MyUser.init(email: user.email!, username: user.displayName!)
//            return myUser
//        }
//        return nil
//    }
//    
//    func login(email: String, password: String) {
//        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
//            guard let strongSelf = self else {return}
//            strongSelf.delagate?.authDidLogin(error: error)
//        })
//    }
//    
//    func signUp(email: String, password: String, username: String) {
//        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
//            guard let strongSelf = self else {return}
//            if error == nil {
//                strongSelf.setDisplayName(user!, displayname: username)
//                let userInfo = [Constants.FirebaseKey.email: email, Constants.FirebaseKey.password: password, Constants.FirebaseKey.username: username]
//                let node = strongSelf.emailToNode(email)
//                strongSelf.ref.child(node).setValue(userInfo)
//            }
//            strongSelf.delagate?.authDidSignUp(error: error)
//        })
//    }
//    
//    func setDisplayName(_ user: FIRUser, displayname: String) {
//        let changeRequest = user.profileChangeRequest()
//        changeRequest.displayName = displayname
//        changeRequest.commitChanges(){ (error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//        }
//    }
//    
//    func signOut() {
//        do {
//            try FIRAuth.auth()?.signOut()
//            MyProfile.shared.signedOut()
//        } catch  {
//            print("Error signing out: \(error.localizedDescription)")
//        }
//    }
//    
//    func inputErrorAlert() {
//        // Called upon signup error to let the user know signup didn't work.
//        let alert = UIAlertController(title: Constants.ErrorAlert.alertTitle, message: Constants.ErrorAlert.loginMissingMessage, preferredStyle: UIAlertControllerStyle.alert)
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(action)
//        if let vc = self.delagate as? UIViewController {
//            vc.present(alert, animated: true, completion: nil)
//        }
//    }    weak var delagate: AuthDelegate?
//    
//    deinit {
//        print("Authentication deinit")
//    }
//    
//    func currentUser() -> MyUser? {
//        if let user = FIRAuth.auth()?.currentUser {
//            let myUser = MyUser.init(email: user.email!, username: user.displayName!)
//            return myUser
//        }
//        return nil
//    }
//    
//    func login(email: String, password: String) {
//        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
//            guard let strongSelf = self else {return}
//            strongSelf.delagate?.authDidLogin(error: error)
//        })
//    }
//    
//    func signUp(email: String, password: String, username: String) {
//        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
//            guard let strongSelf = self else {return}
//            if error == nil {
//                strongSelf.setDisplayName(user!, displayname: username)
//                let userInfo = [Constants.FirebaseKey.email: email, Constants.FirebaseKey.password: password, Constants.FirebaseKey.username: username]
//                let node = strongSelf.emailToNode(email)
//                strongSelf.ref.child(node).setValue(userInfo)
//            }
//            strongSelf.delagate?.authDidSignUp(error: error)
//        })
//    }
//    
//    func setDisplayName(_ user: FIRUser, displayname: String) {
//        let changeRequest = user.profileChangeRequest()
//        changeRequest.displayName = displayname
//        changeRequest.commitChanges(){ (error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//        }
//    }
//    
//    func signOut() {
//        do {
//            try FIRAuth.auth()?.signOut()
//            MyProfile.shared.signedOut()
//        } catch  {
//            print("Error signing out: \(error.localizedDescription)")
//        }
//    }
//    
//    func inputErrorAlert() {
//        // Called upon signup error to let the user know signup didn't work.
//        let alert = UIAlertController(title: Constants.ErrorAlert.alertTitle, message: Constants.ErrorAlert.loginMissingMessage, preferredStyle: UIAlertControllerStyle.alert)
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(action)
//        if let vc = self.delagate as? UIViewController {
//            vc.present(alert, animated: true, completion: nil)
//        }
//    }
//
//
//
//}
