//
//  UIViewController+Extension.swift
//  TGIF
//
//  Created by Y Media Labs on 04/02/20.
//  Copyright © 2020 Y Media Labs. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var isViewVisible: Bool { isViewLoaded && view.window != nil }
    
    func add(to parent: UIViewController, containerView: UIView? = nil, needSafeAreaInset: Bool = false) {
        let parentView: UIView = containerView ?? parent.view
        willMove(toParent: parent)
        parent.addChild(self)
        view.frame = parentView.bounds
        parentView.addSubview(view)
        view.fixBounds(with: parentView, needSafeAreaInset: needSafeAreaInset)
        didMove(toParent: parent)
    }
    
    func remove(from parent: UIViewController) {
        guard parent.view.subviews.contains(view) else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
        didMove(toParent: nil)
    }
    
    
    func showAlert(title: String = "TGIF", message: String = "", buttonTitles: [String], destructiveButtonIndex: Int = -1, cancelButtonIndex: Int = -1, preferredStyle: UIAlertController.Style = .alert, alertViewButtonTapBlock: ((_ clickedButtonIndex: Int) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for i in 0..<buttonTitles.count {
            
            let style: UIAlertAction.Style = i == destructiveButtonIndex ? .destructive : i == cancelButtonIndex ? .cancel : .default
            
            let action = UIAlertAction(title: buttonTitles[i], style: style, handler: { _ in
                alertViewButtonTapBlock?(i)
            })
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
}
