//
//  AddFriendAccountViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/17.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit

class AddFriendAccountViewController: UIViewController,AddFriendAccountViewProtocol{
    var userNameToDisplay:String = ""
    var emailToDisplay:String = ""
     var addFriend: AddFriend!
    
    @IBOutlet weak var addFriendAccountView: AddFriendAccountView!{
        didSet {
            self.addFriendAccountView.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addFriendAccountView.resultUserNameLabel.text! = userNameToDisplay
        self.addFriendAccountView.resultEmailLabel.text! = emailToDisplay
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
        addFriend.check(addFriendAccountView.resultEmailLabel.text!)

    }

}
