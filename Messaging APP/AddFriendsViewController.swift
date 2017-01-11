//
//  AddFriendsViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/2.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit

class AddFriendsViewController: UIViewController {

    
    @IBOutlet weak var addFreindByEmailView: UIView!
   
   
    
    @IBOutlet weak var addFriendbyQRCodeView: UIView!
  
    
    @IBAction func addfriendsbyemail(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.addFreindByEmailView.alpha = 1
            self.addFriendbyQRCodeView.isHidden = true
            
        })
     
        
        
    }
    
    @IBAction func addfriendsbyQRCode(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            
           self.addFreindByEmailView.isHidden = true
            self.addFriendbyQRCodeView.alpha = 1
        })
        
        
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
