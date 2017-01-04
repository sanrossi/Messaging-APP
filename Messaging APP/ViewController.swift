//
//  ViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2016/12/8.
//  Copyright © 2016年 iris shen. All rights reserved.
//

import UIKit
import FirebaseDatabase
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var ref: FIRDatabaseReference!
    var databaseHandle:FIRDatabaseHandle?
    var postData = [String]()
    // var postData = ["MESSAGE1","MESSAGE2","MESSAGE3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        //Set the firebase reference
        ref = FIRDatabase.database().reference()
        
        //Retrieve the posts and listen for changes
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
        
            
        //Try to convert the value of the data to a string
        let post = snapshot.value as? String
            if let actualPost = post{
            //Append the data to our postData array
            self.postData.append(actualPost)
            //Code to execute when a child is added under "Posts"
            //Take the value from the snapshot and added it to the postData array
            //Reload the tableview
                self.tableView.reloadData()
            
            
            }
        
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        cell?.textLabel?.text = postData[indexPath.row]
        return cell!
    }

    
    
    
    
    


}

