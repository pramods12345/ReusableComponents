//
//  UIView+Extension.swift
//  TGIF
//
//  Created by Y Media Labs on 26/02/20.
//  Copyright © 2020 Y Media Labs. All rights reserved.
//

import UIKit

// MARK: - NSLayout extension.

extension UIView {
    
    typealias ReturnTouple = (leadingConstraint: NSLayoutConstraint, trailingConstraint: NSLayoutConstraint, topConstraint: NSLayoutConstraint, bottomConstraint: NSLayoutConstraint?, heightConstraint: NSLayoutConstraint?)
    
    @discardableResult func fixBounds(with superView: UIView,
                                      insets: UIEdgeInsets = .zero,
                                      heightConstant: CGFloat? = nil,
                                      needSafeAreaInset: Bool = true) -> ReturnTouple {
        let leading, trailing, top: NSLayoutConstraint
        var bottom, height: NSLayoutConstraint?
        
        let guide: UILayoutGuide = needSafeAreaInset ? safeAreaLayoutGuide : layoutMarginsGuide
        let superGuide: UILayoutGuide = needSafeAreaInset ? superView.safeAreaLayoutGuide : superView.layoutMarginsGuide
        
        leading = guide.leadingAnchor.constraint(equalTo: superGuide.leadingAnchor, constant: insets.left)
        trailing = guide.trailingAnchor.constraint(equalTo: superGuide.trailingAnchor, constant: insets.right)
        top = guide.topAnchor.constraint(equalTo: superGuide.topAnchor, constant: insets.top)
        if let heightConstant = heightConstant {
            height = guide.heightAnchor.constraint(equalToConstant: heightConstant)
        } else {
            bottom = guide.bottomAnchor.constraint(equalTo: superGuide.bottomAnchor, constant: insets.bottom)
        }
        
        let returnVal: ReturnTouple = (leadingConstraint: leading, trailingConstraint: trailing, topConstraint: top, bottomConstraint: bottom, heightConstraint: height)
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ leading, trailing, top ])
        
        guard let constraint = height ?? bottom else { return returnVal }
        NSLayoutConstraint.activate([ constraint ])
        return returnVal
    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as? T ?? T()
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
}
