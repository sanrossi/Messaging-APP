//
//  MyPlaceService.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/3/1.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import Foundation
import GooglePlaces
protocol MyPlaceServiceDelegate {
    
    func get(currentPlace: GMSPlace?, error: Error?)
     func getAutoComplete(results: [GMSAutocompletePrediction]?, error: Error?)
}
class MyPlaceService{





}
