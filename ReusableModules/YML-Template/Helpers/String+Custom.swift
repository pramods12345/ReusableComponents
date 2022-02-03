//
// String+Custom.swift
// Crohns

// Created by Y Media Labs on 03/09/19.
// Copyright © 2019 Y Media Labs. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

// MARK: - This extension implements all the helper functions of a string like localization, encoding, decoding, attribute string e.t.c.
public extension String {
    
    /// Returns the localized string if exists from the normal string.
    ///
    /// - Parameter comment: The comment parameter enables developer to understand what the key represents.It can be used by translation team to know what is this string for.
    /// - Returns: A localized string
    func localized(_ comment: String = "") -> String {
        if comment.isEmpty {
            return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: self)
        }
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
    
    /// Returns the text size based on the values given for the parameters with the help of boundingRect API from UIKit
    ///
    /// - Parameters:
    ///   - font: The Font which you given in the text element.
    ///   - lineHeight: Each line height in a paragraph irrespective of the font size. If the value is less <= 0, then lineheight will be fontsize + 4. Default value is 0.
    ///   - width: The Maximum width the text element can allocate.
    ///   - height: The Maximum height the text element can allocate. Default value is 1200.
    /// - Returns: A size component (CGSize) indicates the width and height required to draw the entire contents of the string.
    func textSize(withFont font: UIFont, lineHeight: CGFloat = 0, width: CGFloat, height: CGFloat = 1200) -> CGSize {
        let textSingleLineHeight = lineHeight > 0 ? lineHeight: font.pointSize + 4
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        if textSingleLineHeight > (font.pointSize + 4) {
            paragraphStyle.lineHeightMultiple = textSingleLineHeight / (font.pointSize + 4)
        }
        let attributeString = NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        let rect = attributeString.boundingRect(with: CGSize(width: width, height: height), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.size
    }
    
    subscript (charectorIndex: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: charectorIndex)]
    }
    
    subscript (stringIndex: Int) -> String {
        return String(self[stringIndex] as Character)
    }
    
    /// Returns the UTF8 encoded string by converting the raw string to data with nonLossyASCII encoding and from the data object to string with UTF8 encoding.
    ///
    /// - Returns: String - UTF8 encoded string.
    func utf8EncodedString() -> String {
        let encodedData = self.data(using: String.Encoding.nonLossyASCII)
        var encodedString: NSString?
        if let encodedData = encodedData {
            encodedString = NSString(data: encodedData, encoding: String.Encoding.utf8.rawValue)
        }
        return  (encodedString == nil ? self: String(encodedString ?? self as NSString))
    }
    
    ///  Returns a normal string by decoding the UTF8 encoded string.
    ///
    /// - Returns: String - UTF8 decoded string
    func utf8DecodedString() -> String {
        let decodedData = self.data(using: String.Encoding.utf8)
        var decodedString: NSString?
        if let decodedData = decodedData {
            decodedString = NSString(data: decodedData, encoding: String.Encoding.nonLossyASCII.rawValue)?.removingPercentEncoding as NSString?
        }
        return  (decodedString == nil ? self: String(decodedString ?? self as NSString))
    }
    
    /// Returns string by removing the white spaces and new lines special characters in a given string.
    ///
    /// - Returns: String
    func removingWhitespacesAndNewLines() -> String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    /// Replace and return the initialized string for all charactors given as array of strings with the given string to replace.
    ///
    /// - Returns: String by replacing scheme
    func replacingOccurrences(of strings: [String], with: String) -> String {
        var finalString = self
        for string in strings {
            finalString = finalString.replacingOccurrences(of: string, with: with)
        }
        return finalString
    }
    
    /// Removes all available http schemes from the string initialized.
    ///
    /// - Returns: String by replacing scheme
    func removeHttpUrlSchemesFromUrl() -> String {
        var urlString = self
        urlString = urlString.replacingOccurrences(of: "http://", with: "")
        urlString = urlString.replacingOccurrences(of: "https://", with: "")
        urlString = urlString.replacingOccurrences(of: "HTTPS://", with: "")
        urlString = urlString.replacingOccurrences(of: "HTTP://", with: "")
        return urlString
    }
    
    /// Returns string by removing the new lines special characters in a given string.
    ///
    /// - Returns: String
    func removeNewLines() -> String {
        return components(separatedBy: .newlines).joined()
    }
    
    /// Returns string if any email domain exists or else nil.
    ///
    /// - Returns: Optional(String)
    func getEmailDomain() -> String? {
        return components(separatedBy: "@").last
    }
    
    /// Returns the Query URL encoded string by splitting the string with "?" to multiple components
    ///
    /// - Returns: String - Query URL encoded string
    func queryURLEncodedString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    /// Convert Nsrange to range
    ///
    /// - Parameter nsRange: An NSRange object to convert to Range.
    /// - Returns: Range object
    func range(_ nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    /// Returns the attributed string with given parameters
    ///
    /// - Parameters:
    ///   - lineHeightMultiple: The required line height in a paragraph. Default value is 1.2.
    ///   - alignmentType: The text allignment in a given text element. Default value is .left.
    ///   - letterSpacing: The letter spacing in a paragraph. Default value is 0.0.
    ///   - textStyle: The `UIFontTextStyle` for the font.
    /// - Returns: NSMutableAttributedString - Comprised with given parameter values.
    func getAttributedStringForDynamicType(textColor: UIColor = .white, lineHeight: CGFloat = 0.0, alignmentType: NSTextAlignment = .left, letterSpacing: CGFloat = 0.0, textStyle: (style: UIFont.TextStyle, fontName: CustomFontName), islineBreakRequired:Bool = false, customColors: [String: (customColor: UIColor, textStyle: (style: UIFont.TextStyle, fontName: CustomFontName))]? = nil) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        var attributes = getAttributes(textColor: textColor, lineHeight: lineHeight, alignmentType: alignmentType, letterSpacing: letterSpacing , fontLineHeight: (scaledFont.customFont(forTextStyle: textStyle.style, fontName: textStyle.fontName).lineHeight),islineBreakRequired:islineBreakRequired )
        attributes[.font] = scaledFont.font(forTextStyle: textStyle.style, fontName: textStyle.fontName)
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        customColors?.forEach({ (text, arg1) in
            let (color, textStyle) = arg1
            let range = (self as NSString).range(of: text)
            attributedString.addAttributes([.foregroundColor: color], range: range)
            attributedString.addAttributes([.font: scaledFont.font(forTextStyle: textStyle.style, fontName: textStyle.fontName)], range: range)
        })
        return attributedString
    }
    
    // Returns the attributed string with given parameters
    ///
    /// - Parameters:
    ///   - lineHeightMultiple: The required line height in a paragraph. Default value is 1.2.
    ///   - alignmentType: The text allignment in a given text element. Default value is .left.
    ///   - letterSpacing: The letter spacing in a paragraph. Default value is 0.0.
    ///   - fontLineHeight: The line height of the given font.
    /// - Returns: NSMutableAttributedString - Comprised with given parameter values.
    func getAttributedString(textColor: UIColor = .white, lineHeight: CGFloat = 0.0, alignmentType: NSTextAlignment = .left, letterSpacing: CGFloat = 0.0, fontLineHeight: CGFloat,islineBreakRequired:Bool = false) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let attributes = getAttributes(textColor: textColor, lineHeight: lineHeight, alignmentType: alignmentType, letterSpacing: letterSpacing, fontLineHeight: fontLineHeight,islineBreakRequired: islineBreakRequired)
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    func getAttributedString(textColor: UIColor = .white, lineHeight: CGFloat = 0.0, alignmentType: NSTextAlignment = .left, fontLineHeight: CGFloat, font: UIFont) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        var attributes = getAttributes(textColor: textColor, lineHeight: lineHeight, alignmentType: alignmentType, fontLineHeight: fontLineHeight)
        attributes[.font] = font
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    /// Returns the attributed string with given parameters
    ///
    /// - Parameters:
    ///   - lineHeightMultiple: The required line height in a paragraph. Default value is 1.2.
    ///   - alignmentType: The text allignment in a given text element. Default value is .left.
    ///   - letterSpacing: The letter spacing in a paragraph. Default value is 0.0.
    /// - Returns: NSMutableAttributedString - Comprised with given parameter values.
    
    private func getAttributes(textColor: UIColor = .white, lineHeight: CGFloat = 0.0, alignmentType: NSTextAlignment = .left, letterSpacing: CGFloat = 0.0, fontLineHeight: CGFloat, islineBreakRequired:Bool = false) -> [NSAttributedString.Key : Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.alignment = alignmentType
        paragraphStyle.lineHeightMultiple = lineHeight / fontLineHeight
        if islineBreakRequired {
            paragraphStyle.lineBreakMode = .byTruncatingTail
        }
        let attributes: [NSAttributedString.Key : Any] = [.paragraphStyle: paragraphStyle, .kern: letterSpacing, .foregroundColor: textColor]
        return attributes
    }
    
    /// Returns the attributed string with given parameters
    ///
    /// - Parameters:
    ///   - font: The required font for html string.
    ///   - color: The text color.
    /// - Returns: NSAttributedString - Comprised with given parameter values.
    func htmlAttributed(using font: UIFont, normalFont: UIFont, lineHeight: CGFloat, color: UIColor) -> NSAttributedString? {
        do {
            var height = (lineHeight / normalFont.lineHeight) * font.lineHeight
            height = height > lineHeight ? height : lineHeight
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(font.pointSize)px !important;" +
                "color: \(color.hexString) !important;" + ///282828 default text colour hex value
                "line-height: \(height)px !important;" +
                "font-family: \(font.fontName), HelveticaNeue !important;" +
            "}</style> \(self.trimmingCharacters(in: .whitespacesAndNewlines))"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else { return nil }
            
            let attributeString = try NSMutableAttributedString(data: data,
                                                                options: [.documentType: NSAttributedString.DocumentType.html,
                                                                          .characterEncoding: String.Encoding.utf8.rawValue],
                                                                documentAttributes: nil)
            /// Plain HTML with only <P> tags, new line will get add at end of the string. Removing that with the below code.
            if let lastCharacter = attributeString.string.last, lastCharacter == "\n" {
                attributeString.deleteCharacters(in: NSRange(location: (attributeString.length - 1), length: 1))
            }
            
            /// This code will add color to the link detectors and underline for all the HTML code.
            let newString = NSMutableAttributedString(attributedString: attributeString)
            let types: NSTextCheckingResult.CheckingType = [.link, .phoneNumber, .address]
            
            guard let linkDetector = try? NSDataDetector(types: types.rawValue) else { return attributeString }
            let range = NSRange(location: 0, length: attributeString.length)
            
            linkDetector.enumerateMatches(in: attributeString.string, options: [], range: range, using: { (match, _ , _) in
                if let matchRange = match?.range {
                    newString.removeAttribute(.foregroundColor, range: matchRange)
                    newString.removeAttribute(.underlineColor, range: matchRange)
                    newString.removeAttribute(.underlineStyle, range: matchRange)
                    newString.addAttributes([.foregroundColor: UIColor.darkGreenTitleColor, .underlineColor: UIColor.darkGreenTitleColor, .underlineStyle: NSUnderlineStyle.single.rawValue], range: matchRange)
                }
            })
            return newString
        } catch {
            return nil
        }
    }
    
    /// Method to capitalize only the first character of the string
    func capitalizedFirst() -> String {
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
        return first.uppercased() + rest.lowercased()
    }
    
    /// Method to replace the first occurence of string with replacement
    /// - Parameters:
    ///     - string: String to be replaced
    ///     - replacement: String to replace
    func replacingFirstOccurrence(of string: String, with replacement: String) -> String {
        guard let range = self.range(of: string) else { return self }
        return replacingCharacters(in: range, with: replacement)
    }
}

