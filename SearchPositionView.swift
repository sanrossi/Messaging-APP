//
//  SearchPositionView.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/2/19.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
protocol SearchPositionViewProtocol: class {
    func didsearchWithAddress(searchText:String)
    func locateWithLongitude(_ lon:Double, andLatitude lat:Double, andTitle title: String)
    func didreturnKeyButtonPressed() 
    
}

@IBDesignable

class SearchPositionView: UIView,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate
{
    
    
    @IBOutlet var contentView: UIView!
    
    
    
    @IBOutlet weak var mapView: UIView!
    
    
    
    
    @IBOutlet weak var searchWithAddress: UISearchBar!{
        didSet{
            searchWithAddress.delegate = self
        }
    }
    
    @IBAction func returnKeyButton(_ sender: Any) {
      self.delegate?.didreturnKeyButtonPressed()
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.7)
            tableView.isHidden = true
        }
    }
    
    weak var delegate: SearchPositionViewProtocol?
    
    
    
    var searchResults: [String] = []{
        didSet{
            if searchResults.count == 0{
                tableView.isHidden = true
            }else{
                tableView.isHidden = false
            }
        }
        
    }
    
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViewFromNib()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViewFromNib()
    }
    
    
    private func initViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SearchPositionView", bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.contentView.frame = bounds
        self.addSubview(contentView)
        self.searchResults = Array()
        
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "SearchResultCell")
        cell.textLabel?.text = self.searchResults[indexPath.row]
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        // 1
        
        //self.dismiss(animated: true, completion: nil)
        // 2
        tableView.isHidden = true
        let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(self.searchResults[indexPath.row])&sensor=false".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlpath!)
        // print(url!)
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            // 3
            
            do {
                if data != nil{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    
                    let lat =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lat")) as! Double
                    
                    let lon =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lng")) as! Double
                    // 4
                    self.delegate?.locateWithLongitude(lon, andLatitude: lat, andTitle: self.searchResults[indexPath.row])
                    
                }
                
            }catch {
                print("Error")
            }
        }
        // 5
        task.resume()
    }
    
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.characters.count == 0){
            tableView.isHidden = true
            
        }else{
            self.delegate?.didsearchWithAddress(searchText: searchText)
        }
        
    }
    
    
    
    fileprivate func setScreenToDefault(){
        searchWithAddress.text = " "
        searchWithAddress.setShowsCancelButton(false, animated: true)
        searchWithAddress.resignFirstResponder()
        tableView.isHidden = true
        
    }
    
    
    func reloadDataWithArray(_ array:[String]){
        self.searchResults = array
        self.tableView.reloadData()
        
        
    }
    
}
