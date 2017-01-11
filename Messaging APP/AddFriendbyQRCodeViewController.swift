//
//  AddFriendbyQRCodeViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/2.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit
import AVFoundation



class AddFriendbyQRCodeViewController2: UIViewController,AVCaptureMetadataOutputObjectsDelegate{
 
   
    @IBOutlet weak var QRcodeScannerView: QRcodeScannerView!
    //MARK:Session management
    private enum SessionSetupResult{
        case success
        case notAuthorized
        case configurationFailed
    }
    private let session = AVCaptureSession()
   //協調輸入輸出的中心，我們需要創建Session
    
    private var isSessionRunning = false
    //輸入輸出的資料流一開始設定為false
    private var sessionQueue = DispatchQueue(label:"session queue",attributes:[],target:nil)
    
    private var setupResult:SessionSetupResult = .success
    //SessionSetupResult 預設success
 
   
   
   
//    @IBAction func focusAndExposeTap(_ sender: UITapGestureRecognizer) {
//        let devicePoint = self.QRcodeScannerView.videoPreviewLayer.captureDevicePointOfInterest(for: sender.location(in: sender.view))
//        focus(with: .autoFocus, exposureMode: .autoExpose, at: devicePoint, monitorSubjectAreaChange: true)
//        
//        
//   
//        
//        
//        
//    }
  

    var videoDeviceInput :AVCaptureDeviceInput!
    //影像輸入的變數
    
    var videoOutput = AVCaptureVideoDataOutput()
    
    let captureMetadataOutput = AVCaptureMetadataOutput()
    //启用检测人脸和二维码
    
    //MARK:Handling Camera Source is available or not
    enum CameraTypes {
        case Front,Back,Both,None
    }
    
    lazy var availableCamera :CameraTypes = {
        // 3:根据当前镜头创建新的device
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) else{
        return .None
         }
        
        if devices.count == 2{
        return .Both
        }else if (devices.count == 1){
         let device = (devices.first as! AVCaptureDevice)
            return device.position == .front ? .Front : .Back
              // 2:获取当前显示的镜头
        }
        return .None
    }()
    
    
    //现在我们需要一个相机设备输入。在大多数 iPhone 和 iPad 中，我们可以选择后置摄像头或前置摄像头 -- 又称自拍相机 (selfie camera) -- 之一。那么我们必须先遍历所有能提供视频数据的设备 (麦克风也属于 AVCaptureDevice，因此略过不谈)，并检查 position 属性：
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
     
       QRcodeScannerView.session = session
       //將 session 传递给 view，因此它能显示视图
        QRcodeScannerView.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        //表示所取得的影像必須以等比例的方式縮放來填滿我們所指定的大小（CGRect rect）

        
        
        
        
        
//MARK:AVCaptureDevice authorized
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio){
        case .authorized:
            break
            
        case .notDetermined:
            sessionQueue.suspend()
            //sessionQueue 終止
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: {[unowned self]
            granted in
                if !granted{
                self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()// 一旦请求通过，重新开启 queue
            })
            
        default:
            setupResult = .notAuthorized
        }
        
        
        sessionQueue.async {[unowned self]in
            switch self.availableCamera{
            
            case .Both,.Back:
                self.configureSession(cameraType: .back)
                break
            
            case .Front:
                self.configureSession(cameraType: .front)
                break
            
            default:
                break
            }
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                self.session.startRunning()
                self.isSessionRunning = self.session.isRunning
            case .notAuthorized:
                DispatchQueue.main.async { [unowned self] in
                    let message = NSLocalizedString("DemoCamera doesn't have permission to use the camera, please change privacy settings", comment: "Alert message when the user has denied access to the camera")
                    let alertController = UIAlertController(title: "DemoCamera", message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .`default`, handler: { action in
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                        }
                        
                    }))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            case .configurationFailed:
                DispatchQueue.main.async { [unowned self] in
                    let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
                    let alertController = UIAlertController(title: "DemoCamera", message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        sessionQueue.async { [unowned self] in
            self.session.stopRunning()
            self.isSessionRunning = self.session.isRunning
        }
        super.viewWillDisappear(animated)
    }
    
    
    
    
    //MARK:Global Functions
    private func configureSession(cameraType: AVCaptureDevicePosition) {
        if setupResult != .success {
            return
        }
        
        session.beginConfiguration()
        
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        
        //Add video input
        do {
            let videoDevice = AddFriendbyQRCodeViewController2.deviceWithMediaType(AVMediaTypeVideo, preferrinPosition: cameraType)
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            //Add input
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: Int(kCVPixelFormatType_32BGRA)]//初始化摄像头的时候，设置采集格式是rgb的
                videoOutput.alwaysDiscardsLateVideoFrames = true
                //需要注意的是，当一个新的视频图像帧被采集后，它会被传送到output，调用这里设置的delegate。所有的delegate函数会在这个queue中调用。如果队列被阻塞，新的图像帧到达后会被自动丢弃(默认alwaysDiscardsLateVideoFrames = YES)。这允许app处理当前的图像帧，不需要去管理不断增加的内存，因为处理速度跟不上采集的速度，等待处理的图像帧会占用内存，并且不断增大。必须使用同步队列处理图像帧，保证帧的序列是顺序的。
                
            } else {
                print("Could not add video device input to the session") // 无法将视频设备输入到会话中
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
    //MARK:Set up for orientation screen允許設備旋轉
    override var shouldAutorotate: Bool{
    return true
    }
    
//支持的方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
    return .all
    }
    
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let videoPreviewLayerConnection = self.QRcodeScannerView.videoPreviewLayer.connection{
            
            let deviceOrientation = UIDevice.current.orientation
            guard let newVideoOrientation = self.videoOrientationFor(deviceOrientation),deviceOrientation.isPortrait || deviceOrientation.isLandscape else{
            return
            }
           videoPreviewLayerConnection.videoOrientation = newVideoOrientation
        }
    }
    
   
    
    
    private func videoOrientationFor(_ deviceOrientation:UIDeviceOrientation)->AVCaptureVideoOrientation?{
        switch deviceOrientation{
        case .portrait: return AVCaptureVideoOrientation.portrait //直向
            
        case .portraitUpsideDown:return AVCaptureVideoOrientation.portraitUpsideDown//上下顛倒
        
        case .landscapeLeft:return AVCaptureVideoOrientation.landscapeLeft
            
        case .landscapeRight:return AVCaptureVideoOrientation.landscapeRight
            
        default:return nil
        
        
        
        }

        
    }
    
        
        
        
        
        
        
        


        
        func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
            self.session.stopRunning()
            if let metadataObject = metadataObjects.first {
                let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                print(readableObject.stringValue)
            }
        }
        
        

    
    
    
    
    
    
//    private func focus(with focusMode: AVCaptureFocusMode, exposureMode: AVCaptureExposureMode, at devicePoint: CGPoint, monitorSubjectAreaChange: Bool) {
//        sessionQueue.async { [unowned self] in
//            if let device = self.videoDeviceInput.device {
//                do {
//                    try device.lockForConfiguration()
//                    
//                    if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(focusMode) {
//                        device.focusPointOfInterest = devicePoint
//                        device.focusMode = focusMode
//                    }
//                    
//                    if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode) {
//                        device.exposurePointOfInterest = devicePoint
//                        device.exposureMode = exposureMode
//                    }
//                    device.isSubjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange
//                    device.unlockForConfiguration()
//                } catch {
//                    print("Could not lock device for configuration: \(error.localizedDescription)")
//                }
//            }
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
