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
        NavigationStack(path: $path) {
            List {
                Section("Basic Navigation") {
                    NavigationLink("Go to Detail View", destination: DetailView())
                    NavigationLink("Go to Settings", destination: SettingsView())
                }
                
                Section("Programmatic Navigation") {
                    Button("Push to Detail") {
                        path.append("detail")
                    }
                    Button("Push to Settings") {
                        path.append("settings")
                    }
                    Button("Go Back") {
                        path.removeLast()
                    }
                }
                
                Section("Modal Presentations") {
                    Button("Show Sheet") {
                        showingSheet = true
                    }
                    Button("Show Full Screen") {
                        showingFullScreen = true
                    }
                }
                
                Section("Deep Links") {
                    NavigationLink("Home → Detail → Settings", value: ["home", "detail", "settings"])
                }
            }
            .navigationTitle("Navigation Demo")
            .navigationDestination(for: String.self) { route in
                switch route {
                case "detail":
                    DetailView()
                case "settings":
                    SettingsView()
                default:
                    Text("Unknown route")
                }
            }
            .navigationDestination(for: [String].self) { routes in
                NavigationStack {
                    List {
                        ForEach(routes, id: \.self) { route in
                            NavigationLink(route.capitalized, value: route)
                        }
                    }
                    .navigationDestination(for: String.self) { route in
                        switch route {
                        case "home":
                            Text("Home View")
                        case "detail":
                            DetailView()
                        case "settings":
                            SettingsView()
                        default:
                            Text("Unknown route")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingSheet) {
                SheetView()
            }
            .fullScreenCover(isPresented: $showingFullScreen) {
                FullScreenView()
            }
        }
    }
}

struct DetailView: View {
    var body: some View {
        List {
            Section {
                Text("This is a detail view")
                    .font(.headline)
                Text("You can navigate back using the back button or programmatically")
                    .foregroundStyle(.secondary)
            }
            
            Section {
                NavigationLink("Go to Settings", destination: SettingsView())
            }
        }
        .navigationTitle("Detail")
    }
}

struct SettingsView: View {
    var body: some View {
        List {
            Section {
                Text("This is a settings view")
                    .font(.headline)
                Text("Settings content goes here")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Settings")
    }
}

struct SheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("This is a sheet view")
                        .font(.headline)
                    Text("Sheets are modal presentations that slide up from the bottom")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Sheet")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FullScreenView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("This is a full screen view")
                        .font(.headline)
                    Text("Full screen covers take up the entire screen")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Full Screen")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStackDemoView()
} 