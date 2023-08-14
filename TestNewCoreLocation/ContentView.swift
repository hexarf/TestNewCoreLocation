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
    @ObservedObject var legacyTester = LegacyLocationTester()

    @State var position: MapCameraPosition
    @State private var showingAlert = false
    @State private var haveBackgroundSession = false

    var body: some View {
        ZStack {
            Map(position: $position) {
                
                MapCircle(center: .init(latitude: 37.33467,
                                        longitude: -122.00898),
                          radius: 1000)
                .foregroundStyle(.indigo.opacity(0.5))

                MapCircle(center: .init(latitude: 35.470561, longitude: 139.632648),
                          radius: 10)
                .foregroundStyle(.indigo.opacity(0.5))

            }
            .mapControls {
                MapUserLocationButton()
            }

            VStack {
                Text("Core Location Test").bold()
                Button(action: {
                    tester.requestLiveLocations()
                    legacyTester.requestLocation()
                }){
                    Text("Live Update開始")
                }
                Button(action: {
                    haveBackgroundSession.toggle()
                    tester.changeBackgroundSession(haveBackgroundSession)
                }){
                    HStack {
                        Text("BackgroundActivity is \(haveBackgroundSession ? "ON": "OFF")")
                        Circle()
                            .fill(haveBackgroundSession ? .green : .red)
                            .frame(width: 15, height: 15)

                    }
                }


                Text("Delegate lat:\(legacyTester.lastLocation?.coordinate.latitude ?? 0), lan\(legacyTester.lastLocation?.coordinate.longitude ?? 0), Count:\(legacyTester.updateCount)")

                Text("Live Update  lat:\(tester.liveUpdateLocation?.coordinate.latitude ?? 0), lan\(tester.liveUpdateLocation?.coordinate.longitude ?? 0) Count:\(tester.updateCount)")

                HStack {
                    Text("isStationary:")
                    Circle()
                        .fill(tester.isStationary ? .green : .red)
                        .frame(width: 15, height: 15)
                }
                Divider()

                Button(action: {
                    #if targetEnvironment(simulator)
                    self.showingAlert = true
                    #else
                    Task {
                        await tester.monitorTest()
                    }
                    #endif
                }){
                    Text("CLMonitor登録")
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("シミュレーターでは利用できません"),
                          message: nil)
                }
                Text("last event state:\(tester.monitorEvent.rawValue)")

                Button(action: {
                    Task {
                        await tester.monitorRecord()
                    }
                }){
                    Text("last event Record取得")
                }
            }
            .background()
            .frame(height: 650, alignment: .bottom)
        }
    }
}

#Preview {
    ContentView(position: .item(.forCurrentLocation()))
}


