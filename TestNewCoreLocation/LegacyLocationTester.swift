//
//  LegacyLocationTester.swift
//  TestNewCoreLocation
//
//  Created by PARK BYUNGJUN on 2023/08/08.
//

import Foundation
import CoreLocation

class LegacyLocationTester: NSObject, CLLocationManagerDelegate, ObservableObject {

    let locationManager: CLLocationManager

    @Published var lastLocation: CLLocation?
    @Published var updateCount: Int = 0

    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
    }

    func requestPermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
        updateCount += 1
    }

    func requestLocation() {
        locationManager.startUpdatingLocation()
    }
}
