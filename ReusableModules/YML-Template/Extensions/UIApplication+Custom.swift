//
//  UIApplication+Custom.swift
//  TGIF
//
//  Created by Y Media Labs on 16/03/20.
//  Copyright © 2020 Y Media Labs. All rights reserved.
//

import UIKit

extension UIApplication {
    
    func call(number: String) {
        if let url = URL(string: "tel://" + number), canOpenURL(url) {
            open(url)
        }
    }
    
    func open(url: URL) {
        if canOpenURL(url) {
            open(url, options: [:])
        }
    }
    
}
