//
//  CreateAccountViewController.swift
//  LocationTalk
//
//  Created by 鄭宇翔 on 2016/12/27.
//  Copyright © 2016年 鄭宇翔. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, AccountProtocol, AuthDelegate, SignUpViewProtocol {
    
    @IBOutlet weak var signupView: SignUpView! {
        didSet {
            signupView.delegate = self
        }
    }
    var auth: AuthProtocol! {
        didSet {
           auth.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = FirebaseAuth.init()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("SignUpViewController deinit")
    }
}

// MARK: - SignUpViewProtocol
extension SignUpViewController {
    func didSignupButtonPressed(email: String?, password: String?, username: String?) {
        if let email = email, let password = password, let username = username {
            if (email != "" && password != "" && username != "") {
                auth.signUp(email:email, password: password, username: username)
             
            } else {
                auth.inputErrorAlert()
            }
        }
    }

    func didCancelButtonPressed(email: String?, password: String?, username: String?) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
       }
     }

// MARK: - AuthenticationProtocol
extension SignUpViewController {
    func didSignup(user: FIRUser?, error: Error?) {
        if let error = error {
            self.errorAlert(title: Constants.ErrorAlert.alertTitle, message: error.localizedDescription, onViewController: self)
        } else {
            MyProfile.shared.signIn(email: signupView.emailInput.text!, username: signupView.usernameInput.text!)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Constants.Segue.signupToMain,sender: nil)
            }
        }
    }
}
