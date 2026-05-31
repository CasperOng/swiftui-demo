//
//  NavigationStackDemoView.swift
//  demo
//
//  Created by Casper Ong
//  Last Updated: April 16, 2025 01:53 UTC+8
//  Version: v1.0.0-alpha.1 (Initial Release)
//  Build: 2025.04.16.0153
//
//  This view demonstrates various navigation capabilities in SwiftUI.
//
//  Copyright © 2025 Casper Ong. All rights reserved.
//

import SwiftUI

struct NavigationStackDemoView: View {
    @State private var path = NavigationPath()
    @State private var showingSheet = false
    @State private var showingFullScreen = false

    var body: some View {
        List {
            Section("Basic Navigation") {
                NavigationLink("Detail View", destination: NavDetailView())
                NavigationLink("Settings View", destination: NavSettingsView())
            }

            Section("Programmatic Navigation") {
                Button("Push to Detail") {
                    path.append("detail")
                }
                Button("Push to Settings") {
                    path.append("settings")
                }
            }

            Section("Modal Presentations") {
                Button("Show Sheet") {
                    showingSheet = true
                }
                Button("Show Full Screen Cover") {
                    showingFullScreen = true
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Navigation")
        .navigationDestination(for: String.self) { route in
            switch route {
            case "detail":
                NavDetailView()
            case "settings":
                NavSettingsView()
            default:
                Text("Unknown route: \(route)")
            }
        }
        .sheet(isPresented: $showingSheet) {
            NavSheetView()
                .presentationDetents([.medium, .large])
        }
        .fullScreenCover(isPresented: $showingFullScreen) {
            NavFullScreenView()
        }
    }
}

// MARK: - Supporting Views

private struct NavDetailView: View {
    var body: some View {
        List {
            Section {
                Text("This is a detail view")
                    .font(.headline)
                Text("You can navigate back using the back button or swipe from the left edge.")
                    .foregroundStyle(.secondary)
            }

            Section {
                NavigationLink("Go to Settings", destination: NavSettingsView())
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Detail")
    }
}

private struct NavSettingsView: View {
    var body: some View {
        List {
            Section {
                Text("This is a settings view")
                    .font(.headline)
                Text("Settings content goes here")
                    .foregroundStyle(.secondary)
            }

            Section("Preferences") {
                Toggle("Notifications", isOn: .constant(true))
                Toggle("Dark Mode", isOn: .constant(false))
                LabeledContent("Version", value: "1.0.0")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
    }
}

private struct NavSheetView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("This is a sheet view")
                        .font(.headline)
                    Text("Sheets slide up from the bottom. Swipe down or tap Done to dismiss.")
                        .foregroundStyle(.secondary)
                }

                Section("Sheet Features") {
                    LabeledContent("Presentation") {
                        Text("Bottom sheet")
                    }
                    LabeledContent("Detents") {
                        Text("Medium, Large")
                    }
                    LabeledContent("Dismiss") {
                        Text("Swipe or button")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Sheet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

private struct NavFullScreenView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("This is a full screen cover")
                        .font(.headline)
                    Text("Full screen covers take up the entire screen and cannot be dismissed by swiping.")
                        .foregroundStyle(.secondary)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Full Screen")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        NavigationStackDemoView()
    }
}
