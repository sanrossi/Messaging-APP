//
//  MyQRCodeViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/3.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit

class MyQRCodeViewController: UIViewController {

    @IBOutlet weak var imageDisplayMyQRCode: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          imageDisplayMyQRCode.image = generaterQRCodeFromString(string: "eileen2224hotmailcom")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    func generaterQRCodeFromString(string :String)->UIImage?{
        let data = string.data(using: String.Encoding.ascii)
        let filter = CIFilter(name:"CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        let output = filter?.outputImage?.applying(transform)
        if(output != nil){
        
            return UIImage(ciImage:output!)
        }
        return nil
    
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
