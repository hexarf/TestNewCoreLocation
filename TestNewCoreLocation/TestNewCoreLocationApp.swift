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
            ContentView()
 //           testFunc()
            let _ = testFunc()

            let _ = LocationTester()
        }
    }
}

extension TestNewCoreLocationApp {
    func testFunc() {
        print("asdc")

//        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        print("🍎🍎:\(UIApplication.openSettingsURLString)")
    }
}
