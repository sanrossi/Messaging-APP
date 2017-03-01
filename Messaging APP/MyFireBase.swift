//
//  MyFireBase.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/3/1.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import Foundation
import Firebase

class MyFirebase{
    var ref:FIRDatabaseReference!
    init(){
    self.ref = FIRDatabase.database().reference()
    
    }


}
