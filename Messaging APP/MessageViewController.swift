//
//  MessageViewController.swift
//  LocationTalk
//
//  Created by 鄭宇翔 on 2017/1/5.
//  Copyright © 2017年 鄭宇翔. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, SendMessageHeaderViewDataSource,SearchPositionViewControllerDelegate {

    @IBOutlet weak var headerView: SendMessageHeaderView! {
        didSet {
            headerView.delegate = self
        }
    }
    @IBOutlet weak var contentTextView: UITextView! {
        didSet {
            contentTextView.text = ""
        }
    }
    
    var friendSelected: FriendInfo!
    var didSearchAddress:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonPressed(_ sender: UIBarButtonItem) {
        let message = Message.init(email: friendSelected.email, username: friendSelected.username, time: headerView.timeLabel.text!, content: contentTextView.text)
        let messageUtility = MessageUtility.init()
        messageUtility.send(message: message)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Constants.Segue.MessageToChangPositionMap {
            let locationVC = segue.destination as! SearchPositionViewController
            locationVC.delegate = self
        }
    }






}

// MARK: - SendMessageHeaderViewDataSource
extension MessageViewController {
    func userNameInTheHeader() -> String {
        return friendSelected.username
    }
    
    func didLocationChangeBtnPressed(){
   
        performSegue(withIdentifier: Constants.Segue.MessageToChangPositionMap
            , sender: nil)
    }
}




extension MessageViewController {

   
    func didChangeLocation(newPlace: String){
        self.didSearchAddress = newPlace
        
        self.headerView.locationLabel.text = didSearchAddress
    
    }



}
