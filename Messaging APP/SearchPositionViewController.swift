//
//  SearchPositionViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/2/19.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


protocol SearchPositionViewControllerDelegate: class {
    func didChangeLocation(newPlace: String)
}


class SearchPositionViewController: UIViewController,UISearchBarDelegate,GMSAutocompleteFetcherDelegate,SearchPositionViewProtocol{
    
    @IBOutlet weak var searchPositionView: SearchPositionView!{
        didSet{
            searchPositionView.delegate = self
        }
    }
    
    //var searchResultsController: SearchResultsController!
    var resultArray = [String]()
    var googleMapsView: GMSMapView!
    var gmsFetcher: GMSAutocompleteFetcher!
    var didSearchAddress = ""
    weak var delegate:SearchPositionViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.googleMapsView = GMSMapView(frame: self.searchPositionView.mapView.bounds)
        self.searchPositionView.mapView.addSubview(self.googleMapsView)
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        
        
    }
    
    
    
    
    //location map with longitude and latitude after search location on UIsearchBar
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        DispatchQueue.main.async { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            self.reverseGeocodeCoordinate(coordinate: position)
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            
            self.googleMapsView.camera = camera
            marker.title = "Address : \(title)"
            marker.map = self.googleMapsView
            
        }
    }
    
    
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction!{
                self.resultArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchPositionView.reloadDataWithArray(self.resultArray)
        
        print(resultArray)
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        
    }
    
    
    
    //    func textFieldShouldReturn(textField: UITextField) -> Bool {
    //        textField.resignFirstResponder()
    //        return true
    //    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                
                // 3
                let lines = address.lines! as [String]
                print(lines)
                for i in 0...lines.count-1 {
                    self.didSearchAddress = self.didSearchAddress + lines[i]
                }
                    print(self.didSearchAddress)
                
             
                // 4
                UIView.animate(withDuration: 0.25) {
                   // self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    
    
}




extension SearchPositionViewController{
    
    func didsearchWithAddress(searchText:String)
    {
        
        self.resultArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
        
    }
    func didreturnKeyButtonPressed(){
        
        dismiss(animated: true, completion: nil)
            self.delegate?.didChangeLocation(newPlace: self.didSearchAddress)
    }
    
    
}


