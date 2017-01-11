//
//  Authentication.swift
//  LocationTalk
//
//  Created by 鄭宇翔 on 2017/1/4.
//  Copyright © 2017年 鄭宇翔. All rights reserved.
//

import Foundation
import Firebase
protocol AuthenticationProtocol: class {
    func didLogin(user: FIRUser?, error: Error?)
    func didSignup(user: FIRUser?, error: Error?)
}


class Authentication: AccountProtocol {
    
    weak var delagate: AuthenticationProtocol?
    var ref: FIRDatabaseReference!
    
    init() {
        self.ref = FIRDatabase.database().reference()
    }
    
    deinit {
        print("Authentication deinit")
    }
    
    func login(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            guard let strongSelf = self else {return}
            strongSelf.delagate?.didLogin(user: user, error: error)
        })
    }
    
    func signup(email: String, password: String, username: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
            guard let strongSelf = self else {return}
            if let error = error {
                strongSelf.delagate?.didSignup(user: user, error: error)
                return
            }
            strongSelf.setDisplayName(user!, displayname: username)
            let userInfo = [Constants.FirebaseKey.email: email, Constants.FirebaseKey.password: password, Constants.FirebaseKey.username: username]
            let node = strongSelf.emailToNode(email)
            strongSelf.ref.child(node).setValue(userInfo)
            strongSelf.delagate?.didSignup(user: user, error: error)
        })
    }
    
    
    func signIn(_ user: FIRUser?, segue: String) {
        print("Login successfully")
        let myState = MyState.sharedInstance
        myState.signedIn = true
        myState.email = user!.email!
        myState.username = user!.displayName
        DispatchQueue.main.async {
            if let vc = self.delagate as? UIViewController {
                vc.performSegue(withIdentifier: segue, sender: nil)
            }
        }
    }
    
    func setDisplayName(_ user: FIRUser, displayname: String) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = displayname
        changeRequest.commitChanges(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func inputErrorAlert() {
        // Called upon signup error to let the user know signup didn't work.        
        let alert = UIAlertController(title: Constants.ErrorAlert.alertTitle, message: Constants.ErrorAlert.loginMissingMessage, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        if let vc = self.delagate as? UIViewController {
            vc.present(alert, animated: true, completion: nil)
        }
    }
}

extension AuthenticationProtocol {
    func didLogin(user: FIRUser?, error: Error?) {
    }
    func didSignup(user: FIRUser?, error: Error?) {
    }
}

//loging是否成功
