//
//  LoginViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2016/12/14.
//  Copyright © 2016年 iris shen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func SignIn(_ sender: UIButton) {
        
        if let email = emailTextField.text ,let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email,password: password, completion:{ (user,error) in
                if error == nil{
                    print("Email user authenticated with Firebase")
                   self.performSegue(withIdentifier: "CustomSegueToMap", sender: self)

                }else{
                    print("Unable to authenticate with Firebase using email")

                    
                }
            })
        }
    }
    
    
    @IBAction func register(_ sender: UIButton) {
        
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
