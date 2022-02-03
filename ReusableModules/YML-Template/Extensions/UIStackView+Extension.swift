//
//  UIStackView+Extension.swift
//  TGIF
//
//  Created by Y Media Labs on 04/02/20.
//  Copyright © 2020 Y Media Labs. All rights reserved.
//

import UIKit

extension UIStackView {
    
    func removeArrangedSubviews() {
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
            removeArrangedSubview($0)
        }
    }
    
}
