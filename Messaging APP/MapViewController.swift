//
//  MapViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2016/12/20.
//  Copyright © 2016年 iris shen. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 25.0236277,longitude:121.4666112, zoom:6)
        let mapView = GMSMapView.map(withFrame: self.view.bounds, camera:camera)
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Hello World"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        
        self.view = mapView
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
