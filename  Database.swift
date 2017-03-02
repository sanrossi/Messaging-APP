//
//   Database.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/3/1.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit

class Database: NSObject {
    func auth() -> AuthProtocol! {
        switch Constants.database {
        case "Firebase":
            return FirebaseAuth.init()
        default:
            return nil
        }
    }
    func friendship() ->FriendshipProtocol!{
        switch Constants.database{
          case "Firebase":
            return FirebaseFriend.init()
        default:
            return nil
        
        
        }
    }

    
    
    
    }

