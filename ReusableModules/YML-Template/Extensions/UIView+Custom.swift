//
// UIView+Custom.swift
// Crohns

// Created by Y Media Labs on 04/09/19.
// Copyright © 2019 Y Media Labs. All rights reserved.
//

import UIKit

///  This extension implements helper functions to get required view attributes and to modify it in a convinient manner.
@IBDesignable
public extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.white.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get {
            guard let shadowColor = layer.shadowColor else {
                return UIColor.clear
            }
            return UIColor(cgColor: shadowColor)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowWidthOffset: CGFloat {
        get {
            return layer.shadowOffset.width
        }
        set {
            layer.shadowOffset.width = newValue
        }
    }
    
    @IBInspectable var shadowHeightOffset: CGFloat {
        get {
            return layer.shadowOffset.height
        }
        set {
            layer.shadowOffset.height = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
            self.clipsToBounds = false
        }
    }
    
    /// This method will return the superviewcontroller of current view by iterating through the responderchain for next responder
    ///
    /// - Returns: A superViewcontroller of a initialized view.
    func superViewController() -> UIViewController {
        /// Finds the view's view controller.
        // Take the view controller class object here and avoid sending the same message iteratively unnecessarily.
        let responder: UIResponder = self.rootSuperView()
        while let nextResponder = responder.next, responder == nextResponder {
            if responder is UIViewController {
                return responder as? UIViewController ?? UIViewController()
            }
        }
        return UIViewController()
    }
    
    /// This method will return the superview of current view by iterating through the superview cycle for next superview
    ///
    /// - Returns: A root superview of a initialized view.
    func rootSuperView() -> UIView {
        var view: UIView = self
        while let superView = view.superview {
            view = superView
        }
        return view
    }
    
    /// Returns an UIImage object by converting the initialised view graphics with an initialized view bounds.
    ///
    /// - Returns: An optional UIImage object.
    func screenShot() -> UIImage? {
        return screenShot(withSize: self.bounds.size)
    }
    
    /// Returns an UIImage object by converting the initialised view graphics with a given bounds.
    ///
    /// - Parameter size: Rerquired size of the UIImage
    /// - Returns: An optional UIImage object
    func screenShot(withSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, 0.0)
        var image: UIImage?
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    /// It applys the drop shadow to the initialized view with the given parameters as attributes.
    ///
    /// - Parameters:
    ///   - shadowOpacity: The shadow opacity. Default value is 0.35
    ///   - shadowOffset: The shadow offset in both width and height dimension. Default value is CGSize(width: -1, height: -2).
    func dropShadow(shadowOpacity: Float = 0.35, shadowOffset: CGSize = CGSize(width: -1, height: -2)) {
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = 3
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    /// It creates a CAGradientLayer by applying the colors in a given direction.
    ///
    /// - Parameters:
    ///   - colors: The Array of UIColors used to apply gradiant.
    ///   - vertical: A Boolean value that determines whether a gradient to be applied vertically from top to bottom or horizontally left to right. Default value is true.
    /// - Returns: A CAGradientLayer object with gradient applied to it.
    func gradientLayer(colors: [UIColor], vertical: Bool = true) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.compactMap { $0.cgColor }
        gradientLayer.borderColor = layer.borderColor
        gradientLayer.borderWidth = layer.borderWidth
        gradientLayer.cornerRadius = layer.cornerRadius
        //For Horizontal left to right gradiant.
        if vertical == false {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5) // Left Middle
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5) // Right Middle
        }
        return gradientLayer
    }
}

public extension UIView {
    
    fileprivate func _round(_ corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    fileprivate func addBorder(_ mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
    /// Rounds the top corners to the specified radius.
    ///
    /// - Parameter radius: Radius to round to.
    func topRound(withRadius radius: CGFloat) {
        round([.topLeft, .topRight], radius: radius)
    }
    
    /// Rounds the bottom corners to the specified radius.
    ///
    /// - Parameter radius: Radius to round to.
    func bottomRound(withRadius radius: CGFloat) {
        round([.bottomLeft, .bottomRight], radius: radius)
    }
    
    /// Rounds the given set of corners to the specified radius.
    ///
    /// - Parameters:
    ///     - corners: Its an UIRectCorner object with corners to round.
    ///     - radius: Radius to round to.
    func round(_ corners: UIRectCorner, radius: CGFloat) {
        _ = _round(corners, radius: radius)
    }
    
    /// Rounds the given set of corners to the specified radius with a border.
    ///
    /// - Parameters:
    ///     - corners: Corners to round
    ///     - radius:    Radius to round to
    ///     - borderColor: The border color
    ///     - borderWidth: The border width
    func round(_ corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners, radius: radius)
        addBorder(mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /// Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
    /// - Parameters:
    ///     - diameter:  The view's diameter
    ///     - borderColor: The border color
    ///     - borderWidth: The border width
    func fullyRound(_ diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    /// Method to apply shadow to views
    ///
    /// - Parameters:
    ///   - color: shadow color
    ///   - opacity: opacity of shadow
    ///   - offset: The offset (in points) of the layer’s shadow
    ///   - radius: The blur radius (in points) used to render the layer’s shadow
    ///   - cornerRadius: Radius to round to
    ///   - clipToBounds: A Boolean value that determines whether subviews are confined to the bounds of the view.
    func applyShadow(color: UIColor = UIColor.buttonShadowColor, opacity: Float = 1.0, offset: CGSize = CGSize(width: 0, height: 0), radius: CGFloat = 5, cornerRadius: CGFloat? = nil, clipToBounds: Bool = true) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.cornerRadius = cornerRadius ?? radius
        clipsToBounds = clipToBounds
    }
       
}
