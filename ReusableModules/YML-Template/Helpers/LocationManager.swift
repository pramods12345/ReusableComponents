//
//  LocationManager.swift
//  TGIF
//
//  Created by Y Media Labs on 04/02/20.
//  Copyright © 2020 Y Media Labs. All rights reserved.
//

import Foundation
import CoreLocation

typealias LocationManagerCompletionBlock = (_ currentLocation: CLLocation?, _ error: Error?) -> Void

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var locationManagerCompletionBlock: LocationManagerCompletionBlock?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
    }
    
    func startFetchingMyLocation(completionBlock: LocationManagerCompletionBlock?) {
        locationManagerCompletionBlock = completionBlock
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse,
             .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined,
             .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            locationManagerCompletionBlock?(nil, nil)
            locationManagerCompletionBlock = nil
            currentLocation = nil
        @unknown default:
            break
        }
    }
    
    func getLocationAuthorizationStatus() -> CLAuthorizationStatus {
        CLLocationManager.authorizationStatus()
    }
    
    func stopFetchingMyLocation() {
        locationManager.stopUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManagerCompletionBlock?(locations.last, nil)
        locationManagerCompletionBlock = nil
        currentLocation = locations.last
        stopFetchingMyLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManagerCompletionBlock?(nil, error)
        locationManagerCompletionBlock = nil
        currentLocation = nil
        stopFetchingMyLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse,
             .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied:
            locationManagerCompletionBlock?(nil, nil)
            locationManagerCompletionBlock = nil
            currentLocation = nil
        default:
            break
        }
    }
    
}
