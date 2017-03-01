//
//  SendMessageHeaderView.swift
//  LocationTalk
//
//  Created by 鄭宇翔 on 2017/1/8.
//  Copyright © 2017年 鄭宇翔. All rights reserved.
//

import UIKit
protocol SendMessageHeaderViewDataSource: class {
    func photoInTheHeader() -> UIImage?
    func userNameInTheHeader() -> String
    func didLocationChangeBtnPressed()
}

//@IBDesignable
class SendMessageHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var timeView: UIView! {
        didSet {
            let maskPath = UIBezierPath.init(roundedRect: timeView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize.init(width: 8, height: 8))
            let maskLayer = CAShapeLayer.init()
            maskLayer.frame = timeView.bounds
            maskLayer.path = maskPath.cgPath
            
            timeView.layer.mask = maskLayer
        }
    }
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            let timeNow = Date.init()
            let formatter = DateFormatter.init()
            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy-MM-dd hh:mm", options: 0, locale: Locale.current)
            timeLabel.text = formatter.string(from: timeNow)
        }
    }
    @IBOutlet weak var locationLabel: UILabel!


 

    weak var delegate: SendMessageHeaderViewDataSource? {
        didSet {
            if delegate != nil {
                if let photo = self.delegate?.photoInTheHeader() {
                    userPhoto.image = photo
                }
                userLabel.text = self.delegate?.userNameInTheHeader()
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
        let nib = UINib(nibName: "SendMessageHeaderView", bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.contentView.frame = bounds
        self.addSubview(contentView)
    }
    
    @IBAction func locationChangeBtnPressed(_ sender: UIButton) {
        self.delegate?.didLocationChangeBtnPressed()
    }
    
}

extension SendMessageHeaderViewDataSource {
    func photoInTheHeader() -> UIImage? {
        return nil
    }
//    func didLocationChangeBtnPressed() {
//        
//        
//        
//        
//    }
}
