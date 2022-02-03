//
//  String+Extension.swift
//  TGIF
//
//  Created by Y Media Labs on 04/02/20.
//  Copyright © 2020 Y Media Labs. All rights reserved.
//

import UIKit

extension String {
    
    var localized: String { NSLocalizedString(self, comment: "") }
    
    func size(withConstrainedWidth width: CGFloat = .greatestFiniteMagnitude, height: CGFloat = .greatestFiniteMagnitude, font: UIFont) -> CGSize {
        let constraintSize = CGSize(width: width, height: height)
        return self.boundingRect(with: constraintSize, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
    
    var decodeNonLossyASCII: String {
        guard let data = data(using: .utf8),
            let decodedString = String(data: data, encoding: .nonLossyASCII) else {
                return self
        }
        return decodedString
    }
    
    var encodeNonLossyASCII: String {
        guard let cString = cString(using: .nonLossyASCII),
            let encodeString = String(cString: cString, encoding: .utf8) else {
                return self
        }
        return encodeString
    }
    
    func getAttributedString(textColor: UIColor, lineHeight: CGFloat, font: UIFont) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.minimumLineHeight = lineHeight
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes([.font: font], range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
}
