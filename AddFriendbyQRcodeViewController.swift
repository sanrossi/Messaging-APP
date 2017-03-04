//
//  AddFriendbyQRcodeViewController.swift
//  Messaging APP
//
//  Created by 沈秋蕙 on 2017/1/11.
//  Copyright © 2017年 iris shen. All rights reserved.
//

import UIKit
import AVFoundation
class AddFriendbyQRcodeViewController: UIViewController,AddFriendbyQRCodeViewProtocol,FriendshipDelegate,AccountProtocol{
    var friendNode: String? = ""
    var friendship: FriendshipProtocol!{
        didSet{
            friendship.delegate = self
            
        }
        
    }

    fileprivate var UserNameLabel:String! = ""
    fileprivate var EmailLabel:String! = ""
    
    @IBOutlet weak var QRcodeView: AddFriendByQRCodeView!{
        didSet {
            QRcodeView.delegate = self
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendship = Database().friendship()
        
        
        
        //將 session 傳給 view，因此使他能夠顯示圖片
        
        self.QRcodeView.QRcodeScannerView.session = QRcodeView.session
        
        //表二維度充滿整個區域
        self.QRcodeView.QRcodeScannerView.videoPreviewLayer.videoGravity = AVLayerVideoGravityResize
        
        
        //MARK:AVCaptureDevice authorized
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio){
        case .authorized:
            break
            
        case .notDetermined:
            //sessionQueue 終止
            QRcodeView.sessionQueue.suspend()
            
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: {[unowned self]
                granted in
                if !granted{
                    self.QRcodeView.setupResult = .notAuthorized
                }
                //一旦請求通過，重新開啟queue
                self.QRcodeView.sessionQueue.resume()
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
    
    func sendbackAccount(friendAccount:String){
        
        
        self.friendship.search(friendAccount)
    
        self.friendNode = self.emailToNode(friendAccount)
    }
    


}






// MARK: - AddFriendDelegate
extension AddFriendbyQRcodeViewController {
    
//    func didSearchFriend(email: String?, username: String?) {
//        if let email = email, let username = username {
//            
//            UserNameLabel = username
//            
//        
//            EmailLabel = email
//            
////     self.QRcodeView.resultEmailLabel.isHidden    = false
////     self.QRcodeView.resultUserNameLabel.isHidden = false
//          //  self.performSegue(withIdentifier: "FriendsQRCodeToAccount", sender: nil)
//        
//            self.performSegue(withIdentifier: "FriendsQRCodeToAccount", sender: self)
//            
//            
//            
//            
//        } else {
//           
//            UserNameLabel = "Not Found"
//            EmailLabel = "Not Found"
////      self.QRcodeView.resultEmailLabel.isHidden    = false
////      self.QRcodeView.resultUserNameLabel.isHidden = false
////            self.performSegue(withIdentifier: "FriendsQRCodeToAccount", sender: self)
//            
//            
//        }
    
   
        
        
//    }
    
    
    

    
    
    
//    func didCheckThisEmail(result: FriendState) {
//        if result == .none {
//            addFriend.invite(QRcodeView.resultEmailLabel.text!, username: self.QRcodeView.resultEmailLabel.text!)
//        } else {
//            self.errorAlert(title: Constants.ErrorAlert.alertTitle, message: "You are already friends, or waiting to accept the invitation.", onViewController: self)
//        }
//}

}






// MARK: - FriendshipDelegate
extension AddFriendbyQRcodeViewController {
    
    func friendshipDidSearch(email: String?, username: String?) {
        
        if let email = email , let username = username{
          
            
            if email != MyProfile.shared.email{
                UserNameLabel = username
                EmailLabel = email
                self.performSegue(withIdentifier: "FriendsQRCodeToAccount", sender: self)
           
            }
            
          } else {
            UserNameLabel = "Not Found"
            EmailLabel = "Not Found"
            self.performSegue(withIdentifier: "FriendsQRCodeToAccount", sender: self)
          
            
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendsQRCodeToAccount"{
            if let nextViewController = segue.destination as? AddFriendAccountViewController{
                print(UserNameLabel)
                print(EmailLabel)
                nextViewController.userNameToDisplay = UserNameLabel
                nextViewController.emailToDisplay = EmailLabel
            }
        }
    }
    

    

    
    
    
    
    
}





