//
//  RotationViewController.swift
//  TestFix
//
//  Created by Max on 2019/2/19.
//  Copyright © 2019 Max Wang. All rights reserved.
//

import UIKit
import SnapKit


class RotationViewController: UIViewController {

    var isRotation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func rotationAction(_ sender: UIButton) {
        isRotation = !isRotation
        if isRotation {
            rotation(sender.superview, sv: sender.superview?.superview)
        } else {
            rotationRecovery(sender.superview)
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return isRotation ? [.landscapeLeft, .landscapeRight] : [.portrait]
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    var rotateOriginalContentView: UIView! // 旋转原始视图
    var rotateView: UIView! // 需要旋转的视图
    var rotateViewOriginalFrameForWindow: CGRect! // 旋转视图相对于Window的原始位置，用于还原
    var rotateTargetContentView: UIView! // 旋转目标视图
    // 旋转
    func rotation(_ v: UIView?, sv: UIView?) {
        guard let rsv = sv else {
            return
        }
        rotateOriginalContentView = rsv
        guard let rv = v else {
            return
        }
        rotateView = rv
        guard let window = UIApplication.shared.windows.first else {
            return
        }

        rotateViewOriginalFrameForWindow = rotateView.convert(rotateView.frame, to: window)
        rotateTargetContentView = UIView(frame: rotateViewOriginalFrameForWindow)
        rotateTargetContentView.backgroundColor = UIColor.orange
        window.addSubview(rotateTargetContentView)
        
        rotateTargetContentView.addSubview(rotateView)
        rotateView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        UIDevice.current.setValue(NSNumber(integerLiteral: UIDeviceOrientation.landscapeLeft.rawValue) , forKey: "orientation")
    }
    // 旋转复原
    func rotationRecovery(_ v: UIView?) {
        if UIDevice.current.orientation.rawValue != UIApplication.shared.statusBarOrientation.rawValue {
            UIDevice.current.setValue(NSNumber(integerLiteral: UIApplication.shared.statusBarOrientation.rawValue) , forKey: "orientation")
        }
        UIDevice.current.setValue(NSNumber(integerLiteral: UIDeviceOrientation.portrait.rawValue) , forKey: "orientation")
    }
    // 屏幕旋转调用的方法
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if size.width > size.height {
            if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight {
                return
            }
            coordinator.animate(alongsideTransition: { (context) in
                var frame = self.rotateTargetContentView.bounds
                frame.size = size
                self.rotateTargetContentView.frame = frame
                self.rotateTargetContentView.layoutIfNeeded()
            }) { (context) in
            }
        } else {
            coordinator.animate(alongsideTransition: { (context) in
                self.rotateTargetContentView.frame = self.rotateViewOriginalFrameForWindow
                self.rotateTargetContentView.layoutIfNeeded()
            }) { (context) in
                self.rotateView.removeFromSuperview()
                self.rotateOriginalContentView.addSubview(self.rotateView)
                self.rotateTargetContentView.removeFromSuperview()
                self.rotateView.snp.remakeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
            }
        }
    }
}
