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
    @State private var selectedTab = 0
    @AppStorage("isAuthenticated") private var isAuthenticated = true
    
    var body: some View {
        NavigationStack {
            List {
                // Header Section
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome to SwiftUI Demo")
                            .font(.title)
                            .bold()
                        Text("Explore Apple's latest UI framework")
                            .foregroundStyle(.secondary)
                        Text("v1.0.0-alpha.1")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                
                // Authentication Section
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
                }
                
                // Layout & Stacks Section
                Section("Layout & Stacks") {
                    NavigationLink("VStack Demo", destination: VStackDemoView())
                    NavigationLink("HStack Demo", destination: HStackDemoView())
                    NavigationLink("ZStack Demo", destination: ZStackDemoView())
                    // NavigationLink("Grid Demo", destination: GridDemoView())
                    // NavigationLink("ScrollView Demo", destination: ScrollViewDemoView())
                }
                
                // Interactive Elements Section
                Section("Interactive Elements") {
                    NavigationLink("Controls Demo", destination: ControlsDemoView())
                    // NavigationLink("Buttons Demo", destination: ButtonsDemoView())
                    // NavigationLink("Gestures Demo", destination: GesturesDemoView())
                    NavigationLink("Animations Demo", destination: AnimationsDemoView())
                }
                
                // Data Display Section
                Section("Data Display") {
                    NavigationLink("Lists Demo", destination: ListsDemoView())
                    NavigationLink("Charts Demo", destination: ChartsDemoView())
                    // NavigationLink("Tables Demo", destination: TablesDemoView())
                    // NavigationLink("Text Demo", destination: TextDemoView())
                }
                
                // Navigation Section
                Section("Navigation") {
                    // NavigationLink("Navigation Stack Demo", destination: NavigationStackDemoView())
                    // NavigationLink("Tab View Demo", destination: TabViewDemoView())
                    // NavigationLink("Sheet Demo", destination: SheetDemoView())
                    // NavigationLink("Full Screen Cover Demo", destination: FullScreenCoverDemoView())
                }
                
                // System Integration Section
                Section("System Integration") {
                    NavigationLink("Notifications Demo", destination: NotificationsDemoView())
                    NavigationLink("Share Sheet Demo", destination: ShareSheetDemoView())
                    // NavigationLink("Haptics Demo", destination: HapticsDemoView())
                    // NavigationLink("Location Demo", destination: LocationDemoView())
                }
                
                // Graphics & Effects Section
                Section("Graphics & Effects") {
                    NavigationLink("Graphics & Effects Demo", destination: GraphicsEffectsDemoView())
                    // NavigationLink("Shapes Demo", destination: ShapesDemoView())
                    // NavigationLink("Gradients Demo", destination: GradientsDemoView())
                    // NavigationLink("Blur & Opacity Demo", destination: BlurOpacityDemoView())
                    // NavigationLink("Shadows Demo", destination: ShadowsDemoView())
                }
                
                // State & Data Flow Section
                Section("State & Data Flow") {
                    NavigationLink("State & Data Flow Demo", destination: StateDataFlowDemoView())
                    // NavigationLink("State Demo", destination: StateDemoView())
                    // NavigationLink("Binding Demo", destination: BindingDemoView())
                    // NavigationLink("Environment Demo", destination: EnvironmentDemoView())
                    // NavigationLink("Observable Demo", destination: ObservableDemoView())
                }
                
                // Accessibility Section
                Section("Accessibility") {
                    NavigationLink("Accessibility Demo", destination: AccessibilityDemoView())
                    // NavigationLink("VoiceOver Demo", destination: VoiceOverDemoView())
                    // NavigationLink("Dynamic Type Demo", destination: DynamicTypeDemoView())
                    // NavigationLink("Reduced Motion Demo", destination: ReducedMotionDemoView())
                }
                
                // About Section
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 4) {
                            Text("SwiftUI Demo")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("© 2025 Casper Ong")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("SwiftUI Demo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAuthenticated = false
                    }) {
                        Label("Lock App", systemImage: "lock.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .alert("Authentication Error", isPresented: $showingAuthError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authError)
            }
            .alert("Face ID Permission Required", isPresented: $showingPermissionAlert) {
                Button("Open Settings", role: .none) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Please enable Face ID access in Settings to use this feature.")
            }
        }
    }
    
    private func authenticateWithBiometrics() {
        isAuthenticating = true
        print("Starting Face ID authentication...")
        
        let context = LAContext()
        var error: NSError?
        
        // First check if biometric authentication is available
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        print("Can evaluate biometric policy: \(canEvaluate)")
        
        if let error = error {
            print("Biometric evaluation error: \(error.localizedDescription)")
            print("Error code: \(error.code)")
        }
        
        guard canEvaluate else {
            isAuthenticating = false
            if let error = error {
                print("Biometric authentication error: \(error.localizedDescription)")
                switch error.code {
                case LAError.biometryNotEnrolled.rawValue:
                    authError = "No biometric data is enrolled on this device."
                case LAError.biometryNotAvailable.rawValue:
                    authError = "Biometric authentication is not available on this device."
                case LAError.biometryLockout.rawValue:
                    authError = "Biometric authentication is locked out. Please use your device passcode."
                case LAError.authenticationFailed.rawValue:
                    showingPermissionAlert = true
                default:
                    authError = "Biometric authentication is not available: \(error.localizedDescription)"
                }
                showingAuthError = true
            }
            return
        }
        
        print("Starting Face ID evaluation...")
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                             localizedReason: "Test Face ID authentication") { success, error in
            DispatchQueue.main.async {
                isAuthenticating = false
                
                if success {
                    print("Authentication successful")
                    // You can add success feedback here if needed
                } else {
                    if let error = error as? LAError {
                        print("Authentication error: \(error.localizedDescription)")
                        print("Error code: \(error.code)")
                        
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
