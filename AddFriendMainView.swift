//
//  AddFriendMainView.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/12.
//  Copyright © 2017年 iris shen. All rights reserved.
//

protocol AddFriendMainViewProtocol:
class{
    func didQRCodeButtonPressed()
    func didEmailButtonPressed()
    func didreturnKeyButtonPressed()
}

import UIKit

@IBDesignable
class AddFriendMainView: UIView{
    weak var delegate: AddFriendMainViewProtocol?
    
    @IBOutlet var contentView: UIView!
    
 
    @IBOutlet weak var EmailButtonStyle: UIButton!
    
    @IBAction func EmailButton(_ sender: Any) {
        self.delegate?.didEmailButtonPressed()
    }
    @IBAction func returnKeyButton(_ sender: Any) {
       self.delegate?.didreturnKeyButtonPressed()
        
    }
    @IBAction func QRCodeButton(_ sender: Any) {
       self.delegate?.didQRCodeButtonPressed()
    }
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromNib()
    }
    
    deinit {
        print("AddFriendMainView deinit")
    }
    
    private func initViewFromNib(){
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName:"AddFriendMainView", bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.contentView.frame = bounds
        self.addSubview(contentView)
        
        
    
       
        
//      self.EmailButtonStyle.setImage(UIImage(named:"Find01.png"), for: UIControlState.normal)
//          self.EmailButtonStyle.setTitle("Email", for: UIControlState.normal)
   //     self.EmailButtonStyle.imageView?.contentMode = .scaleAspectFill
//        
//          let imageSize : CGSize! = EmailButtonStyle.imageView?.bounds.size
//         let titleSize :CGSize! = EmailButtonStyle.titleLabel?.bounds.size
//        //print(imageSize)
//          let interval:CGFloat = 1.0
//          EmailButtonStyle.imageEdgeInsets = UIEdgeInsetsMake(-5, -5, (titleSize.height + interval), -(titleSize.width + interval))
//          EmailButtonStyle.titleEdgeInsets = UIEdgeInsetsMake((imageSize.height + interval)/2, -(imageSize.width + interval)/2, 0, 0)
        
        
        
      
    }
    
    
    
}

