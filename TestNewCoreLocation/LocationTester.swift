//
//  LocationTester.swift
//  TestNewCoreLocation
//
//  Created by PARK BYUNGJUN on 2023/08/08.
//

import Foundation
import CoreLocation

class LocationTester: NSObject, CLLocationManagerDelegate, ObservableObject {

    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var lastSeenLocation: CLLocation?
    @Published var clUpdaterLocation: CLLocation?

    let locationManager: CLLocationManager

    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus

        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true // バックグラウンド実行中も座標取得する場合、trueにする
        locationManager.pausesLocationUpdatesAutomatically = false

    }

    func requestLiveLocations() async {
        locationManager.startUpdatingLocation()
        let updates = CLLocationUpdate.liveUpdates()
        do {
            for try await update in updates {
                guard let location = update.location else { return }
                clUpdaterLocation = location
            }
        } catch {
            print("🍎🍎error")
        }
    }

    func requestPermission() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
    }

    func monitorTest() {
        // Test CLMonitor
//        CLMonitor
        //
    }
}

extension LocationTester {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastSeenLocation = locations.last
      //  print("🍎🍎locations:\(locations.first?.coordinate)")
    }
}
