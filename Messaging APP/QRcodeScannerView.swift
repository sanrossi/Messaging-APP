//
//  QRcodeScannerView.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/3.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit
import AVFoundation
class QRcodeScannerView: UIView {
    var videoPreviewLayer:AVCaptureVideoPreviewLayer{
     return layer as! AVCaptureVideoPreviewLayer
    }
    //AVCaptureSession 对象用来处理从摄像头和麦克风输入的流
    var session:AVCaptureSession?{
        get{
     return videoPreviewLayer.session
        }
        set{
        videoPreviewLayer.session = newValue
        }
    }
    
    override class var layerClass:AnyClass{
        return AVCaptureVideoPreviewLayer.self
    
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
