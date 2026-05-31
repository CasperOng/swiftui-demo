//
//  demoApp.swift
//  demo
//
//  Created by Casper Ong
//  Last Updated: April 16, 2025 01:53 UTC+8
//  Version: v1.0.0-alpha.1 (Initial Release)
//  Build: 2025.04.16.0153
//
//  This is the main entry point of the SwiftUI Demo application.
//  It provides the main navigation and content structure.
//
//  Copyright © 2025 Casper Ong. All rights reserved.
//

import SwiftUI

@main
struct demoApp: App {
    @State private var isAuthenticated = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            Group {
                if isAuthenticated {
                    ContentView()
                } else {
                    AuthenticationView(isAuthenticated: $isAuthenticated)
                }
            }
            .tint(.blue)
            .compatOnChange(of: scenePhase) { newPhase in
                switch newPhase {
                case .background:
                    isAuthenticated = false
                case .active:
                    break
                case .inactive:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
}
