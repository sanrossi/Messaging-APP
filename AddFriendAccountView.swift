//
//  AddFriendAccountView.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/2/14.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit
protocol AddFriendAccountViewProtocol:
class{
   func didaddAccountButton()
}
@IBDesignable
class AddFriendAccountView: UIView, UITextFieldDelegate {
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var resultUserNameLabel: UILabel!
    
    @IBOutlet weak var resultEmailLabel: UILabel!
    
    @IBAction func addAccountButton(_ sender: Any) {
        self.delegate?.didaddAccountButton()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
    }
    
    weak var delegate: AddFriendAccountViewProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromNib()
    }
    
    deinit {
        print("AddFriendAccountView deinit")
    }
    
    private func initViewFromNib(){
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AddFriendAccountView", bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.contentView.frame = bounds
        self.addSubview(contentView)
        
        
    }
    
    
    
    
}

