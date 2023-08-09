//
//  ContentView.swift
//  TestNewCoreLocation
//
//  Created by PARK BYUNGJUN on 2023/08/06.
//

import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    @ObservedObject var tester = LocationTester()

    var body: some View {
        ZStack {
            Map() {
            }
            VStack {
                Text("Hello world")
                Button(action: {
                    didTapButton()
                })
                {
                    Text("位置情報取得許可")
                }
                Button(action: {
                    Task {
                        await tester.requestLiveLocations()
                    }
                })
                {
                    Text("Live Update Start")
                }

                Text("Delegate lat:\(tester.lastSeenLocation?.coordinate.latitude ?? 0), lan\(tester.lastSeenLocation?.coordinate.longitude ?? 0)")

                Text("Live Update  lat:\(tester.clUpdaterLocation?.coordinate.latitude ?? 0), lan\(tester.clUpdaterLocation?.coordinate.longitude ?? 0)")
            }
            .background()
            .position(.init(x: 200, y: 700))
        }
    }

    func didTapButton() {
        print("didTapButton")
//        let locationManager = CLLocationManager()
//        locationManager.requestAlwaysAuthorization()

//        let tester = LocationTester()
        tester.requestPermission()
    }

}

#Preview {
    ContentView()
}


