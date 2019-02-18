//
//  ViewController.swift
//  TestFix
//
//  Created by Max on 2019/2/18.
//  Copyright © 2019 Max Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

//    open override var shouldAutorotate: Bool {
//        let result = true
//        debugPrint("VC是否允许旋转:\(result)")
//        return result
//    }
//
//    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        let result: UIInterfaceOrientationMask = [.portrait, .landscapeLeft, .landscapeRight]
//        debugPrint("VC支持的方向:\(result)")
//        return result
//    }
//
//    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        let result = UIInterfaceOrientation.portrait
//        debugPrint("VC首选显示方向:\(result)")
//        return result
//    }
}

class VideoViewController: UIViewController {
    
    var isFull = false
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        debugPrint(self.view.frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
    @objc func orientationDidChange(_ no: Notification) {
        debugPrint("是否是竖着的了？\(UIApplication.shared.statusBarOrientation == .portrait)")
        if let device = no.object as? UIDevice {
            switch device.orientation {
            case .portrait:
                debugPrint("Home下")
            case .landscapeLeft:
                debugPrint("Home右")
            case .landscapeRight:
                debugPrint("Home左")
            case .faceUp:
                debugPrint("faceUp")
            case .faceDown:
                debugPrint("faceDown")
            default:
                debugPrint("其他")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        debugPrint(self.view.frame)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        debugPrint(self.view.frame)
        if view.frame.width > view.frame.height {
            tabBarController?.tabBar.isHidden = true
            heightConstraint.constant = view.frame.height
        } else {
            tabBarController?.tabBar.isHidden = false
            heightConstraint.constant = 300
        }
    }
    
    // 返回
    // 返回按钮两个功能：1.返回，2.将设备旋转成竖屏状态
    @IBAction func backAction(_ sender: Any) {
        isFull = false
        // 当设备旋转时设备方向会发生变化，但由于限制了supportedInterfaceOrientations，所以虽然设备变了，但UI并没有变化，因此使用statusBar方向来做判断
        if UIApplication.shared.statusBarOrientation == .portrait {
            navigationController?.popViewController(animated: true)
        } else {
            // 当设备方向与statusBar方向不一致时，先设置为statusBar方向，再设置成竖屏方向
            if UIDevice.current.orientation.rawValue != UIApplication.shared.statusBarOrientation.rawValue {
                UIDevice.current.setValue(NSNumber(integerLiteral: UIApplication.shared.statusBarOrientation.rawValue) , forKey: "orientation")
            }
            UIDevice.current.setValue(NSNumber(integerLiteral: UIDeviceOrientation.portrait.rawValue) , forKey: "orientation")
        }
    }
    // 旋转
    @IBAction func rotationAction(_ sender: Any) {
        UIDevice.current.setValue(NSNumber(integerLiteral: UIDeviceOrientation.landscapeLeft.rawValue) , forKey: "orientation")
        isFull = true
    }
    
    open override var shouldAutorotate: Bool {
        return true
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // 当全屏时，设备方向仅支持横向
        return (isFull ? [.landscapeLeft, .landscapeRight]:[.portrait, .landscapeLeft, .landscapeRight])
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}

