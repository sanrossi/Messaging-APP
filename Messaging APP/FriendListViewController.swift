//
//  FriendListViewController.swift
//  LocationTalk
//
//  Created by 鄭宇翔 on 2016/12/27.
//  Copyright © 2016年 鄭宇翔. All rights reserved.
//

import UIKit
import Firebase

class FriendListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FriendListDelegate {
    
    @IBOutlet weak var friendListTable: UITableView! {
        didSet {
            friendListTable.dataSource = self
            friendListTable.delegate = self
        }
    }
    var list: FriendList! {
        didSet {
            list.delagate = self
        }
    }
    var friendArray: [FriendInfo] = []
    var beIvitedArray: [FriendInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        list = FriendList.init() 
        list.getFriendList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("FriendListViewController deinit")
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        
        // Pass the selected object to the new view controller.
        if (segue.identifier == Constants.Segue.listToAccept) {
            let invitationVC = segue.destination as! AddFriendbyEmailViewController
        //invitationVC.beIvitedArray = self.beIvitedArray
        }
    }
}

// MARK: - FriendListDelegate
extension FriendListViewController {
    func didGetFriendList(friends friendArray: [FriendInfo], beInvited beIvitedArray: [FriendInfo]) {
        self.friendArray = friendArray
        self.beIvitedArray = beIvitedArray
        self.friendListTable.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension FriendListViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.beIvitedArray.count != 0 {
                return 1
            } else {
                return 0
            }
        }
        return self.friendArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.friendList, for: indexPath)
        
        if (self.beIvitedArray.count != 0 && indexPath.section == 0) {
            cell.textLabel?.text = "有\(self.beIvitedArray.count)個朋友邀請"
            return cell
        }
        
        let friend = friendArray[indexPath.row]
        cell.textLabel?.text = friend.username
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0 && beIvitedArray.count != 0) {
            return Constants.Section.beComfired
        }
        if section == 1 {
            return Constants.Section.friendList
        }
        return nil
    }
}

// MARK: - UITableViewDelegate
extension FriendListViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.beIvitedArray.count != 0 && indexPath.row == 0) {
            performSegue(withIdentifier: Constants.Segue.listToAccept, sender: nil)
        } else {
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
