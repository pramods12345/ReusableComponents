//
//  Notification.Name+Extension.swift
//  TGIF
//
//  Created by Y Media Labs on 04/02/20.
//  Copyright © 2020 Y Media Labs. All rights reserved.
//

import Foundation

public extension Notification.Name {
    static let networkConnectionRestored = Notification.Name("networkConnectionRestored")
    static let networkConnectionLost = Notification.Name("networkConnectionLost")
}
