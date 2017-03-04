//
//  AddFriendbyEmailViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/9.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit



class AddFriendbyEmailViewController: UIViewController,UITextFieldDelegate,AddFriendbyEmailViewProtocol,FriendshipDelegate,AccountProtocol {
    
    var friendship: FriendshipProtocol!{
        didSet{
        friendship.delegate = self
        
        }
    
    }
    var resultUserNameLabel:String? = ""
    var resultEmailLabel:String? = ""
    var friendNode: String? = ""
    
    @IBOutlet weak var addFriendbyEmailView: AddFriendbyEmailView!{
        didSet {
          addFriendbyEmailView.delegate = self
         addFriendbyEmailView.addButtonPressed.isHidden = true
          
        }
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendship = Database().friendship()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("AddFriendbyEmailViewController deinit")
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


// MARK: - UITextFieldDelegate
//extension AddFriendbyEmailViewController  {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if let searchTarget = emailSearchText.text {
//            addFriend.searchFriends(searchTarget)
//            friendNode = self.emailToNode(searchTarget)
//        }
//        return true
//    }
//}

// MARK: - AddFriendbyEmailViewProtocol
extension AddFriendbyEmailViewController {
    func addFriendByEmailViewShouldReturn(_ textField: UITextField, email: String) {
        textField.resignFirstResponder()
        if !(email.isEmpty) {
            friendship.search(email)
        }
    }
    
    func addButtonDidPressed() {
        friendship.checkRelationshipBy(email: addFriendbyEmailView.emailSearchText
            .text!)
    }
    

  
}

// MARK: - FriendshipDelegate
extension AddFriendbyEmailViewController {
    
    func friendshipDidSearch(email: String?, username: String?) {
      
        if let email = email , let username = username{
        addFriendbyEmailView.resultUserNameLabel.text = username
        
            if email != MyProfile.shared.email{
            addFriendbyEmailView.resultEmailLabel.text = email
            addFriendbyEmailView.addButtonPressed.isHidden = true
            }
        
        } else {
       addFriendbyEmailView.resultUserNameLabel.text = "Not Found"
       addFriendbyEmailView.resultEmailLabel.text = "Not Found"
      
        
        }
    }

    func friendshipDidCheckRelationship(result: FriendState) {
        if result == .none{
          friendship.invite(email: addFriendbyEmailView.emailSearchText.text!, username: addFriendbyEmailView.resultUserNameLabel.text!)
           
        } else{
            self.errorAlert(title:Constants.ErrorAlert.alertTitle, message:"You are already friends or waiting to accept the invitation" , onViewController:self)
        }
    }

    
//    func didAddButtonPressed(){
//        friendship.checkRelationshipBy(email: addFriendbyEmailView.emailSearchText.text!)
//    
//    }
//
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    
    
    
    
}


