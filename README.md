# iOS视频全屏方案
利用iOS原生Orientation

#### 设备两种方向
此处“真”“假”是相对而言，自行体会。
>`UIApplication.shared.statusBarOrientation // APP的statusBar方向，APP的“真”方向`
>`UIDevice.current.orientation // 设备方向，APP的“假”方向`

#### 两个扩展
根据项目中UITabBarController，UINavigationController的使用情况来确定是否使用。
```
extension UITabBarController {
    // 旋转设备时是否自动旋转
    open override var shouldAutorotate: Bool {
        return selectedViewController?.shouldAutorotate ?? true
    }
    // 设备支持的方向
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? [.portrait, .landscapeLeft, .landscapeRight]
    }
    // 设备首选方向
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}

extension UINavigationController {
    // 旋转设备时是否自动旋转
    open override var shouldAutorotate: Bool {
        return viewControllers.last?.shouldAutorotate ?? true
    }
    // 设备支持的方向
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return viewControllers.last?.supportedInterfaceOrientations ?? [.portrait, .landscapeLeft, .landscapeRight]
    }
    // 设备首选方向
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return viewControllers.last?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}
```

#### 重点方法
当设备旋转时UIDevice.current.orientation会发生改变，但由于我们在视频全屏时会限制设备仅支持横向，因此当我们将设备竖屏时UIDevice.current.orientation会改变为竖屏的值，但APP却依然是横向的，所以我们用UIApplication.shared.statusBarOrientation来判断是否真的已经旋转

```
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
```
