//
// UIWindow+Custom.swift
// Crohns

// Created by Y Media Labs on 04/09/19.
// Copyright © 2019 Y Media Labs. All rights reserved.
//

import UIKit

///  This extension implements helper functions to get required window attributes.
public extension UIWindow {
    
    /// Returns the viewcontroller object by using the initialized window rootviewcontroller.
    var visibleViewController: UIViewController? {
        return UIWindow.visibleViewController(fromViewController: self.rootViewController)
    }
    
    fileprivate class func visibleViewController(fromViewController viewController: UIViewController?) -> UIViewController? {
        if let navigationVC = viewController as? UINavigationController {
            return UIWindow.visibleViewController(fromViewController: navigationVC.visibleViewController)
        } else if let tabBarVC = viewController as? UITabBarController {
            return UIWindow.visibleViewController(fromViewController: tabBarVC.selectedViewController)
        } else {
            if let presentedVC = viewController?.presentedViewController {
                return UIWindow.visibleViewController(fromViewController: presentedVC)
            } else {
                return viewController
            }
        }
    }
    
    static var topVisibleWindow: UIWindow {
        var window: UIWindow = UIWindow(frame: CGRect.zero)
        for index in (0..<UIApplication.shared.windows.count).reversed() {
            let lastWindow = UIApplication.shared.windows[index]
            if lastWindow.isHidden == false {
                window = lastWindow
                break
            } else if let theWindow = UIApplication.shared.keyWindow, index == 0 {
                window = theWindow
            }
        }
        return window
    }

}
