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
            VStack(alignment: .leading, spacing: 6) {
                Text("SwiftUI Demo")
                    .font(.largeTitle)
                    .bold()
                Text("Apple UI Design Kit Reference")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding([.horizontal, .top])

            List {
                // Authentication
                Section("Authentication") {
                    Button(action: authenticateWithBiometrics) {
                        HStack {
                            Label("Test Face ID", systemImage: "faceid")
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

                // Layout & Stacks
                Section("Layout & Stacks") {
                    NavigationLink("VStack", destination: VStackDemoView())
                    NavigationLink("HStack", destination: HStackDemoView())
                    NavigationLink("ZStack", destination: ZStackDemoView())
                    NavigationLink("Grids & Layout", destination: GridDemoView())
                    NavigationLink("ScrollView", destination: ScrollViewDemoView())
                }

                // Navigation & Presentation
                Section("Navigation & Presentation") {
                    NavigationLink("NavigationStack", destination: NavigationStackDemoView())
                    NavigationLink("TabView", destination: TabViewDemoView())
                    NavigationLink("Sheets & Modals", destination: SheetsDemoView())
                    NavigationLink("Menus", destination: MenusDemoView())
                }

                // Controls & Input
                Section("Controls & Input") {
                    NavigationLink("Controls", destination: ControlsDemoView())
                    NavigationLink("Forms", destination: FormsDemoView())
                    NavigationLink("Searchable", destination: SearchableDemoView())
                }

                // Data & Media
                Section("Data & Media") {
                    NavigationLink("Lists & Grids", destination: ListsDemoView())
                    NavigationLink("Charts", destination: ChartsDemoView())
                    NavigationLink("PhotosPicker", destination: PhotosPickerDemoView())
                    NavigationLink("MapKit", destination: MapKitDemoView())
                }

                // Visual Design
                Section("Visual Design") {
                    NavigationLink("Typography", destination: TypographyDemoView())
                    NavigationLink("Color System", destination: ColorSystemDemoView())
                    NavigationLink("SF Symbols", destination: SFSymbolsDemoView())
                    NavigationLink("Graphics & Effects", destination: GraphicsEffectsDemoView())
                }

                // Animation & Feedback
                Section("Animation & Feedback") {
                    NavigationLink("Animations", destination: AnimationsDemoView())
                    NavigationLink("Gestures", destination: GesturesDemoView())
                    NavigationLink("Haptics", destination: HapticsDemoView())
                    NavigationLink("Progress & Gauges", destination: ProgressGaugeDemoView())
                }

                // System Integration
                Section("System Integration") {
                    NavigationLink("Notifications", destination: NotificationsDemoView())
                    NavigationLink("Share Sheet", destination: ShareSheetDemoView())
                    NavigationLink("Widgets", destination: WidgetPreviewDemoView())
                    NavigationLink("App Intents", destination: AppIntentsDemoView())
                    NavigationLink("Live Activities", destination: LiveActivityDemoView())
                }

                // Accessibility
                Section("Accessibility") {
                    NavigationLink("Accessibility", destination: AccessibilityDemoView())
                    NavigationLink("Dynamic Type", destination: DynamicTypeDemoView())
                }

                // State & Data Flow
                Section("State & Data Flow") {
                    NavigationLink("State & Data Flow", destination: StateDataFlowDemoView())
                }
            }
            .listStyle(.insetGrouped)
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

#Preview {
    ContentView()
}
