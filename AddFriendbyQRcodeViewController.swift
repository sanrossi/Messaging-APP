//
//  AddFriendbyQRcodeViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/11.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit
import AVFoundation
class AddFriendbyQRcodeViewController: UIViewController ,AddFriendbyQRCodeViewProtocol{
    
  
    @IBOutlet weak var QRcodeView: AddFriendByQRCodeView!{
        didSet {
     QRcodeView.delegate = self
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.QRcodeView.QRcodeScannerView.session = QRcodeView.session
        //將 session 传递给 view，因此它能显示视图
        self.QRcodeView.QRcodeScannerView.videoPreviewLayer.videoGravity = AVLayerVideoGravityResize
        //表示所取得的影像必須以等比例的方式縮放來填滿我們所指定的大小（CGRect rect）
        
        
        
        
        
        
        //MARK:AVCaptureDevice authorized
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio){
        case .authorized:
            break
            
        case .notDetermined:
             QRcodeView.sessionQueue.suspend()
            //sessionQueue 終止
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: {[unowned self]
                granted in
                if !granted{
                    self.QRcodeView.setupResult = .notAuthorized
                }
                self.QRcodeView.sessionQueue.resume()// 一旦请求通过，重新开启 queue
            })
            
        default:
            QRcodeView.setupResult = .notAuthorized
        }
        
        
        QRcodeView.sessionQueue.async {[unowned self]in
            switch self.QRcodeView.availableCamera{
                
            case .Both,.Back:
                self.QRcodeView.configureSession(cameraType: .back)
                break
                
            case .Front:
                self.QRcodeView.configureSession(cameraType: .front)
                break
                
            default:
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.QRcodeView.sessionQueue.async {
            switch self.QRcodeView.setupResult {
            case .success:
               self.QRcodeView.session.startRunning()
                self.QRcodeView.isSessionRunning = self.QRcodeView.session.isRunning
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
        self.QRcodeView.sessionQueue.async { [unowned self] in
            self.QRcodeView.session.stopRunning()
            self.QRcodeView.isSessionRunning = self.QRcodeView.session.isRunning
        }
        super.viewWillDisappear(animated)
    }

    
    
    


    @IBOutlet weak var QRcodeScannerView: AddFriendByQRCodeView!{
        didSet{
         QRcodeScannerView.delegate = self
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        if let videoPreviewLayerConnection = self.QRcodeView.QRcodeScannerView.videoPreviewLayer.connection{
            
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func didfindMyQRCodeButtonPressed(){
    
     performSegue(withIdentifier: Constants.Segue.FindFriendsQRCodeToMyQRCode, sender: nil)
    
    }

}
