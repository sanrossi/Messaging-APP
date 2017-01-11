//
//  NewRegisterViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2016/12/15.
//  Copyright © 2016年 iris shen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class NewRegisterViewController: UIViewController ,AccountProtocol {
    enum Friendstate:String {
        case notfriend = "notfriend"
        case invited = "invited"
        case beinvited = "beinvited"
        case friend = "friend"
        
    }
    
    @IBOutlet weak var userName: UITextField!

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
     var ref: FIRDatabaseReference!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       ref = FIRDatabase.database().reference()
       
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func registerCheckButton(_ sender: UIButton){
        
       
      // var databaseHandle:FIRDatabaseHandle?
    if let email = email.text, let password = passWord.text, let username = userName.text {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user,error) in
            if error != nil{
              
                print("Unable to authenticate with Firebase using email")
                self.displayUIAlter(banner: "你已註冊過了！！！")
                            }else{
               
                print("Successfully authenticated with Firebase")
                //excluding the special word
                var emailID = self.email.text!
                
                emailID = emailID.replacingOccurrences(of:"@", with:"")
                emailID = emailID.replacingOccurrences(of:".", with:"")
                
                // Set the firebase reference
                
                
                self.ref.child(emailID).child("username:").setValue(username)
                self.ref.child(emailID).child("email:").setValue(email)
                self.ref.child(emailID).child("password").setValue(password)
                //ref?.child(emailID).child("friend").setValue("")
                self.ref.child(emailID).child("SendMessage:").setValue("iris")
                self.ref.child(emailID).child("ReceiveMessage:").setValue("iris")
                self.displayUIAlter(banner: "你已完成註冊")
                

            }
        })
        
        }
        }
    
    
        
    
    func displayUIAlter(banner:String){
        
        let alertController = UIAlertController(title:banner,message: nil, preferredStyle: .alert)
        //present alert viewcontroller
        self.present(alertController, animated: true, completion: nil)
        //dimiss aler viewController after second
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    
    
    
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
