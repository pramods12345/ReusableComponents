//
//  Appearance.swift
//  TGIF
//
//  Created by Y Media Labs on 04/02/20.
//  Copyright © 2020 Y Media Labs. All rights reserved.
//

import UIKit

struct Appearance {
    
    private init() { }
    
    static func initAppearance() {
        tabBarAppearance()
    }
    
    private static func tabBarAppearance() {
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Color.buttonInActive.uiColor,
            .font: UIFont.systemFont(ofSize: 9, weight: UIFont.Weight.black)
        ]
        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Color.buttonActive.uiColor,
            .font: UIFont.systemFont(ofSize: 9, weight: UIFont.Weight.black)
        ]
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
        
        UITabBar.appearance().shadowImage = UIImage()
    }

}
