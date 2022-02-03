//
//  DataProvider.swift
//  TGIF
//
//  Created by Y Media Labs on 09/03/20.
//  Copyright © 2020 Y Media Labs. All rights reserved.
//

import Foundation

final class DataProvider {
    
    /// To get the data from a file
    ///
    /// - Parameters:
    ///   - fileName: Name of the file
    ///   - type: type of the file
    class func data(from fileName: String, type: String = "json") -> Data? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: type) else { return nil }
        return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
    
    /// Get data from URL
    ///
    /// - Parameter url: url
    class func data(url: URL) -> Data? {
        return try? Data(contentsOf: url, options: .mappedIfSafe)
    }
        
    /// Get the codable model of the type mentioned
    /// - Parameter fileName: Name of the file
    /// - Parameter type: Type of the model to which object should be converted to
    /// - Parameter skipKey: paths to be skipped
    class func codableModel<T: Codable>(from fileName: String, of type: T.Type, bySkipping skipKey: String? = nil) -> Codable? {
        guard let data = data(from: fileName) else { return nil }
        return try? JSONDecoder().decode(type.self, from: data, skipKeyPath: skipKey)
    }
    
    /// Get dictionary object from the cpodable model
    ///
    /// - Parameters:
    ///   - codableModel: Codable model which should be converted to dictionary
    ///   - keyPath: Keypath to be skipped
    class func dictionary<T: Codable>(from codableModel: T, byAdding keyPath: String? = nil) -> [String: Any]? {
        guard let json = try? JSONEncoder().encodeWithJson(codableModel, addKeyPath: keyPath) else { return nil }
        return json as? [String: Any]
    }
    
    /// Get the codable model of the type mentioned
    /// - Parameter object: The object to be converted
    /// - Parameter type: Type of the model to which object should be converted to
    /// - Parameter skipKey: paths to be skipped
    class func codableModel<T: Codable>(from object: Any?, of type: T.Type, bySkipping skipKey: String? = nil) -> Codable? {
        guard let object = object else { return nil }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) else { return nil }
        
        return try? JSONDecoder().decode(type.self, from: jsonData, skipKeyPath: skipKey)
    }

}
