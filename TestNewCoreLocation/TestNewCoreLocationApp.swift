//
//  TestNewCoreLocationApp.swift
//  TestNewCoreLocation
//
//  Created by PARK BYUNGJUN on 2023/08/06.
//

import SwiftUI

@main
struct TestNewCoreLocationApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(position: .userLocation(fallback: .automatic))
        }
    }
}
