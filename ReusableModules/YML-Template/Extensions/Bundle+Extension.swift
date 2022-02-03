//
//  Bundle+Extension.swift
//  TGIF
//
//  Created by Y Media Labs on 04/02/20.
//  Copyright © 2020 Y Media Labs. All rights reserved.
//

import Foundation

extension Bundle {
    
    var appVersionNumber: String { infoDictionary?["CFBundleShortVersionString"] as? String ?? "-".localized }
    
    var buildNumber: String { infoDictionary?["CFBundleVersion"] as? String ?? "-".localized }
 
    var appName: String { infoDictionary?["CFBundleName"] as? String ?? "-".localized }
    
}