// MARK: - This extension implements all the validation helper snippets of a string as functions and computed properties.
public extension String {
    
    var length: Int {
        return self.count
    }
    
    var isDecimal: Bool {
        
        var decimal: Bool = false
        
        if self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
            decimal = true
        }
        return decimal
    }
    
    var isNumeric: Bool {
        var isNumber = false
        if Int(self) != nil {
            isNumber = true
        }
        return isNumber
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var isAlphabetical: Bool {
        var alphabetical: Bool = true
        
        if self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil {
            alphabetical = false
        }
        return alphabetical
    }
    
    var doesContainWhiteSpace: Bool {
        var containWhiteSpace: Bool = false
        
        if self.rangeOfCharacter(from: CharacterSet.whitespaces) != nil {
            containWhiteSpace = true
        }
        return containWhiteSpace
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "^(.*)*@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*\\.([a-zA-Z]{2,10})$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
    }
    
    func contains(find: String) -> Bool {
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

// MARK: - This extension implements all the helper functions to get the substrings of a string.
public extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    ///
    /// - Parameters:
    ///   - start: Starting index of substring
    ///   - offsetBy: Off set value for both the index
    /// - Returns: String - Substring of a given string.
    func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
    
    /// Returns the substring inbetween specified strings
    ///
    /// - Parameters:
    ///   - from: Starting string
    ///   - to: Ending string
    /// - Returns: String
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    /// Returns sub string from the given index as start index to the end of the string.
    ///
    /// - Parameter index: An integer value of start index of sub string.
    /// - Returns: String - Substring of a given string.
    func substring(from index: Int) -> String {
        if index < 0 || index > self.count {
            return ""
        }
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
    
    /// Returns sub string to the given index as end index from the first index of the string.
    ///
    /// - Parameter index: An integer value of end index of sub string.
    /// - Returns: String - Substring of a given string.
    func substring(to index: Int) -> String {
        if index < 0 || index > self.count {
            return ""
        }
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    /// Returns sub string for a given range from start to end index.
    ///
    /// - Parameters:
    ///   - start: The starting index of substring as an integer value.
    ///   - end: The ending index of substring as an integer value.
    /// - Returns: String - Substring of a given string.
    func substring(withRange start: Int, end: Int) -> String {
        if start < 0 || start > self.count {
            return ""
        } else if end < 0 || end > self.count {
            return ""
        }
        let range = self.index(self.startIndex, offsetBy: start)..<self.index(self.startIndex, offsetBy: end)
        return String(self[range])
    }
    
    /// Returns sub string for a given range from start and location.
    ///
    /// - Parameters:
    ///   - start: The starting index of substring as an integer value.
    ///   - location: The offset index from the start index as an integer value.
    /// - Returns: String - Substring of a given string.
    func substring(withRange start: Int, location: Int) -> String {
        if start < 0 || start > self.count {
            return ""
        } else if location < 0 || start + location > self.count {
            return ""
        }
        let range = self.index(self.startIndex, offsetBy: start)..<self.index(self.startIndex, offsetBy: start + location)
        return String(self[range])
    }
    
    // Method to format the phonenumbers
    internal func formattedPhoneNumberString(prefixRange: String, separatorRange: String, suffixRange: String) -> String {
        let phoneNumberLength = 10
        var number = extractNumbers()
        
        if number.count > phoneNumberLength {
            number = String(number.prefix(min(count, phoneNumberLength)))
        }
        
        var regex = "(\\d{\(prefixRange)})(\\d{1,\(separatorRange)})"
        var replacementPattern = "$1-$2"
        if number.count > 6 {
            regex.append("(\\d{0,\(suffixRange)})")
            replacementPattern.append("-$3")
        }
        return number.replacingOccurrences(of: regex, with: replacementPattern, options: .regularExpression, range: nil)
    }
    
    // Remove all the special characters and just return phonenumbers
    func extractNumbers() -> String {
        let allowedCharacterSet: Set<Character> = Set("0123456789")
        let numberString = String(self.filter { allowedCharacterSet.contains($0) })
        return numberString
    }
    
    func trimSpecialCharacters() -> String {
        let filteredCharacters = self.filter {
            String($0).rangeOfCharacter(from: NSCharacterSet.alphanumerics) != nil
        }
        return String(filteredCharacters)
    }
    
    func trimWhitespaces() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension UnicodeScalar {
    
    var isEmoji: Bool {
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        127000...127600, // Various asian characters
        65024...65039, // Variation selector
        9100...9300, // Misc items
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
            
        default:
            return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        
        return value == 8205
    }
}

// MARK: - Emoji Handlings

extension String {
    
    var glyphCount: Int {
        
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    var containsOnlyEmoji: Bool {
        
        return !isEmpty
            && !unicodeScalars.contains(where: {
                !$0.isEmoji
                    && !$0.isZeroWidthJoiner
            })
    }
    
    // The next tricks are mostly to demonstrate how tricky it can be to determine emoji's
    // If anyone has suggestions how to improve this, please let me know
    var emojiString: String {
        
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var emojis: [String] {
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            previousScalar = scalar
        }
        scalars.append(currentScalarSet)
        return scalars.map { $0.map { String($0) } .reduce("", +) }
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            
            if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        
        return chars
    }
}

extension String {
    
    /// Method to convert the normal string to SHA 256 Hashed string using CommonCrypto
    /// CC_SHA256 API exposed from from CommonCrypto-60118.50.1:
    /// https://opensource.apple.com/source/CommonCrypto/CommonCrypto-60118.50.1/include/CommonDigest.h.auto.html

    func sha256() -> String {
        if let strData = self.data(using: String.Encoding.utf8) {
            /// #define CC_SHA256_DIGEST_LENGTH     32
            /// Creates an array of unsigned 8 bit integers that contains 32 zeros
            var digest = [UInt8](repeating: 0, count:Int(CC_SHA256_DIGEST_LENGTH))
     
            /// CC_SHA256 performs digest calculation and places the result in the caller-supplied buffer for digest (md)
            /// Takes the strData referenced value (const unsigned char *d) and hashes it into a reference to the digest parameter.
            strData.withUnsafeBytes {
                // CommonCrypto
                // extern unsigned char *CC_SHA256(const void *data, CC_LONG len, unsigned char *md)  -|
                // OpenSSL                                                                             |
                // unsigned char *SHA256(const unsigned char *d, size_t n, unsigned char *md)        <-|
                _ = CC_SHA256($0.baseAddress, UInt32(strData.count), &digest)
            }
     
            /// Unpack each byte in the digest array and add them to the sha256String
            let sha256String = digest.map { String(format: "%02x", $0) }.joined()
           
            return sha256String
        }
        return ""
    }
    
}
