//
//  LocationManager.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 03/04/24.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    
    override private init() {
        super.init()
        requestLocationAccess()
    }
    
    func requestLocationAccess() {
        if locationManager == nil {
            print("auth location manager")
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
        } else {
            print("we have location manager")
        }
    }
    
    func startUpdating() {
        locationManager!.startUpdatingLocation()
    }
    
    func stopUpdating() {
        if locationManager != nil {
            locationManager!.stopUpdatingLocation()
        }
    }
    
    // MARK: - Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .notDetermined {
            locationManager!.requestWhenInUseAuthorization()
        }
    }
}
