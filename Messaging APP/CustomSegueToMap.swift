//
//  CustomSegueToMap.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2016/12/21.
//  Copyright © 2016年 iris shen. All rights reserved.
//

import UIKit

class CustomSegueToMap: UIStoryboardSegue {
    override func perform(){
    let sourceVc = self.source
    let destinationVc = self.destination
        sourceVc.view.addSubview(destinationVc.view)
    }
}
