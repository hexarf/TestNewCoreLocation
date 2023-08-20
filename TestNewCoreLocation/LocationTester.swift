//
//  LocationTester.swift
//  TestNewCoreLocation
//
//  Created by PARK BYUNGJUN on 2023/08/08.
//

import Foundation
import CoreLocation
import os

@MainActor class LocationTester: ObservableObject {

    @Published var liveUpdateLocation: CLLocation?
    @Published var isStationary: Bool = false
    @Published var updateCount: Int = 0
    @Published var monitorEvent: MonitorState = .nothing

    private let locationManager: CLLocationManager
    private var backgroundActivity: CLBackgroundActivitySession?

    enum MonitorState: String {
        case nothing = "nothing"
        case satisfied = "satisfied"
        case unknown = "unknown"
        case unsatisfied = "unsatisfied"
    }

    init() {
        locationManager = CLLocationManager()
    }

    func requestLiveLocations() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        let updates = CLLocationUpdate.liveUpdates()
        Task() {
            do {
                for try await update in updates {
                    self.isStationary = update.isStationary
                    guard let location = update.location else { return }
                    liveUpdateLocation = location
                    updateCount += 1
                }
            } catch {
                print("error")
            }
            return
        }
    }

    func monitorTest() async {
        let monitor = await CLMonitor("testMonitor2")
        await monitor.remove("ApplePark")
        await monitor.remove("MyHome")
        await monitor.remove("Store")

        let store = CLMonitor.CircularGeographicCondition(center: .init(latitude: 35.470561, longitude: 139.632648), radius: 20)
        await monitor.add(store, identifier: "Store")

        let identifiers = await monitor.identifiers
        print("identifiers:\(identifiers)")

        do {
            for try await event in await monitor.events {
                print("state:\(event.state), id:\(event.identifier), date:\(event.date)")

                switch event.state {
                case .satisfied:
                    self.monitorEvent = .satisfied
                case .unknown:
                    self.monitorEvent = .unknown
                case .unsatisfied:
                    self.monitorEvent = .unsatisfied
                default:
                    self.monitorEvent = .nothing
                }
            }
        } catch {

        }
    }

    func monitorRecord() async {
        let monitor = await CLMonitor("testMonitor2")
        let monitorRecord = await monitor.record(for: "Store")

        let state: MonitorState
        switch monitorRecord?.lastEvent.state {
        case .satisfied:
            state = .satisfied
        case .unknown:
            state = .unknown
        case .unsatisfied:
            state = .unsatisfied
        default:
            state = .nothing
        }
        print("last store: \(monitorRecord?.lastEvent.identifier), \(state), \(monitorRecord?.lastEvent.date)")
    }

    func changeBackgroundSession(_ haveBackgroundSession: Bool) {
        if haveBackgroundSession {
            backgroundActivity = CLBackgroundActivitySession()
        } else {
            backgroundActivity?.invalidate()
        }
    }
}
