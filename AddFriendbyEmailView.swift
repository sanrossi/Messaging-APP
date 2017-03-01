//
//  AddFriendbyEmailView.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/9.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit

protocol  AddFriendbyEmailViewProtocol:
class{
    func didSearButtonPressed(email:String?)
    func didAddButtonPressed()
}



@IBDesignable
class AddFriendbyEmailView: UIView, UITextFieldDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var emailSearchText: UITextField!{
        didSet{
        
        emailSearchText.delegate=self
        
        
        }
    
    
    }
    
    
 
    @IBAction func addButton(_ sender: Any) {
        self.delegate?.didAddButtonPressed()
        
    }

    
    @IBOutlet weak var resultUserNameLabel: UILabel!
    
    @IBOutlet weak var resultEmailLabel: UILabel!
    
   
    weak var delegate: AddFriendbyEmailViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromNib()
    }
    
    deinit {
        print("AddFriendbyEmailView deinit")
    }
    
    private func initViewFromNib(){
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AddFriendbyEmailView", bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.contentView.frame = bounds
        self.addSubview(contentView)
      
    
    }
    
    
    @IBAction func searchFriendsButtonPressed(_ sender: Any) {
        let email = self.emailSearchText.text
         self.delegate?.didSearButtonPressed(email:email)
        
      
        
        
    }
    


    
    
    


}
