//
//  AuthenticationView.swift
//  demo
//
//  Created by Casper Ong
//  Last Updated: April 16, 2025 01:53 UTC+8
//  Version: v1.0.0-alpha.1 (Initial Release)
//  Build: 2025.04.16.0153
//
//  This view handles biometric authentication for the SwiftUI Demo application.
//  It provides a secure way to access the app using Face ID or Touch ID.
//
//  Copyright © 2025 Casper Ong. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct AuthenticationView: View {
    @Binding var isAuthenticated: Bool
    @State private var showingAuthError = false
    @State private var authError: String = ""
    @State private var showingPermissionAlert = false
    @State private var isAuthenticating = false
    @State private var isSimulator = false
    @State private var skipPassword = ""
    @State private var showingSkipPassword = false
    @State private var showingSkipError = false
    @State private var logoTapCount = 0
    @State private var showSkipButton = false
    
    // This should be stored securely in a real app
    private let correctPassword = "demo2025"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Warning Banner
                VStack(spacing: 8) {
                    Label("Internal Testing Only", systemImage: "exclamationmark.triangle.fill")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    Text("This is a development build for testing purposes only. Not for production use.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
                
                // App Logo or Icon
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding()
                    .onTapGesture {
                        logoTapCount += 1
                        if logoTapCount >= 10 {
                            withAnimation {
                                showSkipButton = true
                            }
                        }
                    }
                
                // Welcome Text
                VStack(spacing: 8) {
                    Text("Welcome to SwiftUI Demo")
                        .font(.title)
                        .bold()
                    
                    Text("Please authenticate to continue")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 30)
                
                // Authentication Button
                Button(action: authenticateWithBiometrics) {
                    HStack {
                        Label(isSimulator ? "Continue in Simulator" : "Authenticate with Face ID", 
                              systemImage: isSimulator ? "checkmark.shield.fill" : "faceid")
                        Spacer()
                        if isAuthenticating {
                            ProgressView()
                                .controlSize(.small)
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(isAuthenticating)
                .padding(.horizontal)
                
                // Skip Authentication Button (for testing)
                if showSkipButton {
                    Button("Skip Authentication (Testing Only)") {
                        showingSkipPassword = true
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
                    .transition(.opacity)
                }
                
                Spacer()
                
                // Version Info
                VStack(spacing: 4) {
                    Text("SwiftUI Demo")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("v1.0.0-alpha.1 (Testing Build)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
            }
            .padding()
            .onAppear {
                checkEnvironment()
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
            .alert("Enter Skip Password", isPresented: $showingSkipPassword) {
                SecureField("Enter password", text: $skipPassword)
                Button("Cancel", role: .cancel) {
                    skipPassword = ""
                }
                Button("Skip") {
                    if skipPassword == correctPassword {
                        isAuthenticated = true
                    } else {
                        showingSkipError = true
                    }
                    skipPassword = ""
                }
            } message: {
                Text("Please enter the password to bypass authentication.")
            }
            .alert("Incorrect Password", isPresented: $showingSkipError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("The password you entered is incorrect.")
            }
        }
    }
    
    private func checkEnvironment() {
        #if targetEnvironment(simulator)
        isSimulator = true
        print("Running in simulator - skipping biometric authentication")
        #else
        isSimulator = false
        print("Running on device - biometric authentication available")
        #endif
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
                             localizedReason: "Authenticate to access the SwiftUI Demo app") { success, error in
            DispatchQueue.main.async {
                isAuthenticating = false
                
                if success {
                    print("Authentication successful")
                    isAuthenticated = true
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
    AuthenticationView(isAuthenticated: .constant(false))
} 