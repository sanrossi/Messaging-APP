//
//  AddFriendByQRCodeView.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/11.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit
import AVFoundation

protocol AddFriendbyQRCodeViewProtocol:
class{
    func didfindMyQRCodeButtonPressed()
    func sendbackAccount(friendAccount:String)
}




//@IBDesignable
class AddFriendByQRCodeView: UIView ,AVCaptureMetadataOutputObjectsDelegate{
    weak var delegate: AddFriendbyQRCodeViewProtocol?
    
    
    
    
    @IBAction func findMyQRCodeButton(_ sender: Any) {
        
        self.delegate?.didfindMyQRCodeButtonPressed()
    }
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var QRcodeScannerView: QRcodeScannerView!

    
    
    enum SessionSetupResult{
        case success
        case notAuthorized
        case configurationFailed
    }
    
    
    let session = AVCaptureSession()
    //負責協調資料的輸入輸出，我們需要創建Session
    
    var isSessionRunning = false
    //輸入輸出的資料流一開始設定為false
    
    
    var setupResult:SessionSetupResult = .success
    //SessionSetupResult 預設success
    
    var sessionQueue = DispatchQueue(label:"session queue",attributes:[],target:nil)
    

    var videoDeviceInput :AVCaptureDeviceInput!
    //影像輸入
    
    var videoOutput = AVCaptureVideoDataOutput()
    //影像輸出
    let captureMetadataOutput = AVCaptureMetadataOutput()
    //啟用二維碼
    
    
    //MARK:Handling Camera Source is available or not
    enum CameraTypes {
        case Front,Back,Both,None
    }
    
    
    
    lazy var availableCamera :CameraTypes = {
        // 根據當前的鏡頭創立一個變數device
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) else{
            return .None
        }
        
        if devices.count == 2{
            return .Both
        }else if (devices.count == 1){
            let device = (devices.first as! AVCaptureDevice)
            return device.position == .front ? .Front : .Back
            // 獲取當前正在使用的鏡頭
        }
        return .None
    }()
    
    
    //现在我们需要一个相机设备输入。在大多数 iPhone 和 iPad 中，我们可以选择后置摄像头或前置摄像头 -- 又称自拍相机 (selfie camera) -- 之一。那么我们必须先遍历所有能提供视频数据的设备 (麦克风也属于 AVCaptureDevice，因此略过不谈)，并检查 position 属性：
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromNib()
    }
    
    deinit {
        print("AddFriendByQRCodeView deinit")
    }
    
    
    
    private func initViewFromNib(){
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AddFriendByQRCodeView", bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.contentView.frame = bounds
        self.addSubview(contentView)
        
        
    }
    
    
    
    
    //MARK:Global Functions
    func configureSession(cameraType: AVCaptureDevicePosition) {
        if setupResult != .success {
            return
        }
        //告訴session要增加一系列的配置操作
        session.beginConfiguration()
        
        session.sessionPreset = AVCaptureSessionPresetHigh
        //Highest recording quality.  This varies per device.
        
        
        //Add video input
        do {
            // 創建一個攝影鏡頭設備
            let videoDevice = AddFriendByQRCodeView.deviceWithMediaType(AVMediaTypeVideo, preferrinPosition: cameraType)
            // 創建一個設備表示開始能捕獲數據
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            //添加輸入到session中，並存起來
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                
                
                //影響輸出的格式
                videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: Int(kCVPixelFormatType_32BGRA)]
                
                //需要注意的是，当一个新的视频图像帧被采集后，它会被传送到output，调用这里设置的delegate。所有的delegate函数会在这个queue中调用。如果队列被阻塞，新的图像帧到达后会被自动丢弃(默认alwaysDiscardsLateVideoFrames = YES)。这允许app处理当前的图像帧，不需要去管理不断增加的内存，因为处理速度跟不上采集的速度，等待处理的图像帧会占用内存，并且不断增大。必须使用同步队列处理图像帧，保证帧的序列是顺序的。
                videoOutput.alwaysDiscardsLateVideoFrames = true
                
                
            } else {
                print("Could not add video device input to the session")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
        } catch {
            print("Could not create video device input \(error.localizedDescription)")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        
        if session.canAddOutput(videoOutput) {
            // 初始化 AVCaptureMetadataOutput 作為 session 的输出
            session.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue(label: "QRCode", attributes: .concurrent))
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            session.addOutput(videoOutput)
            
            
        } else {
            print("Could not add photo output to the session")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        session.commitConfiguration()
    }
    

    private class func deviceWithMediaType(_ mediaType:String,preferrinPosition position:AVCaptureDevicePosition) ->AVCaptureDevice?{
        //獲取前鏡頭
        if let devices = AVCaptureDevice.devices(withMediaType: mediaType) as?[AVCaptureDevice]{
            return devices.filter({$0.position == position}).first
            // 获取前置摄像头
        }
        return nil
    }

    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        //停止session
     //   self.session.stopRunning()
        //開啟震動
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.delegate?.sendbackAccount(friendAccount: readableObject.stringValue)
  
            print(readableObject.stringValue)
        }
    }
    
    
    func prepareForViewDidLoad(_ status: Bool) {
        
    }
    
    
    
}


