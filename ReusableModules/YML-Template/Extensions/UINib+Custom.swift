//
//  UINib+Custom.swift
//  TGIF
//
//  Created by Y Media Labs on 09/03/20.
//  Copyright © 2020 Y Media Labs. All rights reserved.
//

import UIKit

///  This class implements helper functions to initialize the UINib by using the class name from which it infers.
public protocol NibIdentifiable {
    static var nibIdentifier: String { get }
}

extension UIView: NibIdentifiable {
    public static var nibIdentifier: String {
        return String(describing: self)
    }
}

public extension UINib {
    
    /// This static method instantiates by using generics and converting the class name itself as nib identifier.
    ///
    /// - Parameter _: Any view instance of type UINib
    /// - Returns: Returns a geenric type which is of type UINib
    static func instantiateNib<T: UIView>(_: T.Type) -> [T] {
        guard let nib = Bundle.main.loadNibNamed(T.nibIdentifier, owner: self, options: nil) as? [T] else {
            fatalError("Couldn't instantiate nib with identifier \(T.nibIdentifier) ")
        }
        
        return nib
    }
    
    /// This static method instantiates by using generics and converting the class name itself as nib identifier. This will automatically infer the type to its variable assigned if it's type of UINib.
    ///
    /// - Returns: Returns a geenric type which is of type UINib
    static func instantiateNib<T: UIView>() -> [T] {
        guard let nib = Bundle.main.loadNibNamed(T.nibIdentifier, owner: self, options: nil) as? [T] else {
            fatalError("Couldn't instantiate view controller with identifier \(T.nibIdentifier) ")
        }
        
        return nib
    }
}

