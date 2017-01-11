//
//  MyQRCodeView.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/11.
//  Copyright © 2017年 iris shen. All rights reserved.
//
protocol MyQRCodeProtocol:
class{
}

import UIKit

@IBDesignable
class MyQRCodeView: UIView{
    weak var delegate: MyQRCodeProtocol?
   
  
    @IBOutlet var MyQRcodeView: UIView!
    
    @IBOutlet weak var MyQRimg: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromNib()
    }
    
    deinit {
        print("MyQRCodeView deinit")
    }
    
    private func initViewFromNib(){
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName:"MyQRCodeView", bundle: bundle)
        self.MyQRcodeView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.MyQRcodeView.frame = bounds
        self.addSubview(MyQRcodeView)
        
        
    }
 
    
    
}
