//
//  AddFriendAccountViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/17.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit

class AddFriendAccountViewController: UIViewController,AddFriendAccountViewProtocol,AccountProtocol,FriendshipDelegate{
    var userNameToDisplay:String = ""
    var emailToDisplay:String = ""
    var friendship: FriendshipProtocol!{
        didSet{
        friendship.delegate = self
        
        }
    
    
    }
    
    @IBOutlet weak var addFriendAccountView: AddFriendAccountView!{
        didSet {
            self.addFriendAccountView.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addFriendAccountView.resultUserNameLabel.text! = userNameToDisplay
        self.addFriendAccountView.resultEmailLabel.text! = emailToDisplay
        friendship = Database().friendship()
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
extension AddFriendAccountViewController{
    func didaddAccountButton(){
       friendship.checkRelationshipBy(email: addFriendAccountView.resultEmailLabel.text!)

    }
    func didreturnButton(){
    dismiss(animated: true, completion: nil)

    }
    
    

}



extension AddFriendAccountViewController{
    func friendshipDidCheckRelationship(result: FriendState) {
        if result == .none{
            friendship.invite(email: addFriendAccountView.resultEmailLabel.text!, username: addFriendAccountView.resultUserNameLabel.text!)
            
        } else{
            self.errorAlert(title:Constants.ErrorAlert.alertTitle, message:"You are already friends or waiting to accept the invitation" , onViewController:self)
        }
    }
   


    
    
    
    
    
    
}

