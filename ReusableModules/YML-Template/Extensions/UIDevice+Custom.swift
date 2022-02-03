//
// UIDevice+Custom.swift
// Crohns

// Created by Y Media Labs on 04/09/19.
// Copyright © 2019 Y Media Labs. All rights reserved.
//

import UIKit

let isIPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad)
private let isIPhone: Bool = (UIDevice.current.userInterfaceIdiom == .phone)
let isIPhone4: Bool = (isIPhone && UIScreen.main.bounds.size.height == 480)
private let isRetina: Bool = (UIScreen.main.responds(to: #selector(UIScreen.displayLink(withTarget:selector:))) && UIScreen.main.scale == 2.0)

public enum DeviceTypes: String {
    case simulator          = "Simulator",
    iPodTouch5              = "iPod Touch 5",
    iPodTouch6              = "iPod Touch 6",
    iPad2                   = "iPad 2",
    iPad3                   = "iPad 3",
    iPhone4                 = "iPhone 4",
    iPhone4S                = "iPhone 4S",
    iPhone5                 = "iPhone 5",
    iPhone5S                = "iPhone 5S",
    iPhoneSE                = "iPhone SE",
    iPhone5c                = "iPhone 5c",
    iPad4                   = "iPad 4",
    iPadMini1               = "iPad Mini 1",
    iPadMini2               = "iPad Mini 2",
    iPadMini3               = "iPad Mini 3",
    iPadMini4               = "iPad Mini 4",
    iPadAir1                = "iPad Air 1",
    iPadAir2                = "iPad Air 2",
    iPadPro97               = "iPad PRO 9.7",
    iPadPro129              = "iPad PRO 12.9",
    iPad5thGen              = "iPad (5th generation)",
    iPadPro129_2ndGen       = "iPad PRO 12.9 (2nd Gen)",
    iPadPro105              = "iPad PRO 10.5",
    iPhone6                 = "iPhone 6",
    iPhone6plus             = "iPhone 6 Plus",
    iPhone6S                = "iPhone 6S",
    iPhone6Splus            = "iPhone 6S Plus",
    iPhone7                 = "iPhone 7 ",
    iPhone7plus             = "iPhone 7 Plus",
    iPhone8                 = "iPhone 8",
    iPhone8plus             = "iPhone 8 Plus",
    iPhoneX                 = "iPhone X",
    iPhoneXR                = "iPhone XR",
    iPhoneXS                = "iPhone XS",
    iPhoneXSMax             = "iPhone XS Max",
    iPhone11                = "iPhone 11",
    iPhone11Pro             = "iPhone 11 Pro",
    iPhone11ProMax          = "iPhone 11 Pro Max",
    unrecognized            = "?unrecognized?"
}

/// This extension implements the functions and computed properties to determine the jailbroken state, modelName, iphone device type, simulator check e.t.c.
public extension UIDevice {
    
    // MARK: - Constants
    static let iPhone6Height: CGFloat = 667
    static let iphone6PlusHeight: CGFloat = 736
    static let iphoneXHeight: CGFloat = 812
    static let iphoneXRHeight: CGFloat = 896
    static let jailBrokenFiles = ["/Library/MobileSubstrate/MobileSubstrate.dylib", "/bin/bash", "/usr/sbin/sshd", "/etc/apt", "/usr/bin/ssh", "/private/var/lib/apt/", "/Applications/Cydia.app"]
    static let cydiaScheme = "cydia://package/com.example.package"

    var modelName: DeviceTypes {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        // All device information
        // Source: https://gist.github.com/adamawolf/3048717
        switch identifier {
        case "iPod5,1":
            return .iPodTouch5
        case "iPod7,1":
            return .iPodTouch6
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            return .iPhone4
        case "iPhone4,1":
            return .iPhone4S
        case "iPhone5,1", "iPhone5,2":
            return .iPhone5
        case "iPhone5,3", "iPhone5,4":
            return .iPhone5c
        case "iPhone6,1", "iPhone6,2":
            return .iPhone5S
        case "iPhone7,2":
            return .iPhone6
        case "iPhone7,1":
            return .iPhone6plus
        case "iPhone8,1":
            return .iPhone6S
        case "iPhone8,2":
            return .iPhone6Splus
        case "iPhone8,4":
            return .iPhoneSE
        case "iPhone9,1", "iPhone9,3":
            return .iPhone7
        case "iPhone9,2", "iPhone9,4":
            return .iPhone7plus
        case "iPhone10,1", "iPhone10,4":
            return .iPhone8
        case "iPhone10,2", "iPhone10,5":
            return .iPhone8plus
        case "iPhone10,3", "iPhone10,6":
            return .iPhoneX
        case "iPhone11,2":
            return .iPhoneXS
        case "iPhone11,6", "iPhone11,4":
            return .iPhoneXSMax
        case "iPhone11,8":
            return .iPhoneXR
        case "iPhone12,1":
            return .iPhone11
        case "iPhone12,3":
            return .iPhone11Pro
        case "iPhone12,5":
            return .iPhone11ProMax
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return .iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return .iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return .iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return .iPadAir1
        case "iPad5,3", "iPad5,4":
            return .iPadAir2
        case "iPad2,5", "iPad2,6", "iPad2,7":
            return .iPadMini1
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return .iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9":
            return .iPadMini3
        case "iPad5,1", "iPad5,2":
            return .iPadMini4
        case "iPad5,3", "iPad5,4":
            return .iPadAir2
        case "iPad6,3", "iPad6,4":
            return .iPadPro97
        case "iPad6,7", "iPad6,8":
            return .iPadPro129
        case "iPad6,11", "iPad6,12":
            return .iPad5thGen
        case "iPad7,1", "iPad7,2":
            return .iPadPro129_2ndGen
        case "iPad7,3", "iPad7,4":
            return .iPadPro105
        case "i386", "x86_64":
            return .simulator
        default:
            return .unrecognized
        }
    }
    
    var isIphone6Plus: Bool {
        var boolValue: Bool = false
        
        if self.modelName == .simulator {
            boolValue = isIPhone && UIScreen.main.bounds.size.height == UIDevice.iphone6PlusHeight
        } else if self.modelName == .iPhone6plus {
            boolValue = true
        }
        return boolValue
    }
    
    var isIphone6: Bool {
        var boolValue: Bool = false
        if self.modelName == .simulator {
            boolValue = isIPhone && UIScreen.main.bounds.size.height == UIDevice.iPhone6Height
        } else if self.modelName == .iPhone6 {
            boolValue = true
        }
        return boolValue
    }
    
    var isIphone5Below: Bool {
        var boolValue: Bool = false
        if self.modelName == .simulator {
            boolValue = isIPhone4
        } else if self.modelName == .iPhone4S || self.modelName == .iPhone4 {
            boolValue = true
        }
        return boolValue
    }
    
    var isIphone6sPlus: Bool {
        var boolValue: Bool = false
        if self.modelName == .simulator {
            boolValue = isIPhone && UIScreen.main.bounds.size.height == UIDevice.iphone6PlusHeight
        } else if self.modelName == .iPhone6Splus {
            boolValue = true
        }
        return boolValue
    }
    
    var isIphone6s: Bool {
        var boolValue: Bool = false
        if self.modelName == .simulator {
            boolValue = isIPhone && UIScreen.main.bounds.size.height == UIDevice.iPhone6Height
        } else if self.modelName == .iPhone6S {
            boolValue = true
        }
        return boolValue
    }
    
    var isIphone4p7Inch: Bool {
        return isIphone6s || isIphone6
    }
    
    var isIphone5p5Inch: Bool {
        return isIphone6sPlus || isIphone6Plus
    }
    
    var isIphone6Below: Bool {
        var boolValue: Bool = false
        let deviceList: [DeviceTypes] = [.iPhone4, .iPhone5, .iPhone4S, .iPhone5c, .iPhone5S, .iPhoneSE]
        if self.modelName == .simulator {
            boolValue = !(isIPhone && (UIScreen.main.bounds.size.height == UIDevice.iPhone6Height || UIScreen.main.bounds.size.height == UIDevice.iphone6PlusHeight || UIScreen.main.bounds.size.height == UIDevice.iphoneXHeight || UIScreen.main.bounds.size.height == UIDevice.iphoneXRHeight))
        } else if deviceList.contains(self.modelName) == true {
            boolValue = true
        }
        return boolValue
    }
    
    var isIphone6Or6Below: Bool {
        var boolValue: Bool = isIphone6s
        if boolValue == false {
            boolValue = isIphone6Below
        }
        return boolValue
    }
    
    var isIphoneX: Bool {
        var boolValue: Bool = false
        if self.modelName == .simulator {
            boolValue = (isIPhone && UIScreen.main.bounds.size.height == UIDevice.iphoneXHeight)
        } else if self.modelName == .iPhoneX {
            boolValue = true
        }
        return boolValue
    }
    
    var isIphoneXOrAbove: Bool {
        var boolValue: Bool = false
        if self.modelName == .simulator {
            boolValue = (isIPhone && UIScreen.main.bounds.size.height == UIDevice.iphoneXHeight) || (isIPhone && UIScreen.main.bounds.size.height == UIDevice.iphoneXRHeight)
        } else if self.modelName == .iPhoneX || self.modelName == .iPhoneXR || self.modelName == .iPhoneXS || self.modelName == .iPhoneXSMax || self.modelName == .iPhone11 || self.modelName == .iPhone11Pro || self.modelName == .iPhone11ProMax {
            boolValue = true
        }
        return boolValue
    }
    
    var isSimulator: Bool {
        return self.modelName == .simulator
    }
    
    var isJailBroken: Bool {
        if isSimulator {
            return false
        }
        let jailBroken = fileExistenceCheckForJailBrokenDevice()
        return jailBroken
    }
    
    /// This method will check for files that are common for jailbroken devices, like Cydia.app or MobileSubstrate.dylib.
    ///
    /// - Returns: Bool value to determine the jailbroken device state.
    func fileExistenceCheckForJailBrokenDevice() -> Bool {
        let fileManager = FileManager.default
        for file in UIDevice.jailBrokenFiles {
            if fileManager.fileExists(atPath: file) {
                return true
            } else if canOpen(path: file) {
                return true
            }
        }
        guard let cydiaUrlScheme = URL(string: UIDevice.cydiaScheme) else {
            return readWritePermissionCheckForJailBrokenDevice()
        }
        var jailBroken = UIApplication.shared.canOpenURL(cydiaUrlScheme as URL)
        if jailBroken == false {
            jailBroken = readWritePermissionCheckForJailBrokenDevice()
        }
        return jailBroken
    }
    
    /// This method is to check sandbox voilation, In a non-jailbroken environment applications can only read and write inside the application sandbox. If application is able to access outside of its sandbox, it’s probably running on the jailbroken device.
    ///
    /// - Returns: Bool value to determine the jailbroken device state.
    /// Reference : https://medium.com/@pinmadhon/how-to-check-your-app-is-installed-on-a-jailbroken-device-67fa0170cf56
    func readWritePermissionCheckForJailBrokenDevice() -> Bool {
        var jailBroken = false
        let privatePath = "/private/jailbroken.txt"
        do {
            try "You Shall not pass".write(toFile: privatePath, atomically: true, encoding: String.Encoding.utf8)
            jailBroken = true
            try FileManager.default.removeItem(atPath: privatePath)
        } catch {
        }
        return jailBroken
    }
    
    func canOpen(path: String) -> Bool {
        let file = fopen(path, "r")
        guard file != nil else { return false }
        fclose(file)
        return true
    }
}
