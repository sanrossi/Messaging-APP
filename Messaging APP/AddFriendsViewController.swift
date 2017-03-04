//
//  AddFriendsViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/2.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit

class AddFriendsViewController: UIViewController,AddFriendMainViewProtocol {

    
    @IBOutlet weak var addFreindByEmailView: UIView!
    @IBOutlet weak var addFriendbyQRCodeView: UIView!
    @IBOutlet weak var FrontButton: AddFriendMainView!{
        didSet{
        FrontButton.delegate = self
          }
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

// MARK: - didButtonPressed
extension AddFriendsViewController{
    func didQRCodeButtonPressed(){
        UIView.animate(withDuration: 0.5, animations: {
            self.addFreindByEmailView.isHidden = false
            self.addFriendbyQRCodeView.isHidden = true
        })
    }
    func didEmailButtonPressed(){
        UIView.animate(withDuration: 0.5, animations: {
            self.addFreindByEmailView.isHidden = true
            self.addFriendbyQRCodeView.isHidden = false
        })
    }
    func didreturnKeyButtonPressed(){
       dismiss(animated: true, completion: nil)
    }



}
