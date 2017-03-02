//
//  LoginViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2016/12/14.
//  Copyright © 2016年 iris shen. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, AccountProtocol, AuthDelegate, LoginViewProtocol {

    @IBOutlet weak var loginView: LoginView! {
        didSet {
            loginView.delegate = self
        }
    }
    var auth: AuthProtocol! {
        didSet {
            auth.delegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Database().auth()
        if let user = auth.currentUser() {
            MyProfile.shared.signIn(email:user.email , username: user.username)
            DispatchQueue.main.async {
                self.shouldPerformSegue(withIdentifier: Constants.Segue.loginToMain, sender: nil)
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("LoginViewController deinit")
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
    }
}

// MARK: - LoginViewProtocol
extension LoginViewController {
    func didLoginButtonPressed(email: String?, password: String?) {
        if let email = email, let password = password {
            if (email != "" && password != "") {
                auth.login(email: email, password: password)
            } else {
                auth.inputErrorAlert()
            }
        }
    }
    
    func didSignUpButtonPressed(email: String?, password: String?) {
        performSegue(withIdentifier: Constants.Segue.loginToSignUp, sender: nil)
    }
}


// MARK: - AuthDelegate
extension LoginViewController {
    func authDidLogin(error: Error?) {
        if let error = error {
        self.errorAlert(title: Constants.ErrorAlert.alertTitle, message: error.localizedDescription, onViewController: self)
        }else{
            MyProfile.shared.signIn(email: loginView.emailInput.text!, username: auth.currentUser()!.username)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Constants.Segue.loginToMain, sender: nil)
        
        
        }
    }
   

}
}
