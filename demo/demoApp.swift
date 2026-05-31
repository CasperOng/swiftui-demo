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
    
    init() {
        // Configure app appearance
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        // Configure app to hide content in task switcher
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.windowLevel = .alert + 1
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                ContentView()
                    .onChange(of: scenePhase) { oldPhase, newPhase in
                        if newPhase == .background {
                            // Lock the app when it goes to background
                            isAuthenticated = false
                            
                            // Hide window content when going to background
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                windowScene.windows.first?.isHidden = true
                            }
                        } else if newPhase == .active {
                            // Show window content when becoming active
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                windowScene.windows.first?.isHidden = false
                                windowScene.windows.first?.makeKeyAndVisible()
                            }
                        }
                    }
                    .onChange(of: isAuthenticated) { oldValue, newValue in
                        if newValue {
                            // Reset any necessary state when authenticated
                            print("User authenticated")
                        }
                    }
            } else {
                AuthenticationView(isAuthenticated: $isAuthenticated)
                    .onChange(of: scenePhase) { oldPhase, newPhase in
                        if newPhase == .active {
                            // Ensure window is visible when becoming active
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                windowScene.windows.first?.isHidden = false
                                windowScene.windows.first?.makeKeyAndVisible()
                            }
                        }
                    }
                    .onChange(of: isAuthenticated) { oldValue, newValue in
                        if !newValue {
                            // Reset any necessary state when logged out
                            print("User logged out")
                        }
                    }
            }
        }
    }
}
