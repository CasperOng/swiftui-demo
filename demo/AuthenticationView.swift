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
            VStack(spacing: 24) {
                // Warning Banner
                VStack(spacing: 8) {
                    Label("Internal Testing Only", systemImage: "exclamationmark.triangle.fill")
                        .font(.headline)
                        .foregroundStyle(.orange)

                    Text("This is a development build for testing purposes only. Not for production use.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                Spacer()

                // App Logo or Icon
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.tint)
                    .padding()
                    .frame(minWidth: 44, minHeight: 44)
                    .accessibilityLabel("App logo")
                    .accessibilityHint("Tap multiple times to reveal developer skip option")
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
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Authentication Button
                VStack(spacing: 16) {
                    Button(action: authenticateWithBiometrics) {
                        HStack(spacing: 12) {
                            Image(systemName: "faceid")
                                .font(.title2)
                            Text("Authenticate with Face ID")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isAuthenticating)
                    .accessibilityLabel("Authenticate with Face ID")
                    .accessibilityHint("Double tap to authenticate using biometrics")

                    if isAuthenticating {
                        ProgressView()
                            .accessibilityLabel("Authenticating")
                    }

                    // Skip button (hidden by default, revealed by tapping logo 10 times)
                    if showSkipButton {
                        Button("Skip Authentication (Dev Only)") {
                            showingSkipPassword = true
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(minHeight: 44)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .navigationTitle("Authentication")
            .navigationBarTitleDisplayMode(.large)
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
            .alert("Developer Skip", isPresented: $showingSkipPassword) {
                SecureField("Password", text: $skipPassword)
                Button("Submit") {
                    if skipPassword == correctPassword {
                        isAuthenticated = true
                    } else {
                        showingSkipError = true
                    }
                    skipPassword = ""
                }
                Button("Cancel", role: .cancel) {
                    skipPassword = ""
                }
            } message: {
                Text("Enter the developer password to skip authentication.")
            }
            .alert("Incorrect Password", isPresented: $showingSkipError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("The password you entered is incorrect.")
            }
            .onAppear {
                checkIfSimulator()
            }
        }
    }

    private func checkIfSimulator() {
        #if targetEnvironment(simulator)
        isSimulator = true
        #endif
    }

    private func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            if let error = error as? LAError {
                switch error.code {
                case .biometryNotAvailable:
                    authError = "Face ID is not available on this device."
                case .biometryNotEnrolled:
                    authError = "No Face ID data is enrolled on this device."
                case .passcodeNotSet:
                    authError = "Please set up a passcode in Settings to use Face ID."
                default:
                    authError = "Biometric authentication is not available: \(error.localizedDescription)"
                }
            } else {
                authError = "Biometric authentication is not available."
            }
            showingAuthError = true
            return
        }

        isAuthenticating = true

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                             localizedReason: "Authenticate to access SwiftUI Demo") { success, error in
            DispatchQueue.main.async {
                isAuthenticating = false

                if success {
                    isAuthenticated = true
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
    AuthenticationView(isAuthenticated: .constant(false))
}
