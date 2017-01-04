//
//  ComposeViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2016/12/8.
//  Copyright © 2016年 iris shen. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ComposeViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    
    
    var ref: FIRDatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
         ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }
    @IBAction func addPost(_ sender: Any) {
        
        
        //TODO:Post the data to firebase
        ref?.child("Posts").childByAutoId().setValue("Hello Firebase")
        //Dissmiss the popover
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func cancelPost(_ sender: Any) {
       presentingViewController?.dismiss(animated: true, completion: nil)
        
        
        
        
        
        
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
