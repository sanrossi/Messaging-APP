//
//  AddFriendbyQRCodeViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/2.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices


class AddFriendbyQRCodeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate{
 
   
    @IBOutlet weak var QRcodeScannerView: QRcodeScannerView!
    //MARK:Session management
    private enum SessionSetupResult{
        case success
        case notAuthorized
        case configurationFailed
    }
    private let session = AVCaptureSession()
    
    private var isSessionRunning = false
    private var sessionQueue = DispatchQueue(label:"session queue",attributes:[],target:nil)
    
    private var setupResult:SessionSetupResult = .success
 
   
   
   
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
    
    var videoOutput = AVCaptureVideoDataOutput()
    
    let captureMetadataOutput = AVCaptureMetadataOutput()
    
    
    //MARK:Handling Camera Source is available or not
    enum CameraTypes {
        case Front,Back,Both,None
    }
    lazy var availableCamera :CameraTypes = {
        
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) else{
        return .None
         }
        
        if devices.count == 2{
        return .Both
        }else if (devices.count == 1){
         let device = (devices.first as! AVCaptureDevice)
            return device.position == .front ? .Front : .Back
        }
        return .None
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
      QRcodeScannerView.session = session
      QRcodeScannerView.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
      
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio){
        case .authorized:
            break
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: {[unowned self]
            granted in
                if !granted{
                self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            
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
            let videoDevice = AddFriendbyQRCodeViewController.deviceWithMediaType(AVMediaTypeVideo, preferrinPosition: cameraType)
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            //Add input
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: Int(kCVPixelFormatType_32BGRA)]
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
        if let devices = AVCaptureDevice.devices(withMediaType: mediaType) as?[AVCaptureDevice]{
            return devices.filter({$0.position == position}).first
        }
        return nil
    }
    //MARK:Set up for orientation screen
    override var shouldAutorotate: Bool{
    return true
    }
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
        case .portrait: return AVCaptureVideoOrientation.portrait
        case .portraitUpsideDown:return AVCaptureVideoOrientation.portraitUpsideDown
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
