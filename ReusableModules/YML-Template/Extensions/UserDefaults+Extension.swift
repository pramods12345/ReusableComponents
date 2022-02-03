//
//  UserDefaults+Extension.swift
//  TGIF
//
//  Created by Y Media Labs on 04/02/20.
//  Copyright © 2020 Y Media Labs. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func saveCodable<T: Codable>(_ value: T?, for key: String) {
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: key)
    }
    
    func getCodable<T>(_ type: T.Type, for key: String) -> T? where T: Decodable {
        guard let encodedData = data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: encodedData)
    }
    
    func saveCodableArray<T: Codable>(_ value: [T], for key: String) {
        let data = value.map { try? JSONEncoder().encode($0) }
        set(data, forKey: key)
    }
    
    func getCodableArray<T>(_ type: T.Type, for key: String) -> [T] where T: Decodable {
        guard let encodedData = array(forKey: key) as? [Data] else { return [] }
        return encodedData.compactMap { try? JSONDecoder().decode(type, from: $0) }
    }
    
}
