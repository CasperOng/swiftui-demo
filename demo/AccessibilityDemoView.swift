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
    @State private var isLargeTextEnabled = false
    @State private var isReducedMotionEnabled = false
    @State private var isHighContrastEnabled = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Accessibility Controls
                VStack {
                    Toggle("Large Text", isOn: $isLargeTextEnabled)
                        .padding()
                    
                    Toggle("Reduced Motion", isOn: $isReducedMotionEnabled)
                        .padding()
                    
                    Toggle("High Contrast", isOn: $isHighContrastEnabled)
                        .padding()
                }
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                // Demo Content
                VStack(spacing: 20) {
                    // Header
                    Text("Accessibility Demo")
                        .font(.title)
                        .bold()
                        .accessibilityAddTraits(.isHeader)
                    
                    // Description
                    Text("This view demonstrates various accessibility features in SwiftUI.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .accessibilityLabel("Description: This view demonstrates various accessibility features in SwiftUI.")
                    
                    // Accessibility Examples
                    Group {
                        // Example 1: Basic Accessibility
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Basic Accessibility")
                                .font(.headline)
                            
                            HStack {
                                Image(systemName: "person.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                                    .accessibilityLabel("User profile icon")
                                
                                Text("John Doe")
                                    .font(.body)
                                    .accessibilityLabel("User name: John Doe")
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("Edit")
                                        .foregroundColor(.blue)
                                }
                                .accessibilityLabel("Edit user profile")
                                .accessibilityHint("Double tap to edit the user profile")
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("User profile section with name John Doe and edit button")
                        }
                        
                        // Example 2: Dynamic Type
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Dynamic Type")
                                .font(.headline)
                            
                            Text("This text will adjust based on the user's preferred text size.")
                                .font(isLargeTextEnabled ? .title : .body)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                                .accessibilityLabel("Dynamic type example text")
                        }
                        
                        // Example 3: Reduced Motion
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Reduced Motion")
                                .font(.headline)
                            
                            Image(systemName: "star.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.yellow)
                                .scaleEffect(isReducedMotionEnabled ? 1.0 : 1.2)
                                .animation(isReducedMotionEnabled ? nil : Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isReducedMotionEnabled)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                                .accessibilityLabel("Animated star icon")
                                .accessibilityHint("This star will animate if reduced motion is disabled")
                        }
                        
                        // Example 4: High Contrast
                        VStack(alignment: .leading, spacing: 8) {
                            Text("High Contrast")
                                .font(.headline)
                            
                            HStack {
                                Circle()
                                    .fill(isHighContrastEnabled ? .red : .pink)
                                    .frame(width: 30, height: 30)
                                    .accessibilityLabel("Red circle")
                                
                                Circle()
                                    .fill(isHighContrastEnabled ? .green : .mint)
                                    .frame(width: 30, height: 30)
                                    .accessibilityLabel("Green circle")
                                
                                Circle()
                                    .fill(isHighContrastEnabled ? .blue : .cyan)
                                    .frame(width: 30, height: 30)
                                    .accessibilityLabel("Blue circle")
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Color circles demonstrating high contrast")
                        }
                        
                        // Example 5: VoiceOver
                        VStack(alignment: .leading, spacing: 8) {
                            Text("VoiceOver")
                                .font(.headline)
                            
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(.red)
                                    Text("Notifications")
                                        .foregroundColor(.primary)
                                }
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .accessibilityLabel("Notifications button")
                            .accessibilityHint("Double tap to view your notifications")
                            .accessibilityAddTraits(.isButton)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
            }
            .padding()
        }
        .navigationTitle("Accessibility Demo")
    }
}

#Preview {
    NavigationStack {
        AccessibilityDemoView()
    }
} 