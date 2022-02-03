//
// AccessibilityIdentifierProvider.swift
//  TGIF
//
//  Created by Y Media Labs on 04/02/20.
//  Copyright © 2020 Y Media Labs. All rights reserved.
//

import Foundation

protocol AccessibilityIdentifierProvider {
    func accessibilityIdentifier(suffix: String?) -> String
}

extension AccessibilityIdentifierProvider where Self: RawRepresentable, Self.RawValue == String {
    func accessibilityIdentifier(suffix: String? = nil) -> String {
        guard let suffix = suffix else { return rawValue }
        return "\(rawValue)-\(suffix)"
    }
}
