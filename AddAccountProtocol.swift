//
//  AddAccountProtocol.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/5.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import Foundation
import Firebase

protocol AddAccountProtocol {
    func emailToNode(_ email:String)->String
}



extension AddAccountProtocol{
    
    
    
    func emailToNode(_ email:String)->String
{
        var range: Range<String.Index>
        var node: String = "\(email)"
        
        while (node.contains("@")) {
            range = node.range(of: "@")!
            node = node.replacingCharacters(in: range, with: "")
        }
        
        while (node.contains(".")) {
            range = node.range(of: ".")!
            node = node.replacingCharacters(in: range, with: "")
        }
        
        
        return node
    }
    
 
    






}
