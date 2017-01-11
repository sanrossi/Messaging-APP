//
//  AddFriendbyEmailViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/9.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit



class AddFriendbyEmailViewController: UIViewController,UITextFieldDelegate,AddFriendDelegate,AddFriendbyEmailViewProtocol,AccountProtocol {
    
    var addFriend: AddFriend!
     var resultUserNameLabel:String? = ""
     var resultEmailLabel:String? = ""

    var friendNode: String? = ""
    
    @IBOutlet weak var addFriendbyEmailView: AddFriendbyEmailView!{
        didSet {
          addFriendbyEmailView.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addFriend = AddFriend.init()
        addFriend.delagate = self
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





// MARK: - AddFriendDelegate
extension AddFriendbyEmailViewController {
    
    func didSearchFriend(email: String?, username: String?) {
        if let email = email, let username = username {
            self.addFriendbyEmailView.resultUserNameLabel.text = username
            self.addFriendbyEmailView.resultEmailLabel.text = email
        } else {
             self.addFriendbyEmailView.resultUserNameLabel.text = "Not Found"
             self.addFriendbyEmailView.resultEmailLabel.text = "Not Found"
        
        }
    }
    
    func didCheckThisEmail(result: FriendState) {
        if result == .none {
            addFriend.invite(resultEmailLabel!, username: resultUserNameLabel!)
        } else {
            self.errorAlert(title: Constants.ErrorAlert.alertTitle, message: "You are already friends, or waiting to accept the invitation.", onViewController: self)
        }
    }
}

// MARK: - AddFriendbyEmailViewProtocol
extension AddFriendbyEmailViewController {
    
    func didSearButtonPressed(email:String?){
        if(email != ""){
        
            self.addFriend.searchFriends(email!)
 
            self.friendNode = self.emailToNode(email!)

        }
        
    
   }
    
}


