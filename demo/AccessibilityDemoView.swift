//
//  AccessibilityDemoView.swift
//  demo
//
//  Created by Casper Ong
//  Last Updated: April 16, 2025 01:53 UTC+8
//  Version: v1.0.0-alpha.1 (Initial Release)
//  Build: 2025.04.16.0153
//
//  This view demonstrates various accessibility features in SwiftUI.
//
//  Copyright © 2025 Casper Ong. All rights reserved.
//

import SwiftUI

struct AccessibilityDemoView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorSchemeContrast) private var contrast
    @Environment(\.legibilityWeight) private var legibilityWeight

    var body: some View {
        List {
            Section("Environment Detection") {
                LabeledContent("Dynamic Type Size") {
                    Text(String(describing: dynamicTypeSize))
                        .font(.caption)
                }
                LabeledContent("Reduce Motion") {
                    Text(reduceMotion ? "Enabled" : "Disabled")
                        .foregroundStyle(reduceMotion ? .orange : .secondary)
                }
                LabeledContent("Contrast") {
                    Text(contrast == .increased ? "Increased" : "Standard")
                }
                LabeledContent("Bold Text") {
                    Text(legibilityWeight == .bold ? "Enabled" : "Standard")
                }
            }

            Section("Accessibility Labels") {
                HStack {
                    Image(systemName: "person.fill")
                        .font(.title2)
                        .foregroundStyle(.tint)
                    Text("John Doe")
                    Spacer()
                    Button("Edit") {}
                        .buttonStyle(.bordered)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("John Doe, user profile")
                .accessibilityHint("Double tap Edit to modify the profile")
            }

            Section("Accessibility Traits") {
                Text("Section Header")
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)

                Button {} label: {
                    Label("Notifications", systemImage: "bell.fill")
                }
                .accessibilityLabel("Notifications")
                .accessibilityHint("Double tap to view your notifications")
                .badge(3)

                Toggle("Enable Feature", isOn: .constant(true))
                    .accessibilityHint("Double tap to toggle this feature on or off")
            }

            Section("Reduce Motion") {
                VStack(spacing: 12) {
                    Circle()
                        .fill(.tint)
                        .frame(width: 60, height: 60)
                        .scaleEffect(reduceMotion ? 1.0 : 1.0)

                    Text(reduceMotion
                         ? "Animations are disabled per your preference."
                         : "Animations are active. Enable Reduce Motion in Settings > Accessibility to simplify.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }

            Section("High Contrast") {
                HStack(spacing: 16) {
                    Circle()
                        .fill(.blue)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.primary.opacity(contrast == .increased ? 1 : 0), lineWidth: 2)
                        )
                    Circle()
                        .fill(.green)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.primary.opacity(contrast == .increased ? 1 : 0), lineWidth: 2)
                        )
                    Circle()
                        .fill(.orange)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.primary.opacity(contrast == .increased ? 1 : 0), lineWidth: 2)
                        )
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Color circles demonstrating high contrast borders")
            }

            Section("Accessibility Sort Priority") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("$9.99")
                        .font(.title2.bold())
                        .accessibilitySortPriority(1)
                    Text("Premium Widget")
                        .font(.headline)
                        .accessibilitySortPriority(2)
                    Text("A beautiful widget for your home screen")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .accessibilitySortPriority(0)
                }
                .padding(.vertical, 4)
            }

            Section("Accessibility Actions") {
                Text("Swipeable Item")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 4)
                    .accessibilityAction(named: "Delete") {
                        // Delete action
                    }
                    .accessibilityAction(named: "Archive") {
                        // Archive action
                    }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Accessibility")
    }
}

#Preview {
    NavigationStack {
        AccessibilityDemoView()
    }
}
