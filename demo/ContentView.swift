//
//  ContentView.swift
//  demo
//
//  Created by Casper Ong
//  Last Updated: April 16, 2025 01:53 UTC+8
//  Version: v1.0.0-alpha.1 (Initial Release)
//  Build: 2025.04.16.0153
//
//  This is the main content view of the SwiftUI Demo application.
//  It provides navigation to various demo sections showcasing
//  different SwiftUI features and capabilities.
//
//  Copyright © 2025 Casper Ong. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingAuthError = false
    @State private var authError: String = ""
    @State private var showingPermissionAlert = false
    @State private var isAuthenticating = false
    @AppStorage("isAuthenticated") private var isAuthenticated = true

    var body: some View {
        NavigationStack {
            List {
                authenticationSection
                layoutSection
                navigationSection
                controlsSection
                dataSection
                visualSection
                animationSection
                systemSection
                accessibilitySection
                stateSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("SwiftUI Demo")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isAuthenticated = false
                    } label: {
                        Image(systemName: "lock.fill")
                    }
                    .accessibilityLabel("Lock app")
                    .accessibilityHint("Double tap to lock the app and return to authentication")
                }
            }
            .alert("Authentication Error", isPresented: $showingAuthError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authError)
            }
            .alert("Permission Required", isPresented: $showingPermissionAlert) {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Face ID permission is required. Please enable it in Settings.")
            }
        }
    }

    // MARK: - Sections

    @ViewBuilder
    private var authenticationSection: some View {
        Section("Authentication") {
            Button(action: authenticateWithBiometrics) {
                HStack {
                    Label {
                        Text("Test Face ID")
                            .foregroundStyle(.primary)
                    } icon: {
                        SettingsIcon(systemName: "faceid", color: .green)
                    }
                    Spacer()
                    if isAuthenticating {
                        ProgressView()
                            .controlSize(.small)
                    }
                }
            }
            .disabled(isAuthenticating)
            .accessibilityLabel("Test Face ID authentication")
            .accessibilityHint("Double tap to trigger biometric authentication")
        }
    }

    @ViewBuilder
    private var layoutSection: some View {
        Section("Layout & Stacks") {
            DemoRow("VStack", systemName: "arrow.up.arrow.down", color: .blue) { VStackDemoView() }
            DemoRow("HStack", systemName: "arrow.left.arrow.right", color: .blue) { HStackDemoView() }
            DemoRow("ZStack", systemName: "square.3.layers.3d", color: .indigo) { ZStackDemoView() }
            DemoRow("Grids & Layout", systemName: "square.grid.2x2", color: .indigo) { GridDemoView() }
            DemoRow("ScrollView", systemName: "scroll", color: .teal) { ScrollViewDemoView() }
        }
    }

    @ViewBuilder
    private var navigationSection: some View {
        Section("Navigation & Presentation") {
            DemoRow("NavigationStack", systemName: "rectangle.stack", color: .orange) { NavigationStackDemoView() }
            DemoRow("TabView", systemName: "menubar.rectangle", color: .orange) { TabViewDemoView() }
            DemoRow("Sheets & Modals", systemName: "rectangle.portrait.bottomhalf.filled", color: .pink) { SheetsDemoView() }
            DemoRow("Menus", systemName: "filemenu.and.selection", color: .purple) { MenusDemoView() }
        }
    }

    @ViewBuilder
    private var controlsSection: some View {
        Section("Controls & Input") {
            DemoRow("Controls", systemName: "switch.2", color: .green) { ControlsDemoView() }
            DemoRow("Forms", systemName: "list.bullet.rectangle.portrait", color: .green) { FormsDemoView() }
            DemoRow("Searchable", systemName: "magnifyingglass", color: .gray) { SearchableDemoView() }
        }
    }

    @ViewBuilder
    private var dataSection: some View {
        Section("Data & Media") {
            DemoRow("Lists & Grids", systemName: "list.bullet", color: .blue) { ListsDemoView() }
            DemoRow("Charts", systemName: "chart.xyaxis.line", color: .pink) { ChartsDemoView() }
            DemoRow("PhotosPicker", systemName: "photo.on.rectangle", color: .red) { PhotosPickerDemoView() }
            DemoRow("MapKit", systemName: "map", color: .green) { MapKitDemoView() }
        }
    }

    @ViewBuilder
    private var visualSection: some View {
        Section("Visual Design") {
            DemoRow("Typography", systemName: "textformat", color: .indigo) { TypographyDemoView() }
            DemoRow("Color System", systemName: "paintpalette", color: .orange) { ColorSystemDemoView() }
            DemoRow("SF Symbols", systemName: "star.circle", color: .pink) { SFSymbolsDemoView() }
            DemoRow("Graphics & Effects", systemName: "wand.and.rays", color: .purple) { GraphicsEffectsDemoView() }
        }
    }

    @ViewBuilder
    private var animationSection: some View {
        Section("Animation & Feedback") {
            DemoRow("Animations", systemName: "wand.and.stars", color: .purple) { AnimationsDemoView() }
            DemoRow("Gestures", systemName: "hand.tap", color: .blue) { GesturesDemoView() }
            DemoRow("Haptics", systemName: "iphone.radiowaves.left.and.right", color: .teal) { HapticsDemoView() }
            DemoRow("Progress & Gauges", systemName: "gauge.medium", color: .green) { ProgressGaugeDemoView() }
        }
    }

    @ViewBuilder
    private var systemSection: some View {
        Section("System Integration") {
            DemoRow("Notifications", systemName: "bell.badge", color: .red) { NotificationsDemoView() }
            DemoRow("Share Sheet", systemName: "square.and.arrow.up", color: .blue) { ShareSheetDemoView() }
            DemoRow("Widgets", systemName: "square.grid.3x3.square", color: .indigo) { WidgetPreviewDemoView() }
            DemoRow("App Intents", systemName: "app.badge.checkmark", color: .gray) { AppIntentsDemoView() }
            DemoRow("Live Activities", systemName: "bolt.horizontal.circle", color: .orange) { LiveActivityDemoView() }
        }
    }

    @ViewBuilder
    private var accessibilitySection: some View {
        Section("Accessibility") {
            DemoRow("Accessibility", systemName: "accessibility", color: .blue) { AccessibilityDemoView() }
            DemoRow("Dynamic Type", systemName: "textformat.size", color: .blue) { DynamicTypeDemoView() }
        }
    }

    @ViewBuilder
    private var stateSection: some View {
        Section("State & Data Flow") {
            DemoRow("State & Data Flow", systemName: "arrow.triangle.2.circlepath", color: .teal) { StateDataFlowDemoView() }
        }
    }

    // MARK: - Biometric Authentication

    private func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            authError = error?.localizedDescription ?? "Biometric authentication is not available."
            showingAuthError = true
            return
        }

        isAuthenticating = true

        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Authenticate to access the app"
        ) { success, error in
            DispatchQueue.main.async {
                isAuthenticating = false

                if success {
                    // Authentication successful
                } else {
                    if let error = error as? LAError {
                        switch error.code {
                        case .userCancel:
                            authError = "Authentication was cancelled."
                        case .authenticationFailed:
                            authError = "Authentication failed. Please try again."
                            showingPermissionAlert = true
                        case .systemCancel:
                            authError = "Authentication was cancelled by the system."
                        case .passcodeNotSet:
                            authError = "Please set up a passcode in Settings to use Face ID."
                        case .biometryNotEnrolled:
                            authError = "No Face ID data is enrolled on this device."
                        case .biometryNotAvailable:
                            authError = "Face ID is not available on this device."
                        case .biometryLockout:
                            authError = "Face ID is locked out. Please use your device passcode."
                        default:
                            authError = "Authentication failed: \(error.localizedDescription)"
                        }
                    } else {
                        authError = "Authentication failed with an unknown error."
                    }
                    showingAuthError = true
                }
            }
        }
    }
}

/// A single Settings-style menu row: a colored icon tile, a title, and a
/// navigation chevron (supplied automatically by NavigationLink).
private struct DemoRow<Destination: View>: View {
    let title: String
    let systemName: String
    let color: Color
    @ViewBuilder let destination: () -> Destination

    init(_ title: String, systemName: String, color: Color, @ViewBuilder destination: @escaping () -> Destination) {
        self.title = title
        self.systemName = systemName
        self.color = color
        self.destination = destination
    }

    var body: some View {
        NavigationLink {
            destination()
        } label: {
            Label {
                Text(title)
            } icon: {
                SettingsIcon(systemName: systemName, color: color)
            }
        }
    }
}

#Preview {
    ContentView()
}
