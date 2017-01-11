//
//  SignUpView.swift
//  LocationTalk
//
//  Created by 鄭宇翔 on 2017/1/5.
//  Copyright © 2017年 鄭宇翔. All rights reserved.
//

import UIKit
protocol SignUpViewProtocol: class {
    func didSignupButtonPressed(email: String?, password: String?, username: String?)
    func didCancelButtonPressed(email: String?, password: String?, username: String?)
}

@IBDesignable
class SignUpView: UIView, UITextFieldDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var emailInput: UITextField! {
        didSet {
            emailInput.delegate = self
        }
    }
    @IBOutlet weak var passwordInput: UITextField! {
        didSet {
            passwordInput.delegate = self
        }
    }
    @IBOutlet weak var usernameInput: UITextField! {
        didSet {
            usernameInput.delegate = self
        }
    }
    weak var delegate: SignUpViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromNib()
    }
    
    deinit {
        print("SignUpView deinit")
    }
    
    private func initViewFromNib(){
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SignUpView", bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.contentView.frame = bounds
        self.addSubview(contentView)
    }
    
    // MARK: - @IBAction
    @IBAction fileprivate func signupButtonPressed(_ sender: UIButton) {
        let email = self.emailInput.text
        let password = self.passwordInput.text
        let username = self.usernameInput.text
        
        self.delegate?.didSignupButtonPressed(email: email, password: password, username: username)
    }
    
    @IBAction fileprivate func cancelButtonPressed(_ sender: UIButton) {
        let email = self.emailInput.text
        let password = self.passwordInput.text
        let username = self.usernameInput.text
        
        self.delegate?.didCancelButtonPressed(email: email, password: password, username: username)
    }
}

// MARK: - UITextFieldDelegate
extension SignUpView {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailInput.resignFirstResponder()
        passwordInput.resignFirstResponder()
        usernameInput.resignFirstResponder()
        return true
    }
}
